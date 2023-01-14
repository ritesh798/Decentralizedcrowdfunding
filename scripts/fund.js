const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { deployer } = await getNamedAccounts();
  const crowdFunding = await ethers.getContractAt(
    "CrowdFunding",
    CrowdFunding.address,
    deployer
  );
  console.log("Funding  Contract.....");
  const transactionResponse = await crowdFunding.fund({
    value: ethers.utils.parseEther("0.1"),
  });
  await transactionResponse.wait(1);
  console.log("Funded....");
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
