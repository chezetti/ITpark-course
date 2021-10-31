pragma ton-solidity >= 0.35.0;

interface IBaseStation {
    function getMapping() external view returns(mapping(address => bool));
    function militaryUnitAddition(address unit) external;
    function deleteMilitaryUnit(address unit) external;
}