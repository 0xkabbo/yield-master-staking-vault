const hre = require("hardhat");

async function main() {
  const StakingVault = await hre.ethers.getContractFactory("StakingVault");
  
  // Replace with actual token addresses
  const stakingTokenAddr = "0x..."; 
  const rewardTokenAddr = "0x...";
  const rate = hre.ethers.parseEther("0.001"); // 0.001 tokens per second per staked token

  const vault = await StakingVault.deploy(stakingTokenAddr, rewardTokenAddr, rate);

  await vault.waitForDeployment();
  console.log("Staking Vault deployed to:", await vault.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
