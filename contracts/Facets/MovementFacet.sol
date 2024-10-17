// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity 0.8.27;
import {LibAppStorage, Modifiers} from "../Libraries/LibAppStorage.sol";
import {MovementVerifier} from "../Verifiers/MovementVerifier.sol";

contract MovementFacet is Modifiers {
    function setMovementVerifier(
        address _movVerifier
    ) external onlyDiamondOwner {
        s.verifierAddresses[0] = _movVerifier;
    }


    function getPlayerPos(uint playerId) external view returns(uint[2] memory) {
        return s.playerPositions[playerId];
    }

    function move(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[3] calldata _pubSignals
    ) external {
        require(
            MovementVerifier(s.verifierAddresses[0]).verifyProof(
                _pA,
                _pB,
                _pC,
                _pubSignals
            ),
            "invalid move"
        );

        require(_pubSignals[0] == 1, "invalid movement 2");

        s.playerPositions[0][0] = _pubSignals[1]; // set X
        s.playerPositions[0][1] = _pubSignals[2]; // set Y
    }
}
