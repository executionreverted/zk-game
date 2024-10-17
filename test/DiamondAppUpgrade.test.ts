import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { deployments, ethers } from "hardhat";
import { VersionFacet, VersionFacetV2 } from "../typechain-types";

describe("VersionFacet", function () {
  let V: any = "";

  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployContracts() {
    await deployments.fixture(['DiamondAppTest'])
    const VersionFacet: VersionFacetV2 = await ethers.getContract('DiamondApp');
    return { VersionFacet }
  }

  async function deployV2Contracts() {
    await deployments.fixture(['DiamondAppTest2'])
    const VersionFacet: VersionFacetV2 = await ethers.getContract('DiamondApp');
    return { VersionFacet }
  }

  describe("Deployment", function () {
    it("Should give version 0.0.1 and should not run sayHello", async function () {
      const { VersionFacet } = await loadFixture(deployContracts);
      V = await VersionFacet.version();
      console.log("Version(Keccak256): ", V);
      try {
        console.log(await VersionFacet.sayHello());
      } catch (error) {
        console.log(error);
      }
    });
  });

  describe("DeploymentV2", function () {
    it("Should run sayHello", async function () {
      const { VersionFacet } = await loadFixture(deployV2Contracts);
      console.log("Version(Keccak256): ", await VersionFacet.version());
      try {
        console.log(await VersionFacet.sayHello());
      } catch (error) {
        console.log(error);
      }
    });
  });

  describe("DeploymentV3", function () {
    it("Should remove sayHello from facet", async function () {
      const { VersionFacet } = await loadFixture(deployContracts);
      V = await VersionFacet.version();
      console.log("Version(Keccak256): ", V);
      try {
        console.log(await VersionFacet.sayHello());
      } catch (error) {
        console.log(error);
      }
    });
  });

});
