// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./token/ERC20.sol";

contract Main is ERC20 {

   /* 0x5E3F773D4C0eAC9BbC410623DF5fAd45F08DCFA0 -> PRESTATARIO
      0x72f188f3767fE8FE835b7b22191f28A3b19562D1 -> INTERMEDIARIO
      0xAC3346f3c528EF515E43c8450833907B3886a49C -> DEPOLY
      0xDdCBbcf639BBCBBD48bF4C3471E0fE732Cd4C941 -> PRESTAMISTA 

    */

    address public owner;
    //mapping(address => uint256) public balances;

    // Instancia del contrato Token 
    // ERC20 private token;
    
    // Direcciones ;
    address public contrato;
    address public intermediary = 0x72f188f3767fE8FE835b7b22191f28A3b19562D1;
    //uint256 totalSupply_;

    event PaymentReceived(address from, uint256 amount);
    event PaymentSent(address to, uint256 amount);

    constructor() ERC20("MyToken", "MTK") { 
        //totalSupply_ = total;
        // token = new ERC20("MyToken", "MTK");
        owner = msg.sender;
        contrato = address(this);
        
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion.");
        _;
    }

    function costValue(uint256 number) internal pure returns (uint256){
        return number*(1 ether);
    }

    function valueTransaction(uint256 number) internal pure returns (uint256){
        // Calcula el 2% del número
        return (number * 2) / 100;
    }

    // function balance() public view returns (uint256) {
    //     return token.balanceOf(contrato);
    // }

    function GeneraTokens(address account, uint amount) public onlyOwner(){
        _mint(account, amount);
    }

    function paymentValue(address payable to, uint256 value) external payable {
        // Calcular el coste de los tokens 
        
        uint256 coste = valueTransaction(value);
        
        // Se requiere que el valor de ethers pagados sea equivalente al coste 
        require (value >= coste, "Compra menos Tokens o paga con mas Ethers.");
        
        // Diferencia a pagar 
        uint256 returnValue = value - coste;
        
        // Tranferencia de la diferencia 
        payable(to).transfer(returnValue);

        // Tranferencia  el coste a la cuenta intermediaria 
        payable(intermediary).transfer(coste);
       
        // Obtener el balance de Tokens del contrato 
        uint256 tbalance =  this.balanceOf(contrato);
        
        // Filtro para evaluar los tokens a comprar con los tokens disponibles 
        require (value <= tbalance, "Compra un numero de Tokens adecuado.");
       
        // Tranferencia de Tokens al comprador  
        this.transfer(to, value);
       
       // Emitir el evento de compra tokens 
        emit PaymentSent(to, value);
    }

    // function realizarPago() external payable {
    //     require(msg.value > 0, "El pago debe ser mayor a cero.");

    //     uint256 returnValue = token.balanceOf(msg.sender) += msg.value;
    //     emit PaymentReceived(msg.sender, msg.value);
    // }

    // function verificarSaldo() external view returns (uint256) {
    //     return token.balanceOf[msg.sender];
    // }

    // function enviarPago(address payable recipient, uint256 amount) external onlyOwner {
    //     require(amount > 0, "El monto del pago debe ser mayor a cero.");
    //     require( token.balanceOf[msg.sender] >= amount, "Saldo insuficiente para realizar el pago.");

    //     token.balanceOf[msg.sender] -= amount;
    //     recipient.transfer(amount);
    //     emit PaymentSent(recipient, amount);
    // }




    

}