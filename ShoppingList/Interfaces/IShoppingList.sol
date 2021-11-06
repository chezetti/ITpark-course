pragma ton-solidity >= 0.35.0;

   struct Purchase {
     uint32 id;
      string name;
      uint32 amount;
      uint64 createdAt;
      bool isBought;
      uint32 price;
   }

   struct PurchasesStatistics {
      uint32 paidCount;
      uint32 unPaidCount;
   }

interface IShoppingList {
   function shoppingListAddition(string name, uint32 amount) external;
   function buySomethingFromShoppingList(uint32 id, bool bought, uint32 price) external;
   function deleteFromShoppingList(uint32 id) external;
   function getPurchases() external view returns (Purchase[] purchases);
   function getPurchasesStatistics() external view returns (PurchasesStatistics purchasesStatistics);
}