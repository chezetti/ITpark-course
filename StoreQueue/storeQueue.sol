pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract storeQueue {

    string[] private queue;

    //ERRORS
    uint8 NOT_AN_ACCOUNT_OWNER = 101;
    uint8 EMPTY_SENDER_KEY = 102;
    uint8 ARRAY_IS_EMPTY = 103;

    constructor() public {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);

        tvm.accept();

        queue.push("Billy");
        queue.push("Jonathan");
        queue.push("Bucky");
        queue.push("Steve");

    }

    function addToArray(string name) public returns (string[]) {
        tvm.accept();
        queue.push(name);
        return queue;
    }

    function deleteFromArray() public returns (string[]){
        require(queue.empty() == false, ARRAY_IS_EMPTY);
        tvm.accept();
         for (uint i = 0; i<queue.length-1; i++) {
            queue[i] = queue[i+1];
        }
        delete queue[queue.length-1];
        queue.pop();
        return queue;
    }

    function getQueue() public view returns (string[]) {
        return queue;
    }
}