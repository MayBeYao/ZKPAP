// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

contract SignatureVerification {
    // function verifySignature(//GPT版本
    //     bytes32 data,
    //     uint8 v,
    //     bytes32 r,
    //     bytes32 s
    // ) public pure returns (address) {
    //     // 构造消息哈希
    //     bytes32 messageHash = keccak256(abi.encodePacked(data));
        
    //     // 使用ECDSA恢复签名者的地址
    //     address signer = ecrecover(messageHash, v, r, s);
        
    //     return signer;
    // }

    function verify(address _signer,string memory _message,bytes memory _sig)
        external  pure returns (bool)
        {
            bytes32  messageHash=getMessageHash(_message);
            bytes32  ethSignedMessageHash=getEthSignedMessageHash(messageHash);

            return recover(ethSignedMessageHash,_sig)==_signer;
        }
    
    function getMessageHash(string memory _message) public pure returns (bytes32){
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32){
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _messageHash
            ));
    }

    function recover(bytes32 _ethSignedMessageHash,bytes memory _sig)
        public pure returns (address)
        {
            (bytes32 r,bytes32 s,uint8 v)=_split(_sig);
            return  ecrecover(_ethSignedMessageHash, v, r, s);
        }
    function  _split(bytes memory _sig) internal pure 
        returns (bytes32 r,bytes32 s,uint8 v)
    {
        require(_sig.length==65,"invalid signature length");

        assembly{
            r:=mload(add(_sig,32))
            s:=mload(add(_sig,64))
            v:=byte(0,mload(add(_sig,96)))
        }
        return (r,s,v);
    }
}
