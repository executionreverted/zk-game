import {
    time,
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { deployments, ethers } from "hardhat";
import { VersionFacet, WeaponUpgradeFacet, WorldFacet } from "../typechain-types";
import { exportCallDataGroth16 } from "../utils/exportCallDataGroth16";
import { expect } from "chai";


describe("WorldFacet", function () {
    var weaponId = 0;
    let VersionFacet: VersionFacet
    let WorldFacet: WorldFacet

    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployContracts() {
        await deployments.fixture(['DiamondApp'])
        VersionFacet = await ethers.getContract('DiamondApp');
        WorldFacet = await ethers.getContract('DiamondApp');
        console.log("Diamond owner: ", await VersionFacet.getDiamondOwner());
        return { VersionFacet, WorldFacet }
    }


    describe("Deployment", function () {
        it("Should give version 0.0.1", async function () {
            await deployContracts()
            console.log("Version(Keccak256): ", await VersionFacet.version());
            // console.log("MovementVerifier set in MovementFacet");
        });
    });


    describe("Generate Perlin Noise And Map", function () {
        /*
            signal input x;
            signal input y;
            signal input PLANETHASH_KEY;
            signal input BIOMEBASE_KEY;
            signal input SCALE;
            signal input xMirror; // 1 is true, 0 is false
            signal input yMirror; // 1 is true, 0 is false
        */
        it("Should generate proof for upgrade attempt", async function () {
            let wasmCircuitPath = "./circuits/biomebase/circuit_js/circuit.wasm"
            let zkeyCircuit = "./circuits/biomebase/circuit.zkey"

            let Grid = []
            var startX = 10;
            var startY = 10;
            var endX = 30;
            var endY = 30;
            for (let x = startX; x < endX; x++) {
                let plots = ``
                for (let y = startY; y < endY; y++) {
                    let plot = await WorldFacet.generatePlotContent({ x, y })
                    plots += `${plot[0]}     `.substring(0,3)
                    // let dataResult = await exportCallDataGroth16(input, wasmCircuitPath, zkeyCircuit)
                }
                Grid.push(plots)
            }

            Grid.forEach(g => console.log(g))

        });
    });
});
