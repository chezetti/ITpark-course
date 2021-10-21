pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {

    //ERRORS
    uint NOT_AN_ACCOUNT_OWNER = 101;
    uint EMPTY_SENDER_KEY = 102;


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

    function transferWithoutFee(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 1);
    }

    function transferWithFee(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 0);
    }

    function transferAllValue(address dest) public pure checkOwnerAndAccept {
        dest.transfer(1, true, 160);
    }
}