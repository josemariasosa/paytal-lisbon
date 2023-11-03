// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "chronicle-std/IChronicle.sol";

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

    function getPriceCombination(
        uint256 price,
        address account
    ) public returns(Coin[] memory) {
        // Tokens de usuario
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
