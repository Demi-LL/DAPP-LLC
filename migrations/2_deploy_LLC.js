const LLC = artifacts.require("LLC");

module.exports = function (deployer) {
  deployer.deploy(LLC, "LLC");
};
