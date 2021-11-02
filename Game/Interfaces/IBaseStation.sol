pragma ton-solidity >= 0.35.0;

interface IBaseStation {
    function isKilled(address militaryUnit) external returns(bool);
    function militaryUnitAddition(address unit) external;
    function deleteMilitaryUnit(address unit) external;
}