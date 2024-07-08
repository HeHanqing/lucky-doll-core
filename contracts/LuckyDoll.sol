// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

error LockyDoll__NotOwner(uint256 tokenId);

contract LuckyDoll is ERC721, ERC721Enumerable, ERC721URIStorage, VRFConsumerBaseV2Plus {
    uint256 private _nextTokenId;

    //chainlink VRF
    uint256 s_subscriptionId;
    // Sepolia coordinator.
    // address vrfCoordinatorV2Plus = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    //100gwei
    bytes32 keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 callbackGasLimit = 2500000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    enum LuckLevel {
        GOOD_LUCK,
        HIGH_LUCK,
        SUPERB_LUCK,
        MYTHICAL_LUCK,
        LUCKY_STAR
    }

    mapping(uint256 => address) public tokenIdToOwner;
    mapping(uint256 => LuckLevel) public tokenIdToLuckLevel;
    mapping(uint256 => uint256) public requestIdToTokenId;

    event NFTCreated(address owner,uint256 tokenId, LuckLevel luckLevel);

    constructor(address vrfCoordinatorV2Plus,uint256 subscriptionId)
        ERC721("LuckyDoll", "LD")
        VRFConsumerBaseV2Plus(vrfCoordinatorV2Plus)
    {
        s_subscriptionId = subscriptionId;
    }

    function safeMint() public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        tokenIdToOwner[tokenId] = msg.sender;

        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            })
        );
        requestIdToTokenId[requestId] = tokenId;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override{
        uint256 randomNumber = (randomWords[0]) % 100;
        uint256 tokenId = requestIdToTokenId[requestId];
        if(randomNumber > 0 && randomNumber < 50){
            tokenIdToLuckLevel[tokenId] = LuckLevel.GOOD_LUCK;
        }else if(randomNumber >= 50 && randomNumber < 80){
            tokenIdToLuckLevel[tokenId] = LuckLevel.HIGH_LUCK;
        }else if(randomNumber >= 80 && randomNumber < 95){
            tokenIdToLuckLevel[tokenId] = LuckLevel.SUPERB_LUCK;
        }else if(randomNumber >= 95 && randomNumber < 99){
            tokenIdToLuckLevel[tokenId] = LuckLevel.MYTHICAL_LUCK;
        }else{
            tokenIdToLuckLevel[tokenId] = LuckLevel.LUCKY_STAR;
        }

        emit NFTCreated(msg.sender,tokenId,tokenIdToLuckLevel[tokenId]);
    }

    function setTokenURI(uint256 tokenId,string memory uri) public {
        if(tokenIdToOwner[tokenId] != msg.sender){
            revert LockyDoll__NotOwner(tokenId);
        }
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}