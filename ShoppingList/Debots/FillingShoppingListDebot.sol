pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./AShoppingListDebot.sol";
import "../ShoppingList/ShoppingList.sol";
import "../Interfaces/IShoppingList.sol";

contract FillingShoppingListDebot is AShoppingListDebot {

    string m_name;
    PurchasesStatistics purchases;      

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        _menu();
    }

    function _menu() private {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}, {}, {} (unpaid/paid/total) purchases",
                    purchases.unPaidCount,
                    purchases.paidCount,
                    purchases.paidCount + purchases.unPaidCount
            ),
            sep,
            [
                MenuItem("Add item to shopping list","",tvm.functionId(addToShoppingList)),
                MenuItem("Show purchases","",tvm.functionId(getShoppingList)),
                MenuItem("Delete item from shopping list","",tvm.functionId(deleteFromShoppingList))
            ]
        );
    }

    function addToShoppingList(uint32 index) public {
        index = index;
        Terminal.input(tvm.functionId(_addToShoppingList), "Please enter name of an item: ", false);
    }

    function _addToShoppingList(string value) public {
        m_name = value;
        Terminal.input(tvm.functionId(__addToShoppingList), "Please enter amount of an item: ", false);
    }

    function __addToShoppingList(string value) public view {
        (uint256 amount,) = stoi(value);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).shoppingListAddition{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_name ,uint32(amount));
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
        if (purchases.paidCount + purchases.unPaidCount > 0) {
            Terminal.input(tvm.functionId(_deleteFromShoppingList), "Enter item number from shopping list: ", false);
        } else {
            Terminal.print(0, "Sorry, you have no items at your shopping list");
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
    
}
