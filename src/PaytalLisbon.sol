// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "chronicle-std/src/IChronicle.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



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

    uint constant public TOTAL_CURRENCIES = 3;

    mapping (Currency => address) tokenAddress;

    function getPriceCombination(
        uint256 price,
        address account
    ) public returns(Coin[] memory) {
        // Tokens de usuario

        uint256[] memory userTokens;

        for (uint i=0; i < TOTAL_CURRENCIES; ++i) {
            userTokens.push(
                IERC20(tokenAddress[Currency(i)])
            );
        }


        // Transformarlo a USD
        // Armar la respuesta.
    }



    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
