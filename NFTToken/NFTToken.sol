pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Plane {

    struct Token {
        string planeName;
        string planeType;
        uint fuelConsupmtion;
        uint planeSpeed;
    }

    Token[] tokensArr;
    mapping(uint => uint) tokenToOwner;
    mapping(uint => Token) tokenForSale;

    //ERRORS
    uint8 NOT_AN_ACCOUNT_OWNER = 101;
    uint8 EMPTY_SENDER_KEY = 102;
    uint8 TOKEN_ALREAY_EXISTS = 103;

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

    function createToken(string tokenPlaneName, string planeType, uint fuelConsupmtion, uint planeSpeed) public checkOwnerAndAccept{
        //require(tokensArr.planeName == tokenPlaneName, TOKEN_ALREAY_EXISTS);
        tokensArr.push(Token(tokenPlaneName, planeType, fuelConsupmtion, planeSpeed));
        uint lastKey = tokensArr.length - 1;
        tokenToOwner[lastKey] = msg.pubkey();
    }

    function putTokenOnMarket(uint tokenId, uint price) public checkOwnerAndAccept returns (mapping(uint => Token)) {
        tokenForSale[price] = tokensArr[tokenId];
        return tokenForSale;
    }

    function getTokenOwner(uint tokenId) public view returns (uint) {
        return tokenToOwner[tokenId];
    }

    function getTokenInfo(uint tokenId) public view returns (string tokenName, string tokenType, uint tokenFuelConsupmtion, uint tokenSpeed) {
        tokenName = tokensArr[tokenId].planeName;
        tokenType = tokensArr[tokenId].planeType;
        tokenFuelConsupmtion = tokensArr[tokenId].fuelConsupmtion;
        tokenSpeed = tokensArr[tokenId].planeSpeed;
    }

}
