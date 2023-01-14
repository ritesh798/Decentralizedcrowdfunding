const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { deployer } = await getNamedAccounts();
  const crowdFunding = await ethers.getContract("CrowdFunding", deployer);
  console.log("Withdrawing......");
  const transactionResponse = await crowdFunding.withdraw();
  await transactionResponse.wait(1);
  console.log("Withdrawn");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
