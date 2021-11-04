pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "../Interfaces/IGameObject.sol";

contract GameObject is IGameObject {

    uint private defenseStrength;
    uint private attackStrength;
    uint private health;
    uint public ownerKey;
    address public ownerAddress;

    //ERRORS
    uint8 NOT_AN_ACCOUNT_OWNER = 100;
    uint8 WRONG_NUMBER_IS_GIVEN = 101;
    uint8 EMPTY_SENDER_KEY = 102;
    uint8 ALREADY_DEAD = 103;
    uint8 WRONG_ADDRESS = 104;
    uint8 UNIT_DOES_NOT_EXIST = 105;

    constructor() public {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
        tvm.accept();
        ownerKey = msg.pubkey();
        ownerAddress = msg.sender;
    }

    modifier checkOwnerAndAccept {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
		tvm.accept();
		_;
	}

    function takeAttack(uint _attackStrength) virtual external override {
        require(health != 0, ALREADY_DEAD);
        tvm.accept();
        address attackerAddress = msg.sender;
        if (_attackStrength > defenseStrength) {
            uint damage = _attackStrength - defenseStrength;
            if (damage > 0) {health -= damage;}
        }
        if (health <= 0) {selfdestruct(attackerAddress);}
    }

    function deathHandling(address attackerAddress) virtual external override checkOwnerAndAccept{
        tvm.accept();
        selfdestruct(attackerAddress);
    }

    function getDefenseStrength() virtual public view returns (uint){
        return defenseStrength;
    }

    function getHealth() virtual public view returns (uint) {
        return health;
    }

    function getAttackStrength() virtual public view returns (uint) {
        return attackStrength;
    }

    function setDefenseStrength(uint _defenseStrength) virtual public {
        require(_defenseStrength > 0, WRONG_NUMBER_IS_GIVEN);
        tvm.accept();
        defenseStrength = _defenseStrength;
    }

    function setHealth(uint _health) virtual public {
        require(_health > 0, WRONG_NUMBER_IS_GIVEN);
        tvm.accept();
        health = _health;
    }

    function setAttackStrength(uint _attackStrength) virtual public {
        require(_attackStrength > 0, WRONG_NUMBER_IS_GIVEN);
        tvm.accept();
        attackStrength = _attackStrength;
    }

}