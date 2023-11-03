// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "chronicle-std/src/IChronicle.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "forge-std/console.sol";

enum Currency {
    USDT,
    ETH,
    GNO
}

struct Coin {
    uint256 amount;
    Currency currency;
}

contract PaytalLisbon {

    uint256[3] TEST_DATA = [999_998, 1 ether, 1 ether];
    
    uint constant public TOTAL_CURRENCIES = 3;

    mapping (Currency => address) tokenAddress;
    mapping (Currency => address) chronicleOracleAddress;

    constructor (
        address usdt,
        address eth,
        address gno,
        address usdtUsd,
        address ethUsd,
        address gnoUsd
    ) {
        console.log(usdt);
        console.log(eth);
        console.log(gno);
        console.log(usdtUsd);
        console.log(ethUsd);
        console.log(gnoUsd);

        tokenAddress[Currency.USDT] = usdt;
        tokenAddress[Currency.ETH] = eth;
        tokenAddress[Currency.GNO] = gno;
        chronicleOracleAddress[Currency.USDT] = usdtUsd;
        chronicleOracleAddress[Currency.ETH] = ethUsd;
        chronicleOracleAddress[Currency.GNO] = gnoUsd;
    }

    function getPriceCombination(
        uint256 price,
        address account
    ) public view returns(uint256[3] memory, bool success) {
        // Tokens de usuario

        uint256[3] memory result;
        uint256 _tokenBalance;
        uint256 _totalAmount;
        uint256 _accum;
        uint256 _unit;

        for (uint i=0; i < TOTAL_CURRENCIES; ++i) {
            Currency _currency = Currency(i);
            _tokenBalance = IERC20(tokenAddress[_currency]).balanceOf(account);
            // _decimals = IERC20(tokenAddress[_currency]).decimals();
            uint256 priceInUsd = IChronicle(chronicleOracleAddress[_currency]).read();
            // uint256 priceInUsd = TEST_DATA[i];

            console.log("ESTAMOS ACAA");
            console.log(i);

            // TODO: Patching decimals for USDT
            if (i == 0) {
                _unit = 1_000_000;
            } else {
                _unit = 1e18;
            }

            console.log("priceInUsd Y _tokenBalance _unit");
            console.log(priceInUsd);
            console.log(_tokenBalance);
            console.log(_unit);

            _totalAmount = priceInUsd * _tokenBalance / _unit;
            _accum += _totalAmount;

            console.log("ACCUM Y TOTAL AMOUNT");
            console.log(_accum);
            console.log(_totalAmount);

            if (_accum >= price) {
                result[i] = _totalAmount - (_accum - price);
                console.log("por aquiA");
                break;
            } else {
                result[i] = _totalAmount;
                console.log("por aca");
            }
        }
        console.log("RESULTS:");
        console.log(result[0]);
        console.log(result[1]);
        console.log(result[2]);

        return (result, _accum >= price);
    }
}
