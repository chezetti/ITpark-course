pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "../MilitaryUnit/MilitaryUnit.sol";
import "../Interfaces/IBaseStation.sol";

contract Warrior is MilitaryUnit {

    uint private defenseStrength;
    uint private attackStrength;
    uint private health;
    address bsAddress;

    constructor(
        address baseStationAddress, uint _defenseStrength,
        uint _attackStrength, uint _health
        ) 
    public {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
        tvm.accept();
        callToAddMilitaryUnit(baseStationAddress, address(this));
        bsAddress = baseStationAddress;
        defenseStrength = _defenseStrength;
        attackStrength = _attackStrength;
        health = _health;
    }

    function callToAddMilitaryUnit(address baseStationAddress, address unit) public pure checkOwnerAndAccept {
        IBaseStation(baseStationAddress).militaryUnitAddition{value: 0.3 ton, flag: 1}(unit);
    }

    function callToAttack(address attackedAddress) public pure checkOwnerAndAccept {
        IGameObject(attackedAddress).takeAttack{value: 0.3 ton, flag: 1}();
    }

    function callToDeleteMilitaryUnit(address baseStationAddress, address unit) public pure checkOwnerAndAccept {
        IBaseStation(baseStationAddress).deleteMilitaryUnit{value: 0.3 ton, flag: 1}(unit);
    }

    function deathHandling(address destination) virtual external override {
        tvm.accept();
        selfdestruct(destination);
    }

    function getDefenseStrength() virtual public override view returns(uint) {
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