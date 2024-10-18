import { HardhatRuntimeEnvironment } from "hardhat/types";
import { MovementFacet, WeaponUpgradeFacet } from "../typechain-types";

module.exports = async ({ getNamedAccounts, deployments, ethers, getChainId }: HardhatRuntimeEnvironment) => {
    const { diamond, deploy } = deployments;
    const { deployer } = await getNamedAccounts();
    console.log(await getNamedAccounts());

    const DiamondAppInit = await deploy("DiamondAppInit", {
        from: deployer,
        args: [],
        log: true,
    })

    console.log("Diamond Init: ", DiamondAppInit.address);

    var Diamond = await diamond.deploy('DiamondApp', {
        from: deployer,
        owner: deployer,
        facets: ['VersionFacet', 'MovementFacet', 'WeaponUpgradeFacet', 'WorldFacet'],
        log: true,
    });
    console.log("Diamond: ", Diamond.address);


    let diamondInit = await ethers.getContract("DiamondAppInit")
    let functionCall = diamondInit.interface.encodeFunctionData('init')
    const diamondCut = await ethers.getContractAt('IDiamondCut', Diamond.address)
    let tx = await diamondCut.diamondCut([], DiamondAppInit.address, functionCall)
    console.log('Called init()');


    console.log('Setting MovementVerifier...');
    let MovementVerifier = await ethers.getContract("MovementVerifier")
    console.log(await MovementVerifier.getAddress());
    let MovementFacet: MovementFacet = await ethers.getContractAt("MovementFacet", Diamond.address)
    await MovementFacet.setMovementVerifier(await MovementVerifier.getAddress())
    console.log('MovementVerifier is set...');

    console.log('Setting WeaponUpgradeVerifier...');
    let WeaponUpgradeVerifier = await ethers.getContract("WeaponUpgradeVerifier")
    console.log(await WeaponUpgradeVerifier.getAddress());
    let WeaponUpgradeFacet: WeaponUpgradeFacet = await ethers.getContractAt("WeaponUpgradeFacet", Diamond.address)
    await WeaponUpgradeFacet.setWeaponUpgradeVerifier(await WeaponUpgradeVerifier.getAddress())
    console.log('WeaponUpgradeVerifier is set...');
};

module.exports.dependencies = ['MovementVerifier', 'WeaponUpgradeVerifier'];
module.exports.tags = ['DiamondApp'];

