// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.27;
import {WeaponUpgradeData, LibAppStorage, Modifiers} from "../Libraries/LibAppStorage.sol";
import {WeaponUpgradeVerifier} from "../Verifiers/WeaponUpgradeVerifier.sol";

contract WeaponUpgradeFacet is Modifiers {
    function setWeaponUpgradeVerifier(
        address _movVerifier
    ) external onlyDiamondOwner {
        s.verifierAddresses[1] = _movVerifier;
    }

    function getSeed() public view returns (uint) {
        return block.timestamp / 100;
    }

    function getUpgradeChance(
        uint256 weaponLevel
    ) public pure returns (uint256) {
        require(weaponLevel < 10, "Weapon level too high");

        // Define the upgrade chances for each level
        uint256[10] memory upgradeChances = [
            uint256(90),
            80,
            75,
            70,
            65,
            50,
            40,
            30,
            25,
            20
        ];

        // Return the upgrade chance for the given level
        return upgradeChances[weaponLevel];
    }

    // weapon id //0
    // signal output success;         //1 , 1 if upgrade successful, 0 if not
    // signal output oldNonce;        //2
    // signal output oldLevel;        //3
    // signal output newNonce;        //4
    // signal output newLevel;        //5
    // signal output upChance;        //6
    function upgradeWeapon(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[9] calldata _pubSignals
    ) external {
        require(
            WeaponUpgradeVerifier(s.verifierAddresses[1]).verifyProof(
                _pA,
                _pB,
                _pC,
                _pubSignals
            ),
            "invalid proof"
        );

        uint upChance = getUpgradeChance(_pubSignals[3]);
        require(upChance == _pubSignals[6], "invalid param 1");
        require(
            s.weaponUpgradeData[_pubSignals[0]].nonce == _pubSignals[2],
            "invalid nonce"
        );
        require(
            s.weaponUpgradeData[_pubSignals[0]].upgradeLevel == _pubSignals[3],
            "invalid level"
        );
        require(
            getUpgradeChance(_pubSignals[3]) == _pubSignals[6],
            "invalid chance"
        );

        require(
            getSeed() == _pubSignals[8] || getSeed()-1 == _pubSignals[8],
            "invalid seed"
        );

        // TODO  check ownership from param 0

        // success
        if (_pubSignals[1] == 1) {
            s.weaponUpgradeData[_pubSignals[0]].upgradeLevel = _pubSignals[5];
        } else {
            if (s.weaponUpgradeData[_pubSignals[0]].upgradeLevel > 1) {
                s.weaponUpgradeData[_pubSignals[0]].upgradeLevel--;
            }
        }
        s.weaponUpgradeData[_pubSignals[0]].nonce = _pubSignals[4];
    }

    function getWeaponUpgradeData(
        uint weaponId
    ) external view returns (WeaponUpgradeData memory) {
        return s.weaponUpgradeData[weaponId];
    }
}
