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

    event FullSuitMinted(address _to, uint256 _tokenId);

    string constant TOKEN_URI = "https://ipfs.io/ipfs/QmYuKY45Aq87LeL1R5dhb1hqHLp6ZFbJaCP8jxqKM1MX6y/babe_ruth_1.json";
    uint256 internal tokenId;

    constructor(address _initOwner, uint256 _maxTokenSupply) Ownable(_initOwner) ERC721("AstroSuit Full", "ASF") 
    {

    }

    function mint(address _to) public onlyOwner {
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, TOKEN_URI);
        emit FullSuitMinted(_to, tokenId);
        unchecked {
            tokenId++;
        }
    }
}