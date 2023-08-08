// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
pragma experimental ABIEncoderV2;


// Implementacion de la libreria SafeMath para realizar las operaciones de manera segura
// Fuente: "https://gist.github.com/giladHaimov/8e81dbde10c9aeff69a1d683ed6870be"

library SafeMath{
    // Restas
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    
    // Sumas
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
    
    // Multiplicacion
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
      if (a == 0) {
        return 0;
      }

      uint256 c = a * b;
      require(c / a == b, "SafeMath: multiplication overflow");

      return c;
    }

    // Función para convertir un valor en wei a ETH
    function convertToEth(uint256 valueInWei) internal pure returns (uint256) {
      // 1 ETH = 10^18 wei
      uint256 ethValue = valueInWei / 1 ether;
      return ethValue;
    }

    // Función para convertir un valor en ETH a wei
    function convertToWei(uint256 valueInEth) internal pure returns (uint256) {
      // 1 ETH = 10^18 wei
      uint256 weiValue = valueInEth * 1 ether;
      return weiValue;
    }
 
    function discountTransaction(uint256 number) internal pure returns (uint256){
      // Calcula el 2% del número
      return  mul(number, 2) / 100;
    }

    function costValue(uint256 number) internal pure returns (uint256){
      return number*(1 ether);
    }

}
