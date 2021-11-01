pragma ton-solidity >= 0.35.0;

interface IGameObject {
    function getHealth() external view returns (uint);
    function setHealth(uint _health) external;
    function deathHandling(address destination) external;
}