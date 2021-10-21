pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Multiplication {

	uint private result = 1;
	
	//ERRORS
    uint8 NOT_AN_ACCOUNT_OWNER = 101;
    uint8 EMPTY_SENDER_KEY = 102;
	uint8 INVALID_NUMBER = 103;

	constructor() public {
		require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
		require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
		tvm.accept();
		_;
	}

	function multiply(uint value) public checkOwnerAndAccept {
		require(value >= 1 && value <= 10, INVALID_NUMBER); 
			result = result*value;
	}

	function getResult() public view returns (uint) {
		return result;
	}

	function setResult(uint _result) public {
		tvm.accept();
		result = _result;
	}
}