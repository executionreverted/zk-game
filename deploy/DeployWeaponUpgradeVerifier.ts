import { HardhatRuntimeEnvironment } from "hardhat/types";

module.exports = async ({ getNamedAccounts, deployments, getChainId }: HardhatRuntimeEnvironment) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    await deploy('WeaponUpgradeVerifier', {
        from: deployer,
        proxy: true,
    });
};

module.exports.tags = ["WeaponUpgradeVerifier"]