// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import './BaseKP3ROracle.sol';
import '../interfaces/IBaseOracle.sol';
import '../interfaces/IKeep3rV1Oracle.sol';
import '../interfaces/IUniswapV2Factory.sol';

contract ERC20KP3ROracle is IBaseOracle, BaseKP3ROracle {
    constructor(IKeep3rV1Oracle _kp3r) BaseKP3ROracle(_kp3r) {}

    /// @dev Return the value of the given input as ETH per unit, multiplied by 2**112.
    /// @param token The ERC-20 token to check the value.
    function getETHPx(address token) external view override returns (uint256) {
        if (
            token == weth || token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
        ) {
            return 2**112;
        }
        address pair = IUniswapV2Factory(factory).getPair(token, weth);
        if (token < weth) {
            return price0TWAP(pair);
        } else {
            return price1TWAP(pair);
        }
    }
}
