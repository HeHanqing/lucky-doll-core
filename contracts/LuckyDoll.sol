// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

error LuckyDoll__NotOwner(address sender, uint256 tokenId);

contract LuckyDoll is ERC721, ERC721Enumerable, ERC721URIStorage, VRFConsumerBaseV2Plus {
    uint256 private _nextTokenId;

    //chainlink VRF
    uint256 private s_subscriptionId;
    // Sepolia coordinator.
    address public s_vrfCoordinatorV2Plus;
    // 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B
    //100gwei
    bytes32 keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 callbackGasLimit = 2500000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    struct Metadata {
        string name;
        string description;
        string imageUri;
        string category;
    }

    string[] luckyLevel = ["Good_Luck","High_Luck","Superb_Luck","Mythical_Luck","Lucky_Star"];

    mapping(uint256 => address) public tokenIdToOwner;
    mapping(uint256 => string) public tokenIdOfLuckyLevel;
    mapping(uint256 => uint256) public requestIdToTokenId;
    mapping(uint256 => Metadata) public tokenIdToMetadata;

    event LuckyLevelCreated(address owner,uint256 tokenId, string luckLevel);
    event NFTMinted(address owner, uint256 tokenId);

    constructor(address vrfCoordinatorV2Plus,uint256 subscriptionId)
        ERC721("LuckyDoll", "LD")
        VRFConsumerBaseV2Plus(vrfCoordinatorV2Plus)
    {
        s_subscriptionId = subscriptionId;
        s_vrfCoordinatorV2Plus = vrfCoordinatorV2Plus;
    }

    function safeMint(string memory _name,string memory _description, string memory _imageUri,string memory _category) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        tokenIdToOwner[tokenId] = msg.sender;
        tokenIdToMetadata[tokenId] = Metadata({
            name: _name,
            description: _description,
            imageUri: _imageUri,
            category: _category
        });

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

        emit NFTMinted(msg.sender, tokenId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override{
        uint256 randomNumber = (randomWords[0]) % 100;
        uint256 tokenId = requestIdToTokenId[requestId];
        if(randomNumber > 0 && randomNumber < 50){
            tokenIdOfLuckyLevel[tokenId] = luckyLevel[0];
        }else if(randomNumber >= 50 && randomNumber < 80){
            tokenIdOfLuckyLevel[tokenId] = luckyLevel[1];
        }else if(randomNumber >= 80 && randomNumber < 95){
            tokenIdOfLuckyLevel[tokenId] = luckyLevel[2];
        }else if(randomNumber >= 95 && randomNumber < 99){
            tokenIdOfLuckyLevel[tokenId] = luckyLevel[3];
        }else{
            tokenIdOfLuckyLevel[tokenId] = luckyLevel[4];
        }

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', tokenIdToMetadata[tokenId].name ,'",',
                        '"description": "', tokenIdToMetadata[tokenId].description ,'",',
                        '"image": "', tokenIdToMetadata[tokenId].imageUri ,'",',
                        '"attributes": [',
                            '{"trait_type": "personality",',
                            '"value": "', tokenIdToMetadata[tokenId].category ,'"},',
                            '{"trait_type": "lucky_level",',
                            '"value": "', tokenIdOfLuckyLevel[tokenId] ,'"}',
                        ']}'
                    )
                )
            )
        );

        _setTokenURI(tokenId, string(
            abi.encodePacked("data:application/json;base64,",json)
        ));

        emit LuckyLevelCreated(msg.sender,tokenId,tokenIdOfLuckyLevel[tokenId]);
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

    //view
    function getOwner(uint256 tokenId) public view returns(address){
        return tokenIdToOwner[tokenId];
    }

    function getRequestIdToTokenId(uint256 requestId) public view returns(uint256){
        return requestIdToTokenId[requestId];
    }

    function getLuckyLevel(uint256 tokenId) public view returns(string memory){
        return tokenIdOfLuckyLevel[tokenId];
    }

}