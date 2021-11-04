pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "../GameObject/GameObject.sol";
import "../Interfaces/IGameObject.sol";
import "../Interfaces/IBaseStation.sol";

contract MilitaryUnit is GameObject {

    constructor() public {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
        tvm.accept();
    }

    function callToAddMilitaryUnit(address baseStationAddress) public pure checkOwnerAndAccept {
        IBaseStation(baseStationAddress).militaryUnitAddition{value: 0.3 ton, flag: 1}(address(this));
    }

    function callToAttack(address attackedAddress) public view checkOwnerAndAccept {
        require(address(this) != attackedAddress, WRONG_ADDRESS);
        IGameObject(attackedAddress).takeAttack{value: 0.3 ton, flag: 1}(getAttackStrength());
    }

    function callToDeleteMilitaryUnit(address baseStationAddress) public pure checkOwnerAndAccept {
        IBaseStation(baseStationAddress).deleteMilitaryUnit{value: 0.3 ton, flag: 1}(address(this));
    }

    function callToCheckDeath(address baseStationAddress) public pure checkOwnerAndAccept {
        IBaseStation(baseStationAddress).isKilled{value: 0.3 ton, flag: 1}(address(this));
    }

}