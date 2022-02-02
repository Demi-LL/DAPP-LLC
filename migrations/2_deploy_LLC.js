const Migrations = artifacts.require("LLC");

module.exports = function (deployer) {
  deployer.deploy(Migrations, "LLC");
};
