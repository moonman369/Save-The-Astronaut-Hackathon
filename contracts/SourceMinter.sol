// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
// import {Withdraw} from "./utils/Withdraw.sol";
import {AstroSuitPartsNFT} from "./AstroSuitPartsNFT.sol";
import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.0/token/ERC20/IERC20.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract SourceMinter is OwnerIsCreator {

    error FailedToWithdrawEth(address owner, uint256 value);

    enum PayFeesIn {
        Native,
        LINK
    }

    address immutable i_router;
    address immutable i_link;
    address astroPartsNft;
    mapping(address => uint256) private nativeDeposits;
    mapping(address => uint256) private linkDeposits;
    mapping(address => bytes32[]) private merges;

    event MessageSent(bytes32 messageId);

    constructor(address router, address link) {
        i_router = router;
        i_link = link;
        LinkTokenInterface(i_link).approve(i_router, type(uint256).max);
    }

    function setAstroPartsNft (address _astroPartsNft) public onlyOwner {
        astroPartsNft = _astroPartsNft;
    }

    receive() external payable {
        nativeDeposits[msg.sender] += msg.value;
    }

    function receiveLink(uint256 _amount) external {
        require(LinkTokenInterface(i_link).balanceOf(msg.sender) >= _amount, "SourceMinter: Insufficient Link balance.");
        linkDeposits[msg.sender] += _amount;
        LinkTokenInterface(i_link).transferFrom(msg.sender, address(this), _amount);
    }

    function checkBalanceForMerge(
        uint64 destinationChainSelector,
        address receiver,
        PayFeesIn payFeesIn
    ) public view returns (bool) {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encodeWithSignature("mint(address)", msg.sender),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            feeToken: payFeesIn == PayFeesIn.LINK ? i_link : address(0)
        });

        uint256 fee = IRouterClient(i_router).getFee(
            destinationChainSelector,
            message
        );

        if (payFeesIn == PayFeesIn.LINK) {
            return linkDeposits[msg.sender] >= fee;
        }
        else if (payFeesIn == PayFeesIn.Native) {
            return nativeDeposits[msg.sender] >= fee;
        }
        return false;
    }


    function getMergeFee(
        uint64 destinationChainSelector,
        address receiver,
        PayFeesIn payFeesIn
    ) public view returns (uint256) {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encodeWithSignature("mint(address)", msg.sender),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            feeToken: payFeesIn == PayFeesIn.LINK ? i_link : address(0)
        });

        uint256 fee = IRouterClient(i_router).getFee(
            destinationChainSelector,
            message
        );
        
        return fee;
    }



    function merge(
        uint64 destinationChainSelector,
        address receiver,
        PayFeesIn payFeesIn
    ) external {

        require(astroPartsNft != address(0), "SourceMinter: AstroPartsNFT address is not set.");
        require(checkBalanceForMerge(destinationChainSelector, receiver, payFeesIn), "SourceMinter: Insufficient token balance for merge.");
        require(AstroSuitPartsNFT(astroPartsNft).balanceOf(msg.sender, 0) > 0, "SourceMinter: Not enough Gloves to perform merge");
        require(AstroSuitPartsNFT(astroPartsNft).balanceOf(msg.sender, 1) > 0, "SourceMinter: Not enough Helmet to perform merge");
        require(AstroSuitPartsNFT(astroPartsNft).balanceOf(msg.sender, 2) > 0, "SourceMinter: Not enough Suit to perform merge");
        require(AstroSuitPartsNFT(astroPartsNft).balanceOf(msg.sender, 3) > 0, "SourceMinter: Not enough Boots to perform merge");

        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encodeWithSignature("mint(address)", msg.sender),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            feeToken: payFeesIn == PayFeesIn.LINK ? i_link : address(0)
        });

        uint256 fee = IRouterClient(i_router).getFee(
            destinationChainSelector,
            message
        );

        bytes32 messageId;

        if (payFeesIn == PayFeesIn.LINK) {
            // LinkTokenInterface(i_link).approve(i_router, fee);
            linkDeposits[msg.sender] -= fee;
            messageId = IRouterClient(i_router).ccipSend(
                destinationChainSelector,
                message
            );
        } else {
            nativeDeposits[msg.sender] -= fee;
            messageId = IRouterClient(i_router).ccipSend{value: fee}(
                destinationChainSelector,
                message
            );
        }

        merges[msg.sender].push(messageId);

        AstroSuitPartsNFT(astroPartsNft).burnItAll(msg.sender);

        emit MessageSent(messageId);
    }

    function withdrawNative() public {
        require(nativeDeposits[msg.sender] > 0, "SourceMinter: No Tokens to withdraw");
        uint256 amount = nativeDeposits[msg.sender];
        nativeDeposits[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");
        if(!sent) revert FailedToWithdrawEth(msg.sender, amount);
    }

    function withdrawLink() public {
        require(linkDeposits[msg.sender] > 0, "SourceMinter: No Tokens to withdraw");
        uint256 amount = linkDeposits[msg.sender];
        linkDeposits[msg.sender] = 0;
        LinkTokenInterface(i_link).transfer(msg.sender, amount);
    }

    function getNativeDeposits(address _user) public view returns (uint256) {
        return nativeDeposits[_user];
    }

    function getLinkDeposits(address _user) public view returns (uint256) {
        return linkDeposits[_user];
    }

    function getMerges(address _user) public view returns (bytes32[] memory) {
        return merges[_user];
    }

}