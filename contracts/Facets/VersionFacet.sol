// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;
import {LibAppStorage, Modifiers} from "../Libraries/LibAppStorage.sol";
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
contract VersionFacet is Modifiers {
    function getDiamondOwner() external view returns (address) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        return ds.contractOwner;
    }

    function postUpgrade() external onlyDiamondOwner {
        s.version = keccak256("0.0.1");
    }

    function version() external view returns (bytes32 v) {
        return s.version;
    }
}
