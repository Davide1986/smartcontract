pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

contract Voter {
    
    //Struttura che ci servirà per sapere se una stringa è già inserita o meno 
    //Se è presente o meno un elemento in quella posizione
    struct OptionPos {
        uint pos;
        bool exists;
    }
    
    uint[] public votes;
    string[] public options;
    mapping (address => bool) hasVoted;
    mapping (string => OptionPos) posOfOption;
    
    constructor(string[] _options) public {
        
        //Viene eseguito prima della creazione del contratto
        options = _options;
        votes.length = options.length;
        
        //Sto mappando l'array dei elementi di tutti i candidati al voto
        //Nel nostro caso di partenza ["coffè","tè"] index [0,1]
        for(uint i=0; i<options.length; i++){
            OptionPos memory optionPos = OptionPos(i,true); //usiamo una variabile temporanea e meno costosa di gas
            string optionName = options[i];  //option[0] = "coffè"
            posOfOption[optionName] = optionPos; //posOfOption["caffè"] = optionPos({pos:0,bool:true});
        }
        
        
    }
    
    function vote(uint option) public {
        require(0 <= option && option < options.length, "Invalid option");
        require(!hasVoted[msg.sender], "Account has already voted");
        
        votes[option] = votes[option] + 1;
        hasVoted[msg.sender] = true;
    }
    
    function vote(string optionName) public {
        require(!hasVoted[msg.sender], "Account has already voted");
        
        OptionPos memory optionPos =posOfOption[optionName];
        require(optionPos.exists, "Option does not exist"); //prima di procedere controlla che ci siano almeno i candidati
        
        votes[optionPos.pos] = votes[optionPos.pos]  + 1;
        hasVoted[msg.sender] = true; //ci serve perché non vogliamo che lo stesso account possa votare più di una volta
        
    }
    
    function getOptions() public view returns (string[]){
        return options;
    }
    
    function getVotes() public view returns (uint[]){
        return votes;    
    }
    
}
