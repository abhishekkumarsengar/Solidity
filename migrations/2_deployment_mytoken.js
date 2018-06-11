var mytoken = artifacts.require("./MyToken.sol");


module.exports = (deployer) => {
  deployer.deploy(mytoken, "AbhiToken", "ABT", 10000000, 18);
}
