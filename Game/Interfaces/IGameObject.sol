pragma ton-solidity >= 0.35.0;

interface IGameObject {
    function getDefenseStrength() external view returns (uint);
    function setDefenseStrength(uint _defenseStrength) external;
    function getHealth() external view returns (uint);
    function setHealth(uint _livesNumber) external; 
    function getAttackStrength() external view returns (uint);
    function setAttackStrength(uint _attackStrength) external;
    function takeAttack() external;
    function isKilled() external returns(bool);
    function deathHandling(address destination) external;
}