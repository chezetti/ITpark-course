
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract listOfTasks {

    struct task {
        string name;
        uint32 timestamp;
        bool completeness;
    }

    mapping(int8 => task) tasksMapping; 

    int8 id = 1;

    //ERRORS
    uint8 NOT_AN_ACCOUNT_OWNER = 101;
    uint8 EMPTY_SENDER_KEY = 102;
    uint8 INVALID_FLAG = 103;

    constructor() public {
        require(tvm.pubkey() != 0, EMPTY_SENDER_KEY);
        require(msg.pubkey() == tvm.pubkey(), NOT_AN_ACCOUNT_OWNER);

        tvm.accept();
    }

    function addTask(string _name, bool _completeness) public returns (mapping(int8 => task)) {
        tvm.accept();
        tasksMapping[id] = task(_name, now, _completeness);
        id++;
        return tasksMapping;
    }

    function getTasksCount() public view returns (int8) {
        tvm.accept();
        int8 counter = 0;

        for((int8 key, task value) : tasksMapping){
            counter++;
        }

        return counter;
    }

    function getTasks() public view returns (mapping(int8 => task)) {
        return tasksMapping;
    }

    function getTaskByKey(int8 key) public returns (task) {
        tvm.accept();
        if (tasksMapping.exists(key)) {
            return tasksMapping[key];
        }
    }

    function deleteTaskByKey(int8 key) public {
        tvm.accept();
        if (tasksMapping.exists(key)) {
              delete tasksMapping[key];
        }
    }

    function markCompleteness(int8 key, bool flag) public returns (task) {
        require(flag == true || flag == false, INVALID_FLAG);
        tvm.accept();
        if (tasksMapping.exists(key)) {
            tasksMapping[key].completeness = flag;
        }
        return tasksMapping[key];
    }
}
