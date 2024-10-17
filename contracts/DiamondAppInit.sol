// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {LibDiamond} from "../shared/libraries/LibDiamond.sol";
import {IDiamondCut} from "../shared/interfaces/IDiamondCut.sol";
import {IDiamondLoupe} from "../shared/interfaces/IDiamondLoupe.sol";
import {AppStorage} from "./Libraries/LibAppStorage.sol";
import {LibDiamond} from "../shared/libraries/LibDiamond.sol";

contract DiamondAppInit {
    AppStorage internal s;

    function init() external {
        s.version = keccak256("1.0.0");
    }
}
