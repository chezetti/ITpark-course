pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "../MilitaryUnit/MilitaryUnit.sol";

contract Archer is MilitaryUnit {

    address private bsAddress;

    constructor(
        address baseStationAddress, uint _defenseStrength,
        uint _attackStrength, uint _health
        ) 
    public {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
        tvm.accept();
        callToAddMilitaryUnit(baseStationAddress);
        bsAddress = baseStationAddress;
        setDefenseStrength(_defenseStrength);
        setAttackStrength(_attackStrength);
        setHealth(_health);
    }

    function getBaseStationAddress() public view returns (address) {
        return bsAddress;
    }

}