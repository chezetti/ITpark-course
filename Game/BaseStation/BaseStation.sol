pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "../GameObject/GameObject.sol";
import "../Interfaces/IGameObject.sol";
import "../Interfaces/IBaseStation.sol";

contract BaseStation is GameObject, IBaseStation {

    uint private unitIndex;
    mapping(address => uint8) militaryUnit_m;

    constructor(uint _health, uint _defenseStrength) public {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
        tvm.accept();
        setHealth(_health);
        setDefenseStrength(_defenseStrength);
    }

    function militaryUnitAddition(address unit) virtual external override {
        tvm.accept();
        unitIndex++;
        militaryUnit_m[unit] = uint8(unitIndex);
    }

    function deleteMilitaryUnit(address unit) virtual public override {
        require(militaryUnit_m.exists(unit) == true, UNIT_DOES_NOT_EXIST);
        tvm.accept();
        delete militaryUnit_m[unit];
    }

    function isKilled(address militaryUnit) virtual external override returns(bool){
        require(militaryUnit_m.exists(militaryUnit) == true, UNIT_DOES_NOT_EXIST);
        tvm.accept();
        bool dead;
        if (militaryUnit_m.exists(militaryUnit)) {
            dead = false;            
            }
        else {
            dead = true;
        }
    }

    function deathHandling(address attackerAddress) virtual external override {
        tvm.accept();
        for((address unit, uint8 index) : militaryUnit_m){
            IGameObject(militaryUnit_m[unit]).deathHandling{value: 0.3 ton, flag: 1}(attackerAddress);
            deleteMilitaryUnit(unit);
        }
        selfdestruct(attackerAddress);
    }

    function getMapping() virtual public view returns(mapping(address => uint8)) {
        for((address unit, uint8 index) : militaryUnit_m){
            return militaryUnit_m;
        }
    }

}