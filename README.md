# Yield Master Staking Vault

A professional implementation of a staking pool. Users deposit a specific "Staking Token" and earn a "Reward Token" (or the same token) over time.

### Features
* **Linear Rewards:** Rewards are accrued per second based on the set reward rate.
* **Flexible Staking:** Users can stake and unstake at any time (configurable).
* **Emergency Exit:** Built-in circuit breaker for users to recover principal in case of reward exhaustion.
* **Owner Controls:** Adjust reward rates and fund the reward pool securely.

### Setup
1. `npm install`
2. `npx hardhat compile`
3. Update `stakingToken` and `rewardToken` addresses in `deploy.js`.
