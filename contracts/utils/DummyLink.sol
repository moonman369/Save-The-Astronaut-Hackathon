// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DummyLink is ERC20, Ownable {

    constructor ( uint256 _totalSupply ) 
    ERC20 ("Dummy LINK Token", "dLINK") Ownable(msg.sender) 
    {
        _mint(owner(), _totalSupply);
    }
}