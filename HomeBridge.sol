pragma solidity ^0.4.24;


contract ERC721Caller {
    function getSerializedData(string) external returns(bytes);
    function transferFrom(address, address, string) external;    
    function recoveryToken(string, bytes) external;
}

 
contract HomeBridge {

    ///  This emits when transfer from _from to _to completed.
    event TransferCompleted(address indexed _from, address indexed _to, string indexed _tokenVIN);
    
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
        ERC721Caller(msg.sender).recoveryToken(_tokenVIN, data);        
        ERC721Caller(msg.sender).transferFrom(_from, _to, _tokenVIN);
        emit TransferCompleted(_from, _to, _tokenVIN);
    } 
}

