pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "../Interfaces/IShoppingList.sol";

contract ShoppingList is IShoppingList {
    
    uint32 m_count;
    uint256 m_ownerPubkey;
    mapping(uint32 => Purchase) m_purchases;

    //ERRORS
    uint8 NOT_AN_ACCOUNT_OWNER = 100;
    uint8 EMPTY_SENDER_KEY = 101;
    uint8 DOES_NOT_EXIST = 102;

    constructor(uint256 pubkey) public {
        require(pubkey != 0, EMPTY_SENDER_KEY);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    modifier checkOwnerAndAccept {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);
		tvm.accept();
		_;
	}

    function shoppingListAddition(string name, uint32 amount) public override checkOwnerAndAccept {
        m_count++;
        m_purchases[m_count] = Purchase(m_count, name, amount, now, false, 0);
    }

    function deleteFromShoppingList(uint32 id) public override checkOwnerAndAccept {
        require(m_purchases.exists(id), DOES_NOT_EXIST);
        delete m_purchases[id];
        m_count--;
    }

    function buySomethingFromShoppingList(uint32 id, bool bought, uint32 price) public override checkOwnerAndAccept {
        optional(Purchase) purchase = m_purchases.fetch(id);
        require(purchase.hasValue(), DOES_NOT_EXIST);
        Purchase thisPurchase = purchase.get();
        thisPurchase.isBought = bought;
        thisPurchase.price = price;
        m_purchases[id] = thisPurchase;
    }

    function getPurchases() public view override returns (Purchase[] purchases) {
        string name;
        uint32 amount;
        uint64 createdAt;
        bool isBought;
        uint32 price;

        for((uint32 id, Purchase purchase) : m_purchases) {
            name = purchase.name;
            amount = purchase.amount;
            createdAt = purchase.createdAt;
            isBought = purchase.isBought;
            price = purchase.price;
            purchases.push(Purchase(id, name, amount, createdAt, isBought, price));
       }
    }

    function getPurchasesStatistics() public view override returns (PurchasesStatistics purchasesStatistics) {
        uint32 paidCount;
        uint32 unPaidCount;

        for((, Purchase purchase) : m_purchases) {
            if  (purchase.isBought) {
                paidCount++;
            } else {
                unPaidCount++;
            }
        }

        purchasesStatistics = PurchasesStatistics(paidCount, unPaidCount);
    }
}

