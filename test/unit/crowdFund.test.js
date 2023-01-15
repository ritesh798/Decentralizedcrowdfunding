const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { assert } = require("chai");

describe("CrowdFunding", async function () {
  let crowdFunding;
  let deployer;
  let mockV3Aggregator;

  beforeEach(async function () {
    deployer = (await getNamedAccounts()).deployer;
    await deployments.fixture(["all"]);
    crowdFunding = await ethers.getContract("CrowdFunding", deployer);
    mockV3Aggregator = await ethers.getContract("MockV3Aggregator", deployer);
  });

  describe("constructor", async function () {
    it("sets the aggregator address correctly", async function () {
      const response = await crowdFunding.priceFeed();
      assert.equal(response, mockV3Aggregator.address);
    });
  });
});
