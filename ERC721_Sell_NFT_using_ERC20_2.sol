// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*
*@Author Muhammad Farooq BLK-Cohort-3
*@Date 1 Sep 2022
*@title Non Fungible Token  
*@dev Buying, minting and Transfer of ownership of NFT from Seller to Buyer.
*/

contract NFTContract is 
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable
{
    IERC20 paytoken;
    uint256 cost;

    /*
    *@dev It is compatble with ERC20 Token, So that when buyer will buy NFT 
    *     it will pay amount in the form of ERC20 token to Owner of NFT
    *@param ERC20 Contract Address, Cost per NFT
    */

    constructor(IERC20 _paytokenAddress, uint256 _cost) ERC721("NFTContract", "NFTC")
    {
        paytoken = _paytokenAddress;
        cost = _cost;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/";
    }

    /*
    *@dev Used to mint NFT 
    *     
    *@param Owner address, Token Id and URI
    */


    function safeMint(address to, uint256 tokenId, string memory uri)
        public
    {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /*
    *@dev It is used to buy NFT and automatically will pay fixed cost of NFT
    *     
    *@param Token ID
    */


    function buyNFT(
        uint256 tokenId)
        public
        payable
    {
        address ownerOfNFT = ownerOf(tokenId);
        paytoken.transferFrom(msg.sender, ownerOfNFT, cost);
        safeTransferFrom(ownerOfNFT, msg.sender, tokenId);
    }

    function setCostPerNFT(
        uint256 _cost)
        public 
        onlyOwner
    {
        cost = _cost;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
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
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
