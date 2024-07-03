// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/interfaces/IERC721.sol";

error NFTMarketplace__ERC721_Zero_Address();

contract NFTMarketplace{
    IERC721 public erc721;

    struct Order {
        address owner;
        address seller;
        uint256 tokenId;
        uint256 price;
    }

    constructor(address _erc721){
        if(_erc721 == address(0)){
            revert NFTMarketplace__ERC721_Zero_Address();
        }
        erc721 = IERC721(_erc721);
    }
}