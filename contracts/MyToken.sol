pragma solidity ^0.4.20;

//import "../Owned.sol";
contract Owned {
    address public owner;

    constructor () public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
      }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract MyToken is Owned {

    string public tokenName;
    string public tokenSymbol;
    uint public initialSupply;
    uint8 public decimal;
    uint public totalSupply;

    mapping (address => uint) public balanceOf;
    mapping (address => bool) public frozenAccount;
    mapping (address => mapping (address => uint)) public allowance;

    event Transfer(address indexed from, address indexed to, uint value);
    event FrozenFunds(address targetAccount, bool freeze);

    constructor (string _tokenName, string _tokenSymbol, uint _initialSupply, uint8 _decimalValue) public {
        balanceOf[msg.sender] = _initialSupply;
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        decimal = _decimalValue;
        totalSupply = _initialSupply;
    }

    function _transferFunds(address _from, address _to, uint value) internal {
        require(balanceOf[msg.sender] >= value);
        require(balanceOf[_to] + value > balanceOf[_to]);
        require(!frozenAccount[_from]);
        require(!frozenAccount[_to]);
        balanceOf[_from] -= value;
        balanceOf[_to] += value;
        emit Transfer(_from, _to, value);
    }

    function transfer(address _from, address _to, uint value) public returns (bool sucess) {
        require(allowance[_from][msg.sender] >= value);
        _transferFunds(_from, _to, value);
        return true;
    }

    function mintTokens(address targetAddress, uint newTokens) onlyOwner public {
        balanceOf[targetAddress] += newTokens;
        totalSupply += newTokens;
        emit Transfer(owner, targetAddress, newTokens);
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function freezeAccount(address targetAccount, bool freeze) onlyOwner public {
        frozenAccount[targetAccount] = freeze;
        emit FrozenFunds(targetAccount, freeze);
    }
}
