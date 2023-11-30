// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {SourceMinter} from "./SourceMinter.sol";


/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract AstroSuitPartsNFT is ERC1155URIStorage, Ownable {

    event GlovesMinted(address _minter, address _to, uint256 amount);
    event HelmetMinted(address _minter, address _to, uint256 amount);
    event SuitMinted(address _minter, address _to, uint256 amount);
    event BootsMinted(address _minter, address _to, uint256 amount);

    uint256 public constant GLOVES = 0;
    uint256 public constant HELMET = 1;
    uint256 public constant SUIT = 2;
    uint256 public constant BOOTS = 3;

    uint256 private immutable i_maxTokenSupply;
    uint256 private immutable i_maxTokenSupplyPerAddress;
    address payable immutable sourceMinterAddress;
    SourceMinter private immutable sourceMinter;
    

    uint256[] allIds = [GLOVES, HELMET, SUIT, BOOTS];
    uint256[] amounts = [1,1,1,1];

    string constant TOKEN_URI = "https://ipfs.io/ipfs/QmYuKY45Aq87LeL1R5dhb1hqHLp6ZFbJaCP8jxqKM1MX6y/babe_ruth_1.json";
    uint256 internal glovesCount;
    uint256 internal helmetCount;
    uint256 internal suitCount;
    uint256 internal bootsCount;

    constructor(address _initOwner, address payable _sourceMinterAddress, uint256 _maxTokenSupply, uint256 _maxTokenSupplyPerAddress) ERC1155(TOKEN_URI) Ownable(_initOwner) {
        i_maxTokenSupply = _maxTokenSupply;
        i_maxTokenSupplyPerAddress = _maxTokenSupplyPerAddress;
        sourceMinterAddress = _sourceMinterAddress;
        sourceMinter = SourceMinter(_sourceMinterAddress);
    }

    function mintGloves(address _to) public {
        require(balanceOf(_to, GLOVES) <= i_maxTokenSupplyPerAddress, "AstroSuitPartsNFT: This address has reached the maximum token balance limit.");
        _mint(_to, GLOVES, 1, "");
        unchecked {
            glovesCount++;
        }
        emit GlovesMinted(msg.sender, _to, 1);
    }

    function mintHelmet(address _to) public {
        require(balanceOf(_to, HELMET) <= i_maxTokenSupplyPerAddress, "AstroSuitPartsNFT: This address has reached the maximum token balance limit.");
        _mint(_to, HELMET, 1, "");
        unchecked {
            helmetCount++;
        }
        emit HelmetMinted(msg.sender, _to, 1);
    }

    function mintSuit(address _to) public {
        require(balanceOf(_to, SUIT) <= i_maxTokenSupplyPerAddress, "AstroSuitPartsNFT: This address has reached the maximum token balance limit.");
        _mint(_to, SUIT, 1, "");
        unchecked {
            suitCount++;
        }
        emit SuitMinted(msg.sender, _to, 1);
    }

    function mintBoots(address _to) public {
        require(balanceOf(_to, BOOTS) <= i_maxTokenSupplyPerAddress, "AstroSuitPartsNFT: This address has reached the maximum token balance limit.");
        _mint(_to, BOOTS, 1, "");
        unchecked {
            bootsCount++;
        }
        emit BootsMinted(msg.sender, _to, 1);
    }

    function burnItAll(address _from) public {
        require(msg.sender == sourceMinterAddress, "AstroSuitPartsNFT: External call to this function is not allowed.");
        _burnBatch(_from, allIds, amounts);
    }

    // function mint(address to) public onlyOwner {
    //     _safeMint(to, tokenId);
    //     _setTokenURI(tokenId, TOKEN_URI);
    //     tokenId++;
    //     // unchecked {
    //     //     tokenId++;
    //     // }
    // }
}