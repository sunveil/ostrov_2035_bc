pragma solidity ^0.4.24;


contract ERC721Caller {
    function getSerializedData(string) external returns(bytes);
    function transferFrom(address, address, string) external;    
    function recoveryToken(string, bytes) external;
}

library Validator {
  struct data {
     //uint val;
     bool isValidator;
   }
}
 
contract HomeBridge {
    
    using Validator for Validator.data;
    
    mapping(bytes32 => bool) public tokenRecovered;
    mapping(address => bool) public tokenValidaotrs;
    mapping(bytes32 => bool) public alreadyHandled;
    mapping(bytes32 => uint) public sigCollected;

    uint reqieredSignatures;
    address sender; 
    bytes32 txHash;
    
    constructor(address[] _validators, uint _reqieredSignatures) {
        for (uint i = 0; i < _validators.length; i++) {
            tokenValidaotrs[_validators[i]] = true;
        }
        reqieredSignatures = _reqieredSignatures;
        sender = msg.sender;
    }  

    ///  This emits when transfer from _from to _to completed.
    event TransferCompleted(address indexedFrom, address indexed _to, string indexed _tokenVIN);
    
    /// ToDO ???
    event UserRequestForSignature(address indexed _from);

    function onERC721Received(address _from, address _to, 
        string _tokenVIN, bytes _data) public returns(bytes4) {
        bytes memory data = ERC721Caller(msg.sender).getSerializedData(_tokenVIN);
        transferApproved(_from, _to, _tokenVIN, data);
        ERC721Caller(msg.sender).transferFrom(_from, _to, _tokenVIN);
        emit UserRequestForSignature(_from);
    }
    
    function transferApproved(address _from, address _to, string _tokenVIN, bytes data) {
        
        require(tokenValidaotrs[_from] == true);
        bytes32 vHash = keccak256(txHash, sender);
        require(alreadyHandled[vHash] != true); 
        alreadyHandled[vHash];
        sigCollected[vHash] += 1;
        require(tokenRecovered[vHash] == false);
        require(sigCollected[vHash] >= reqieredSignatures);
        ERC721Caller(msg.sender).recoveryToken(_tokenVIN, data);        
        ERC721Caller(msg.sender).transferFrom(_from, _to, _tokenVIN);
        emit TransferCompleted(_from, _to, _tokenVIN);
    } 
    
}

