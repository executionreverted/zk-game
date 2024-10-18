import {
    time,
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { deployments, ethers } from "hardhat";
import { VersionFacet, WeaponUpgradeFacet } from "../typechain-types";
import { exportCallDataGroth16 } from "../utils/exportCallDataGroth16";
import { expect } from "chai";

var upgradeChances = [
    90,
    80,
    75,
    70,
    65,
    50,
    40,
    30,
    25,
    20
]

describe("WeaponUpgradeFacet", function () {
    var weaponId = 0;
    let VersionFacet: VersionFacet
    let WeaponUpgradeFacet: WeaponUpgradeFacet

    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployContracts() {
        await deployments.fixture(['DiamondApp'])
        VersionFacet = await ethers.getContract('DiamondApp');
        WeaponUpgradeFacet = await ethers.getContract('DiamondApp');
        console.log("Diamond owner: ", await VersionFacet.getDiamondOwner());
        return { VersionFacet, WeaponUpgradeFacet }
    }


    describe("Deployment", function () {
        it("Should give version 0.0.1", async function () {
            await deployContracts()
            console.log("Version(Keccak256): ", await VersionFacet.version());
            // console.log("MovementVerifier set in MovementFacet");
        });
    });


    describe("Try upgrade until hit +9", function () {
        var totalTries = 0;
        it("Should generate proof for upgrade attempt", async function () {
            for (let tokenId = 3; tokenId < 6; tokenId++) {
                while (true) {
                    totalTries++;
                    const weaponOld3 = await WeaponUpgradeFacet.getWeaponUpgradeData(tokenId)
                    console.log(`Weapon: ${tokenId}, total tries ${totalTries} , Trying upgrade - > Nonce: ${weaponOld3[0]} Weapon level: ${weaponOld3[1]}`);

                    if (weaponOld3[1].toString() == "9") {
                        break
                    }

                    let seed = await WeaponUpgradeFacet.getSeed();
                    console.log(seed);

                    const inputData2 = {
                        "weaponNonce": weaponOld3[0],
                        "weaponLevel": weaponOld3[1],
                        "weaponId": tokenId,
                        "upgradeChance": upgradeChances[parseInt(weaponOld3[1].toString())],
                        "seed": seed
                    }

                    let wasmCircuitPath = "./circuits/weaponUpgrade/circuit_js/circuit.wasm"
                    let zkeyCircuit = "./circuits/weaponUpgrade/circuit.zkey"

                    let dataResult = await exportCallDataGroth16(inputData2, wasmCircuitPath, zkeyCircuit)
                    // console.log(dataResult[3]);
                    
                    // console.log(`Solidity WeaponUpgrade Calldata: \n `, dataResult);
                    await WeaponUpgradeFacet.upgradeWeapon(...dataResult)
                    const roll = dataResult[3][7]
                    const weaponNew3 = await WeaponUpgradeFacet.getWeaponUpgradeData(tokenId)
                    // console.log(
                    //     `
                    //     Required <=roll: ${upgradeChances[parseInt(weaponOld3[1].toString())]} 
                    //     Player roll: ${roll}
                    //     Upgraded to: ${weaponNew3[1]}
                    //     Player roll < required roll: ${roll <= upgradeChances[parseInt(weaponOld3[1].toString())]}
                    //     Upgrade Success!`
                    // );
                }
            }

            console.log("Upgraded 10 weapons to +9, total tries: ", totalTries);

        });
    });

    // describe("Try To Upgrade", function () {
    //     it("Should generate proof for upgrade attempt", async function () {


    //         const weaponOld = await WeaponUpgradeFacet.getWeaponUpgradeData(inputData.weaponId)
    //         console.log({ weaponOld });
    //         expect(weaponOld[0]).eq(inputData.weaponNonce);
    //         expect(weaponOld[1]).eq(inputData.weaponLevel);

    //         let wasmCircuitPath = "./circuits/weaponUpgrade/circuit_js/circuit.wasm"
    //         let zkeyCircuit = "./circuits/weaponUpgrade/circuit.zkey"

    //         let dataResult = await exportCallDataGroth16(inputData, wasmCircuitPath, zkeyCircuit)

    //         // console.log(`Solidity WeaponUpgrade Calldata: \n `, dataResult);
    //         await WeaponUpgradeFacet.upgradeWeapon(...dataResult)

    //         const weaponNew = await WeaponUpgradeFacet.getWeaponUpgradeData(inputData.weaponId)
    //         console.log({ weaponNew });
    //     });
    // });


    // describe("Try To Upgrade 2nd Time", function () {
    //     it("Should generate proof for upgrade attempt", async function () {
    //         const weaponOld2 = await WeaponUpgradeFacet.getWeaponUpgradeData(inputData.weaponId)
    //         console.log({ weaponOld: weaponOld2 });

    //         const inputData2 = {
    //             "weaponNonce": weaponOld2[0],
    //             "weaponLevel": weaponOld2[1],
    //             "weaponId": weaponId,
    //             "upgradeChance": weaponOld2[1].toString() == "1" ? 70 : 80
    //         }

    //         let wasmCircuitPath = "./circuits/weaponUpgrade/circuit_js/circuit.wasm"
    //         let zkeyCircuit = "./circuits/weaponUpgrade/circuit.zkey"

    //         let dataResult = await exportCallDataGroth16(inputData2, wasmCircuitPath, zkeyCircuit)

    //         // console.log(`Solidity WeaponUpgrade Calldata: \n `, dataResult);
    //         await WeaponUpgradeFacet.upgradeWeapon(...dataResult)
    //         const weaponNew2 = await WeaponUpgradeFacet.getWeaponUpgradeData(inputData.weaponId)
    //         console.log({ weaponNew2 });
    //     });
    // });



    // describe("Try To Upgrade up to 9", function () {
    //     it("Should generate proof for upgrade attempt", async function () {
    //         for (let index = 0; index < 9; index++) {
    //             const weaponOld3 = await WeaponUpgradeFacet.getWeaponUpgradeData(inputData.weaponId)
    //             console.log({ weaponOld: weaponOld3 });
    //             if (weaponOld3[1].toString() == "9") {
    //                 break
    //             }

    //             const inputData2 = {
    //                 "weaponNonce": weaponOld3[0],
    //                 "weaponLevel": weaponOld3[1],
    //                 "weaponId": weaponId,
    //                 "upgradeChance": upgradeChances[parseInt(weaponOld3[1].toString())]
    //             }

    //             let wasmCircuitPath = "./circuits/weaponUpgrade/circuit_js/circuit.wasm"
    //             let zkeyCircuit = "./circuits/weaponUpgrade/circuit.zkey"

    //             let dataResult = await exportCallDataGroth16(inputData2, wasmCircuitPath, zkeyCircuit)

    //             console.log(dataResult);

    //             // console.log(`Solidity WeaponUpgrade Calldata: \n `, dataResult);
    //             await WeaponUpgradeFacet.upgradeWeapon(...dataResult)
    //             const weaponNew3 = await WeaponUpgradeFacet.getWeaponUpgradeData(inputData.weaponId)
    //             console.log({ weaponNew2: weaponNew3 });
    //         }
    //     });
    // });
});
