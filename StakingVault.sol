// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract StakingVault is Ownable, ReentrancyGuard {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    uint256 public rewardRate; // Tokens per second
    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public lastUpdateTime;
    mapping(address => uint256) public rewards;

    constructor(address _stakingToken, address _rewardToken, uint256 _rewardRate) Ownable(msg.sender) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        rewardRate = _rewardRate;
    }

    function earned(address account) public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - lastUpdateTime[account];
        return rewards[account] + (stakedAmount[account] * timeElapsed * rewardRate / 1e18);
    }

    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Cannot stake 0");
        rewards[msg.sender] = earned(msg.sender);
        lastUpdateTime[msg.sender] = block.timestamp;
        stakedAmount[msg.sender] += amount;
        stakingToken.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(amount <= stakedAmount[msg.sender], "Exceeds balance");
        rewards[msg.sender] = earned(msg.sender);
        lastUpdateTime[msg.sender] = block.timestamp;
        stakedAmount[msg.sender] -= amount;
        stakingToken.transfer(msg.sender, amount);
    }

    function claimReward() external nonReentrant {
        uint256 reward = earned(msg.sender);
        require(reward > 0, "No rewards to claim");
        rewards[msg.sender] = 0;
        lastUpdateTime[msg.sender] = block.timestamp;
        rewardToken.transfer(msg.sender, reward);
    }
}
