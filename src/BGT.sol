// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BGT is ERC20 {
    address public owner;

    constructor() ERC20("Blockchain@GT", "BGT") {
        _mint(msg.sender, 1000000000e18);
    }

    function setOwner(address newOwner) public {
        owner = newOwner;
    }

    function claim() public {
        _mint(msg.sender, 10e18);
    }
}
