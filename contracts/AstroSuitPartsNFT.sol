// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {SourceMinter} from "./SourceMinter.sol";


/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract AstroSuitPartsNFT is ERC1155URIStorage, Ownable {

    using Strings for uint256;

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
    

    uint256[] private allIds = [GLOVES, HELMET, SUIT, BOOTS];
    uint256[] private amounts = [1,1,1,1];

    string constant BASE_URI = "https://gateway.pinata.cloud/ipfs/QmeyPoU3UdTimMgod7UrZLfZUk2NRBGr8Fmez9Mud4bF6n/";
    uint256 internal glovesCount;
    uint256 internal helmetCount;
    uint256 internal suitCount;
    uint256 internal bootsCount;
    mapping (address => uint256) internal glovesPerAddressCount;
    mapping (address => uint256) internal helmetPerAddressCount;
    mapping (address => uint256) internal suitPerAddressCount;
    mapping (address => uint256) internal bootsPerAddressCount;

    constructor(address _initOwner, address payable _sourceMinterAddress, uint256 _maxTokenSupply, uint256 _maxTokenSupplyPerAddress) ERC1155(BASE_URI) Ownable(_initOwner) {
        i_maxTokenSupply = _maxTokenSupply;
        i_maxTokenSupplyPerAddress = _maxTokenSupplyPerAddress;
        sourceMinterAddress = _sourceMinterAddress;
        sourceMinter = SourceMinter(_sourceMinterAddress);
    }

    function mintGloves(address _to) public {
        require(glovesCount < i_maxTokenSupply, "AstroSuitPartsNFT: Max mint limit for this token has been reached");
        require(glovesPerAddressCount[_to] < i_maxTokenSupplyPerAddress, "AstroSuitPartsNFT: This address has reached the maximum token mint limit.");
        _mint(_to, GLOVES, 1, "");
        _setURI(GLOVES, string(abi.encodePacked(BASE_URI, GLOVES, ".json")));
        unchecked {
            glovesCount++;
            glovesPerAddressCount[_to]++;
        }
        emit GlovesMinted(msg.sender, _to, 1);
    }

    function mintHelmet(address _to) public {
        require(helmetCount < i_maxTokenSupply, "AstroSuitPartsNFT: Max mint limit for this token has been reached");
        require(helmetPerAddressCount[_to] < i_maxTokenSupplyPerAddress, "AstroSuitPartsNFT: This address has reached the maximum token mint limit.");
        _mint(_to, HELMET, 1, "");
        _setURI(HELMET, string(abi.encodePacked(BASE_URI, HELMET, ".json")));
        unchecked {
            helmetCount++;
            helmetPerAddressCount[_to]++;
        }
        
        emit HelmetMinted(msg.sender, _to, 1);
    }

    function mintSuit(address _to) public {
        require(suitCount < i_maxTokenSupply, "AstroSuitPartsNFT: Max mint limit for this token has been reached");
        require(suitPerAddressCount[_to] < i_maxTokenSupplyPerAddress, "AstroSuitPartsNFT: This address has reached the maximum token mint limit.");
        _mint(_to, SUIT, 1, "");
        _setURI(SUIT, string(abi.encodePacked(BASE_URI, SUIT, ".json")));
        unchecked {
            suitCount++;
            suitPerAddressCount[_to]++;
        }
        emit SuitMinted(msg.sender, _to, 1);
    }

    function mintBoots(address _to) public {
        require(bootsCount < i_maxTokenSupply, "AstroSuitPartsNFT: Max mint limit for this token has been reached");
        require(bootsPerAddressCount[_to] < i_maxTokenSupplyPerAddress, "AstroSuitPartsNFT: This address has reached the maximum token mint limit.");
        _mint(_to, BOOTS, 1, "");
        _setURI(BOOTS, string(abi.encodePacked(BASE_URI, BOOTS, ".json")));
        unchecked {
            bootsCount++;
            bootsPerAddressCount[_to]++;
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

    function uri(uint256 _tokenId) public override pure returns (string memory) {
        return string(abi.encodePacked(BASE_URI, _tokenId.toString(), ".json"));
    }

    function tokenURI(uint256 _tokenId) public pure returns (string memory) {
        return string(abi.encodePacked(BASE_URI, _tokenId.toString(), ".json"));
    }
}