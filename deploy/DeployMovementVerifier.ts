import { HardhatRuntimeEnvironment } from "hardhat/types";

module.exports = async ({ getNamedAccounts, deployments, getChainId }: HardhatRuntimeEnvironment) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    await deploy('MovementVerifier', {
        from: deployer,
        proxy: true,
    });
};

module.exports.tags = ["MovementVerifier"]