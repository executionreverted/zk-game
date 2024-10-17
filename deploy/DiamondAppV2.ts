module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
    const { diamond } = deployments;
    const { deployer } = await getNamedAccounts();

    await diamond.deploy('DiamondApp', {
        from: deployer,
        owner: deployer,
        facets: ['VersionFacetV2'],
        log: true,
        execute: {
            methodName: 'postUpgrade',
            args: [],
        }
    });
};

module.exports.tags = ['DiamondAppTest2'];