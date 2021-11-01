pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "../Interfaces/IGameObject.sol";
import "../Interfaces/IBaseStation.sol";

contract BaseStation is IBaseStation, IGameObject {

    uint private health;
    address private ownerAddress;
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

    function isKilled(address militaryUnit) virtual external override returns(bool){
        tvm.accept();
        bool dead;
        if (militaryUnit_m.exists(militaryUnit)) {
            dead = false;            
            }
        else {
            dead = true;
        }
    }

    function deathHandling(address destination) virtual external override {
        tvm.accept();
        for((address unit, bool status) : militaryUnit_m){
            IGameObject(unit).deathHandling{value: 0.3 ton, flag: 1}(destination);
            deleteMilitaryUnit(unit);
        }
        selfdestruct(destination);
    }

    function getMapping() virtual public view returns(mapping(address => bool)) {
        for((address unit, bool status) : militaryUnit_m){
            return militaryUnit_m;
        }
    }

    function getHealth() virtual public override view returns (uint) {
        return health;
    }

    function setHealth(uint _health) virtual public override {
        require(_health > 0, WRONG_NUMBER_IS_GIVEN);
        tvm.accept();
        health = _health;
    }

}