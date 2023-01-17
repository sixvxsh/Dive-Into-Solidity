// // SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

contract A {
    uint public x;
    uint public y;

    address public owner;
    uint public createdAt;

    constructor(uint _x , uint _y) public {
        x = _x;
        y = _y;

        owner = msg.sender;
        createdAt = block.timestamp;
    }
}
    
-----------------------------------------------------------------------------------------------

contract A {
    string public name;

    constructor(string memory _name) public {
        name = _name;
    }
}

contract B is A {
    constructor(string memory _name) A(_name) public {   
    }
}

-----------------------------------------------------------------------------------------------

contract A {
    function foo() public pure returns(string memory) {
        return "A";
    } 
}

contract B {
    // function bar() public pure returns(string memory) {
    //     return "B";
    // }
    function foo() public pure returns(string memory) {
        return "B";
    } 
}

contract C is A, B {

}

contract D is A, C {

}


-----------------------------------------------------------------------------------------------
contract A {
    event Log(string message);

    function foo() public {
        emit Log("A.foo was called");
    }
    function bar() public {
        emit Log("A.bar called");
    }
}

contract B is A {
    function foo() public {
        emit Log("B.foo was called");
        A.foo();
    }
    function bar() public {
        emit Log("B.bar called");
        super.bar();
    }
}

contract C is A {
    function foo() public {
        emit Log("C.foo was called");
        A.foo();
    }
    function bar() public {
        emit Log("C.bar called");
        super.bar();
    }

}

contract D is B ,C {
}

-----------------------------------------------------------------------------------------------
contract X {
    string public name;
    constructor(string memory _name) public {
    name = _name;
    }
}

contract Y {
    string public text;
    constructor(string memory _text) public {
        text = _text;
    }
}


contract B is X("fixed input"), Y("Another fixed input") {
}

contract C is X, Y {
    constructor() X("Another way to hard code input") Y("Another hardcode input") public {
    }
}

contract D is X, Y {
    constructor(string memory _name, string memory _text) X(_name) Y(_text) public {

    }
}

-----------------------------------------------------------------------------------------------

contract X {
    event Log(string message);

    string public name;
    constructor(string memory _name) public {
    name = _name;

    emit Log(_name);
    }
}

contract Y {
    event Log(string text);

    string public text;
    constructor(string memory _text) public {
        text = _text;

        emit Log(_text);
    }
}

contract E is X, Y {
    constructor() X("X was called") Y("Y was called") public {

    }
}

contract F is X, Y {
    constructor() Y("Y was called") X("X was called")public {

    }
}
// notice:
// parent constructors are allways called in the order in which they are inherited  

-------------------------------------------------------------------------------------------------

contract A {
    address public addr = 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8;

    function getAddress() public view returns (address) {
        return addr;
    }
}

contract B is A {
    // it's a big mistake to override a parent variable with declaration
    //  a state variable in a child contract 
    address public addr = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
}

contract C is A {
    // it's better to use a constructor to overriding
    constructor() public {
        addr = 0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC;
    }
}

// to override state variable of a parent:
// don't re-declare in child contract / instead re-asssign it


---------------------------------------------------------------------------------------------------

// Visibility

contract Base {
    function privatefunc() private pure returns (string memory) {
        return "private func called";
    }
    function testprivatefunc() public pure returns (string memory) {
        return privatefunc();
    }
    function internalfunc() internal pure returns(string memory) {
        return "internal func called";
    }
    function testinternalfunc() public pure returns (string memory) {
        return internalfunc();
    }
    function publicfunc() public pure returns (string memory) {
        return "public func called";
    }

    function externalfunc() external pure returns (string memory) {
        return "external func called";
    }
    // it can only be called from other contracts 
    function testexternalfunc() public pure returns (string memory) {
        return externalfunc();
    }


    string private privatevar = "myPrivateVar";
    string public publicvar = "Mypublicvar";
    string internal internalvar = "myinternalvar";
    // state variable can't be eclared as external
    string external externalvar = "Myexternalvar";



}

contract child is Base {
    function testinternalfunc() public pure returns (string memory) {
        return internalfunc();
    }
}

----------------------------------------------------------------------------------------------------

contract Event {
    event Log(address sender , string message);
    event AnotherLog();

    function fireEvents() public {
        emit Log(msg.sender, "helloWorld");
        emit Log(msg.sender , "HelloEVM");
        emit AnotherLog();
    }
}

----------------------------------------------------------------------------------------------------

// // SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

contract Account {
    uint public balance;
    uint public constant MAX_UINT = 2 ** 256 -1;

    function deposit(uint _amount) public {
        uint OldBalance = balance;
        uint newbalance = balance + _amount;

        require(newbalance >= OldBalance, "OverFlow");

        balance = newbalance;

        assert(balance >= OldBalance);
    }

    function withdraw(uint _amount) public {
        uint OldBalance = balance;

        require(balance >= _amount, "underflow" );

        if (balance < _amount) {
            revert("UnderFlow");
        }

        assert (balance <= OldBalance);
    }
}

-----------------------------------------------------------------------------------------------------


contract Loop {
    uint public count;

    function loop(uint n) public {
        for (uint i=0 ; i < n ; i++) {
            count += 1;
        }
    }
}


contract Dividend {
    address[100] public shareholders;

    function pay() public {
        for (uint i = 0; i < shareholders.length; i++) {
            // send ether to each shareholders
        }
    }
}

-----------------------------------------------------------------------------------------------------
// Array


contract Array {
    uint[] public myArray;
    uint[] public myArray2 = [1, 2 , 3];
    uint[10] public myFixedsizeArray;

    function push(uint i ) public {
        myArray.push(i);
    }

    function pop() public {
        myArray.pop();
    }

    function length() public view returns(uint) {
        return myArray.length;
    }

    function remove(uint index) public {
        delete myArray[index];
    } 
}

contract compactArray {
    uint[] public myArray;

    function remove(uint index) public {
        myArray[index] = myArray[myArray.length - 1];
        myArray.pop();

    }

    function test() public {
        myArray.push(1);
        myArray.push(2);
        myArray.push(3);
        myArray.push(4);
        // [1, 2 , 3 , 4]

        remove(1);
        // [1 , 4 , 3]
        
        assert(myArray.length == 3 );
        assert(myArray[0] == 1);
        assert(myArray[1] == 4);
        assert(myArray[2] == 3);

        remove(2);
        // [1,4]

        assert(myArray.length == 2);
        assert(myArray[0] == 1);
        assert(myArray[1] == 4);
    }
}

-----------------------------------------------------------------------------------------------------
