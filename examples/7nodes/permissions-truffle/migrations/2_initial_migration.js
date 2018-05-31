var Permissions  = artifacts.require("./Permissions.sol");

module.exports = function(deployer) {
  deployer.deploy(Permissions);
};
