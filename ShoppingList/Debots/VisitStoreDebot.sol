pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./AShoppingListDebot.sol";
import "../ShoppingList/ShoppingList.sol";
import "../Interfaces/IShoppingList.sol";

contract VisitStoreDebot is AShoppingListDebot {

    uint32 m_taskId;   
    uint32 m_price;

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        _menu();
    }

    function _menu() private {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}, {}, {} (unpaid/paid/total) purchases",
                    purchasesStatistics.unPaidCount,
                    purchasesStatistics.paidCount,
                    purchasesStatistics.paidCount + purchasesStatistics.unPaidCount
            ),
            sep,
            [
                MenuItem("Show purchases","",tvm.functionId(getShoppingList)),
                MenuItem("Delete item from shopping list","",tvm.functionId(deleteFromShoppingList)),
                MenuItem("Buy item from your shopping list","",tvm.functionId(buySomethingFromShoppingList))
            ]
        );
    }

    function getShoppingList(uint32 index) public view {
        index = index;
        optional(uint256) none;
        IShoppingList(m_address).getPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(_getShoppingList),
            onErrorId: 0
        }();
    }

    function _getShoppingList(Purchase[] _purchases) public {
        if (_purchases.length > 0 ) {
            Terminal.print(0, "Your shopping list: ");
            for (uint32 i = 0; i < _purchases.length; i++) {
                Purchase purchase = _purchases[i];
                string bought;
                if (purchase.isBought) {
                    bought = 'yes';
                } else {
                    bought = 'no';
                }
                Terminal.print(0, format("{} - {} have amount of {}, is bought? - {}, price is {}, added at {}", purchase.id,  purchase.name, purchase.amount, bought, purchase.price, purchase.createdAt));
            }
        } else {
            Terminal.print(0, "Your shopping list is empty");
        }
        _menu();
    }

    function deleteFromShoppingList(uint32 index) public {
        index = index;
        if (purchasesStatistics.paidCount + purchasesStatistics.unPaidCount > 0) {
            Terminal.input(tvm.functionId(_deleteFromShoppingList), "Enter item number from shopping list: ", false);
        } else {
            Terminal.print(0, "Sorry, entered number not found");
            _menu();
        }
    }

    function _deleteFromShoppingList(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).deleteFromShoppingList{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(num));
    }

    function buySomethingFromShoppingList(uint32 index) public {
        index = index;
        if (purchasesStatistics.paidCount + purchasesStatistics.unPaidCount > 0) {
            Terminal.input(tvm.functionId(_buySomethingFromShoppingList), "Enter item number from shopping list: ", false);
        } else {
            Terminal.print(0, "Sorry, you have no items at your shopping list");
            _menu();
        }
    }

    function _buySomethingFromShoppingList(string value) public {
        (uint256 num,) = stoi(value);
        m_taskId = uint32(num);

        Terminal.input(tvm.functionId(__buySomethingFromShoppingList), "What is the price of an item?", false);
    }

    function __buySomethingFromShoppingList(string value) public {
        (uint256 num,) = stoi(value);
        m_price = uint32(num);

        Terminal.input(tvm.functionId(___buySomethingFromShoppingList), "Are you sure you want to buy this item? (yes/no)", false);
    }

    function ___buySomethingFromShoppingList(string value) public view {
        bool bought;
        if (value == "yes") {
            bought = true;
        }
        else if (value == "no") {
            bought = false;
        }
        else tvm.functionId(onError);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).buySomethingFromShoppingList{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_taskId, bought, m_price);
    }

    function _getPurchaseStatistics(uint32 answerId) public override view {
        optional(uint256) none;
        IShoppingList(m_address).getPurchasesStatistics{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }

    function setPurchaseStatistics(PurchasesStatistics _purchasesStatistics) public override {
        purchasesStatistics = _purchasesStatistics;
        _menu();
    }

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Visit Store Debot";
        version = "v1";
        publisher = "Riezowe Kawatashi";
        key = "ShoppingList manager";
        author = "Riezowe Kawatashi";
        support = address(0);
        hello = "Hello, i'm a Visit Store Debot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

}
