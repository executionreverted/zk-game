// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {LibMeta} from "./LibMeta.sol";

struct AppStorage {
    bytes32 version;
    mapping(uint => uint[2]) playerPositions;
    mapping(uint => address) verifierAddresses;
}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }

    function abs(int256 x) internal pure returns (uint256) {
        return uint256(x >= 0 ? x : -x);
    }
}

contract Modifiers {
    AppStorage internal s;

    modifier onlyDiamondOwner() {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        address sender = LibMeta.msgSender();
        require(
            sender == ds.contractOwner,
            "Only diamond admin can call this function"
        );
        _;
    }
}
