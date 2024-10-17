// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;
import {LibAppStorage, Modifiers} from "../Libraries/LibAppStorage.sol";

contract VersionFacetV2 is Modifiers {
    function postUpgrade() external onlyDiamondOwner {
        s.version = keccak256("0.0.2");
    }

    function version() external view returns (bytes32 v) {
        return s.version;
    }

    function sayHello() external pure returns (string memory) {
        return "Hello!";
    }
}
