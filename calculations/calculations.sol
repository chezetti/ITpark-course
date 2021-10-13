pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Multiplication {

	uint private result = 1;
	
	//INVALID_NUMBER = 103

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	function multiply(uint value) public checkOwnerAndAccept {
		require(value >= 1 && value <= 10, 103); 
			result = result*value;
	}

	function getResult() public view returns (uint) {
		return result;
	}

	function setResult(uint _result) public {
		result = _result;
	}
}