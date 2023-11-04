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
    uint256 amountInCoin;
    uint256 amountInUsd;
}

contract PaytalLisbon {

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
    ) public view returns(Coin[3] memory, bool success) {

        Coin[3] memory _coinResult;

        uint256[3] memory result;
        uint256[3] memory _tokenBalances;
        uint256 _balance;
        uint256 _totalAmount;
        uint256 _accum;
        uint256 _unit = 1e18;

        for (uint i=0; i < TOTAL_CURRENCIES; ++i) {
            Currency _currency = Currency(i);
            _balance = IERC20(tokenAddress[_currency]).balanceOf(account);
            uint256 _normBalance;

            // TODO: Patching decimals for USDT
            if (i == 0) {_normBalance = _balance * 1e12;} else {_normBalance = _balance;}

            // _decimals = IERC20(tokenAddress[_currency]).decimals();
            uint256 priceInUsd = IChronicle(chronicleOracleAddress[_currency]).read();
            // uint256 priceInUsd = TEST_DATA[i];

            console.log("ESTAMOS ACAA");
            console.log(i);

            console.log("priceInUsd Y _normBalance _unit");
            console.log(priceInUsd);
            console.log(_normBalance);
            console.log(_unit);

            _totalAmount = priceInUsd * _normBalance / 1e18;
            _accum += _totalAmount;

            console.log("ACCUM Y TOTAL AMOUNT");
            console.log(_accum);
            console.log(_totalAmount);

            if (_accum >= price) {
                uint256 _valueInUsd = _totalAmount - (_accum - price);
                result[i] = _valueInUsd;
                uint256 value = (_valueInUsd * 1e18) / priceInUsd;
                if (i == 0) { value = value / 1e12; }
                _tokenBalances[i] = value;
                _coinResult[i] = Coin(value, _valueInUsd);
                console.log("por aquiA");
                break;
            } else {
                result[i] = _totalAmount;
                if (i == 0) { _normBalance = _normBalance / 1e12; }
                _tokenBalances[i] = _normBalance;
                _coinResult[i] = Coin(_normBalance, _totalAmount);
                console.log("por aca");
            }
        }
        console.log("RESULTS:");
        console.log(result[0], _tokenBalances[0]);
        console.log(result[1], _tokenBalances[1]);
        console.log(result[2], _tokenBalances[2]);
        console.log(_accum >= price);


        return (_coinResult, _accum >= price);
    }
}
