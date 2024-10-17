import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { deployments, ethers } from "hardhat";
import { MovementFacet, MovementVerifier, VersionFacet } from "../typechain-types";
import { exportCallDataGroth16 } from "../utils/exportCallDataGroth16";
import { expect } from "chai";
describe("MovementFacet", function () {
  let VersionFacet: VersionFacet
  let MovementFacet: MovementFacet

  const inputData = {
    "playerX": 0,
    "playerY": 0,
    "newX": 0,
    "newY": 1,
    "maxMoveDist": 1
  }

  const inputData2 = {
    "playerX": 0,
    "playerY": 1,
    "newX": 0,
    "newY": 3,
    "maxMoveDist": 1
  }

  const inputData3 = {
    "playerX": 0,
    "playerY": 1,
    "newX": 5,
    "newY": 8,
    "maxMoveDist": 9
  }

  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployContracts() {
    await deployments.fixture(['DiamondApp'])
    VersionFacet = await ethers.getContract('DiamondApp');
    MovementFacet = await ethers.getContract('DiamondApp');
    console.log("Diamond owner: ", await VersionFacet.getDiamondOwner());
    return { VersionFacet, MovementFacet }
  }


  describe("Deployment", function () {
    it("Should give version 0.0.1", async function () {
      await deployContracts()
      console.log("Version(Keccak256): ", await VersionFacet.version());
      // console.log("MovementVerifier set in MovementFacet");
    });
  });

  describe("Try To Move", function () {
    it("Should generate proof to move", async function () {

      const oldPos = await MovementFacet.getPlayerPos(0)
      expect(oldPos[0]).eq(inputData.playerX)
      expect(oldPos[1]).eq(inputData.playerY)
      console.log({ oldPos });



      let wasmCircuitPath = "./circuits/move/circuit_js/circuit.wasm"
      let zkeyCircuit = "./circuits/move/circuit.zkey"

      let dataResult = await exportCallDataGroth16(inputData, wasmCircuitPath, zkeyCircuit)

      console.log(`Solidity Calldata: \n `, dataResult);
      await MovementFacet.move(...dataResult)
      const newPos = await MovementFacet.getPlayerPos(0)
      console.log({ newPos });
      expect(newPos[0]).eq(inputData.newX)
      expect(newPos[1]).eq(inputData.newY)
    });
  });

  describe("Try To Move Too Much But Fail:D", function () {
    it("Should not generate proof to move", async function () {

      const oldPos = await MovementFacet.getPlayerPos(0)
      console.log({ oldPos });

      let wasmCircuitPath = "./circuits/move/circuit_js/circuit.wasm"
      let zkeyCircuit = "./circuits/move/circuit.zkey"

      try {
        var dataResult = await exportCallDataGroth16(inputData2, wasmCircuitPath, zkeyCircuit)
      } catch (error: any) {
        console.log(error.message);
      }

      console.log(`Solidity Calldata: \n `, dataResult);
      expect(dataResult).undefined
    });
  });

  describe("Try Move Long But Hell Yeah", function () {
    it("Should generate proof to move big", async function () {
      const oldPos = await MovementFacet.getPlayerPos(0)
      expect(oldPos[0]).eq(inputData3.playerX)
      expect(oldPos[1]).eq(inputData3.playerY)
      console.log({ oldPos });



      let wasmCircuitPath = "./circuits/move/circuit_js/circuit.wasm"
      let zkeyCircuit = "./circuits/move/circuit.zkey"

      let dataResult = await exportCallDataGroth16(inputData3, wasmCircuitPath, zkeyCircuit)

      console.log(`Solidity Calldata: \n `, dataResult);
      await MovementFacet.move(...dataResult)
      const newPos = await MovementFacet.getPlayerPos(0)
      console.log({ newPos });
      expect(newPos[0]).eq(inputData3.newX)
      expect(newPos[1]).eq(inputData3.newY)
    });
  });
});
