pragma ton-solidity >= 0.35.0;

interface IGameObject {
    function takeAttack(uint _attackStrength) external;
    function deathHandling(address attackerAddress) external;
}