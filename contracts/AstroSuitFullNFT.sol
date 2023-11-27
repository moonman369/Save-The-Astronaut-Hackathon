// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract AstroSuitFullNFT is ERC721URIStorage, Ownable {

    // uint256 public constant GLOVES = 0;
    // uint256 public constant HELMET = 1;
    // uint256 public constant SUIT = 2;
    // uint256 public constant SHOES = 3;

    // uint256 private immutable i_maxTokenSupply;

    // uint256[] allIds = [GLOVES, HELMET, SUIT, SHOES];
    // uint256[] amounts = [1,1,1,1];

    // string constant TOKEN_URI = "https://ipfs.io/ipfs/QmYuKY45Aq87LeL1R5dhb1hqHLp6ZFbJaCP8jxqKM1MX6y/babe_ruth_1.json";
    // // uint256 internal tokenId;

    constructor(address _initOwner, uint256 _maxTokenSupply) Ownable(_initOwner) ERC721("AstroSuit Full", "ASF") {
    }

    // function mintGloves(address _to) public {
    //     _mint(_to, GLOVES, 1, "");
    // }

    // function mintHelmet(address _to) public {
    //     _mint(_to, HELMET, 1, "");
    // }

    // function mintSuit(address _to) public {
    //     _mint(_to, SUIT, 1, "");
    // }

    // function mintShoes(address _to) public {
    //     _mint(_to, SHOES, 1, "");
    // }

    // function burnItAll(address _from) public {
    //     _burnBatch(_from, allIds, amounts);
    // }

    // // function mint(address to) public onlyOwner {
    // //     _safeMint(to, tokenId);
    // //     _setTokenURI(tokenId, TOKEN_URI);
    // //     tokenId++;
    // //     // unchecked {
    // //     //     tokenId++;
    // //     // }
    // // }
}