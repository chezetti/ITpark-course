pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "../Interfaces/IGameObject.sol";
import "../Interfaces/IBaseStation.sol";

contract BaseStation is IBaseStation, IGameObject {

    uint private defenseStrength;
    uint private health;
    uint private attackStrength;
    address private ownerAddress;
    bool dead;
    mapping(address => bool) militaryUnit_m;

    //ERRORS
    uint8 NOT_AN_ACCOUNT_OWNER = 100;
    uint8 WRONG_NUMBER_IS_GIVEN = 101;
    uint8 EMPTY_SENDER_KEY = 102;
    uint8 UNIT_DOES_NOT_EXIST = 103;
    uint8 ALREADY_DEAD = 104;

    constructor(uint _health) public {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
        tvm.accept();
        health = _health;
    }

    modifier checkOwnerAndAccept {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
		tvm.accept();
		_;
	}

    function militaryUnitAddition(address unit) virtual external override {
        tvm.accept();
        militaryUnit_m[unit] = true;
    }

    function deleteMilitaryUnit(address unit) virtual public override {
        require(militaryUnit_m.exists(unit) == true, UNIT_DOES_NOT_EXIST);
        tvm.accept();
        delete militaryUnit_m[unit];
    }

    function takeAttack() virtual external override {
        require(health != 0, ALREADY_DEAD);
        tvm.accept();
        ownerAddress = msg.sender;
        health = attackStrength - defenseStrength;
    }

    function isKilled() virtual external override returns(bool){
        if (health == 0) {
            return dead = true;
        }
    }

    function deathHandling(address destination) virtual external override {
        tvm.accept();
        for((address unit, bool status) : militaryUnit_m){
            deleteMilitaryUnit(unit);
        }
        selfdestruct(destination);
    }

    function getMapping() virtual public override view returns(mapping(address => bool)) {
        for((address unit, bool status) : militaryUnit_m){
            return militaryUnit_m;
        }
    }

    function getDefenseStrength() virtual public override view returns(uint){
        return defenseStrength;
    }

    function getHealth() virtual public override view returns (uint) {
        return health;
    }

    function getAttackStrength() virtual public override view returns (uint) {
        return attackStrength;
    }

    function setDefenseStrength(uint _defenseStrength) virtual public override {
        require(_defenseStrength > 0, WRONG_NUMBER_IS_GIVEN);
        tvm.accept();
        defenseStrength = _defenseStrength;

    }

    function setHealth(uint _health) virtual public override {
        require(_health > 0, WRONG_NUMBER_IS_GIVEN);
        tvm.accept();
        health = _health;
    }

    function setAttackStrength(uint _attackStrength) virtual public override {
        require(_attackStrength > 0, WRONG_NUMBER_IS_GIVEN);
        tvm.accept();
        attackStrength = _attackStrength;
    }

}