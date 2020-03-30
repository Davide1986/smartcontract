pragma solidity >=0.4.0;
pragma experimental ABIEncoderV2;

contract MultiSigWallets {
    uint minApprovers; 
    
    address payable beneficiary; 
    address payable owner; 
    
    mapping (address => bool) approvedBy;
    mapping (address => bool) isApprovver;
    uint approvalsNum;
    
    constructor(
        address [] memory _approvers,
        uint  _minApprovers,
        address payable _beneficiary
    ) public payable {
        
        require(_minApprovers <= _approvers.length, 
                "Required number of apporvers should be less than number of approvers");
        
        minApprovers = _minApprovers;
        beneficiary = _beneficiary;
        owner = msg.sender;
        
        for (uint i=0; i<_approvers.length; i++){
            address approver = _approvers[i];
            isApprovver[approver] = true;
        }
        
        
    }
    
    function approve() public {
        require(isApprovver[msg.sender], "Not an approver");
        if (!approvedBy[msg.sender]){
            approvalsNum++;
            approvedBy[msg.sender] = true;
        }
        
        if(approvalsNum == minApprovers){
            beneficiary.transfer(address(this).balance);
            selfdestruct(owner);
        }
    }
    
    function reject() public {
        require(isApprovver[msg.sender], "Not an approver");
        
        selfdestruct(owner);
    }
    
}
