// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./utils/SafeMath.sol";
import "./utils/Context.sol";

contract Main {

   /* 0x5E3F773D4C0eAC9BbC410623DF5fAd45F08DCFA0 -> PRESTATARIO
      0x72f188f3767fE8FE835b7b22191f28A3b19562D1 -> INTERMEDIARIO
      0xAC3346f3c528EF515E43c8450833907B3886a49C -> DEPOLY
      0xDdCBbcf639BBCBBD48bF4C3471E0fE732Cd4C941 -> PRESTAMISTA 

    */
    using SafeMath for uint256;

    address private owner;
    //mapping(address => uint256) public balances;
    
    // Direcciones ;
    address payable public contrato;
    address payable private intermediary = payable(0x72f188f3767fE8FE835b7b22191f28A3b19562D1);
    uint256 private maxEthPerTransaction = 1 ether; // Máximo 1 ETH por transacción

    //uint256 totalSupply_;

    event PaymentReceived(address from, uint256 amount);
    event PaymentSent(address to, uint256 amount);
 

    constructor(){ 
        owner = msg.sender;
        contrato = payable(address(this));    
    }

     modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion.");
        _;
    }

    function isValidAddress(address _address) internal view returns (bool) {
        return (_address != address(0) && _address != address(contrato) && bytes20(_address).length == 20);
    }

    // Función para agregar ETH a una dirección específica
    function addEthToAddress(address payable _receiver) external payable {
        require(isValidAddress(_receiver), "La direccion del receptor no es valida");
        require(msg.value > 0 && msg.value <= maxEthPerTransaction, "Cantidad de ETH no valida");
        require(this.addressBalance(msg.sender) > 0, "La cuenta origen no tiene saldo"); 
       
        // Transferir ETH a la dirección específica
        _receiver.transfer(msg.value);
        emit PaymentSent(_receiver, msg.value);
    }

        // Función para dividir un monto entre dos direcciones
    function payment(address payable _receiver) external payable{
        require(isValidAddress(_receiver), "La direccion del receptor no es valida");
        require(msg.value > 0 && msg.value <= maxEthPerTransaction, "Cantidad de ETH no valida");
        require(this.addressBalance(msg.sender) > 0, "La cuenta origen no tiene saldo"); 
        
        uint256 twoPercent = SafeMath.discountTransaction(msg.value);
        uint256 remainingAmount = SafeMath.sub(msg.value, twoPercent);

        // Enviar el 2% a RECEIVER_1
        intermediary.transfer(twoPercent);
        emit PaymentSent(intermediary, twoPercent);

        // Enviar el restante a RECEIVER_2
        _receiver.transfer(remainingAmount);
        emit PaymentReceived(_receiver, remainingAmount);
    }

    // Función para obtener el balance del contrato
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

     function addressBalance(address _to) external view returns (uint256) {
        return _to.balance;
    }

    // Obtenemos la direccion del Owner
    function getOwner() external view returns (address) {
        return owner;
    }

    

}