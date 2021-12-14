var BulletinBoard = artifacts.require("./BulletinBoard.sol");
//var Words = artifacts.require("Words");

module.exports = function(deployer) {
  deployer.deploy(BulletinBoard);
  //deployer.deploy(Words);
};