var Betting = artifacts.require("./Betting.sol");

module.exports = function(deployer) {
	var testOutcomes = [1, 2, 3];
	deployer.deploy(Betting, testOutcomes);
};
