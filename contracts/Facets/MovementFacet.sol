// SPDX-License-Identifier: GPL-3.0


pragma solidity 0.8.27;
import {LibAppStorage, Modifiers} from "../Libraries/LibAppStorage.sol";
import {MovementVerifier} from "../Verifiers/MovementVerifier.sol";

contract MovementFacet is Modifiers {
    function setMovementVerifier(
        address _movVerifier
    ) external onlyDiamondOwner {
        s.verifierAddresses[0] = _movVerifier;
    }

    function getPlayerPos(
        uint playerId
    ) external view returns (uint[2] memory) {
        return s.playerPositions[playerId];
    }

    function move(
        uint _playerId,
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[5] calldata _pubSignals
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
        require(_pubSignals[1] == s.playerPositions[_playerId][0], "wrong x");
        require(_pubSignals[2] == s.playerPositions[_playerId][1], "wrong y");

        s.playerPositions[_playerId][0] = _pubSignals[3]; // set X
        s.playerPositions[_playerId][1] = _pubSignals[4]; // set Y
    }
}
