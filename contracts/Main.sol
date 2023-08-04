// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./token/ERC20.sol";
import "./utils/Context.sol";

contract Main is ERC20 {

   /* 0x5E3F773D4C0eAC9BbC410623DF5fAd45F08DCFA0 -> PRESTATARIO
      0x72f188f3767fE8FE835b7b22191f28A3b19562D1 -> INTERMEDIARIO
      0xAC3346f3c528EF515E43c8450833907B3886a49C -> DEPOLY
      0xDdCBbcf639BBCBBD48bF4C3471E0fE732Cd4C941 -> PRESTAMISTA 

    */
    using SafeMath for uint256;

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
 

    constructor() payable ERC20("FlixCapital", "FLX") { 
        //totalSupply_ = total;
        // token = new ERC20("MyToken", "MTK");
        owner = msg.sender;
        contrato = address(this);
       
    }

    function addEthToBalance(uint amount) payable external  {
        require(msg.value > 0, "Debes enviar ETH");
        require(msg.value == amount, "Valor ingresado no valido");
        payable(msg.sender).transfer(contrato.balance);
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

    function paymentValue(address _to, uint256 _value) external payable {
 
        uint coste = costValue(_value);
        // Se requiere que el valor de ethers pagados sea equivalente al coste 
        require (_value >= coste, "Compra menos Tokens o paga con mas Ethers.");
        
        // Diferencia a pagar 
        uint256 returnValue = _value - coste;
        
        // Tranferencia de la diferencia 
        payable(_to).transfer(returnValue);

        // Tranferencia  el coste a la cuenta intermediaria 
        payable(intermediary).transfer(coste);
       
        // Obtener el balance de Tokens del contrato 
        uint256 tbalance =  this.balanceOf(contrato);
        
        // Filtro para evaluar los tokens a comprar con los tokens disponibles 
        require (_value <= tbalance, "Compra un numero de Tokens adecuado.");
       
        // Tranferencia de Tokens al comprador  
        this.transfer(_to, _value);
       
       // Emitir el evento de compra tokens 
        emit PaymentSent(_to, _value);
    }

    // Función para obtener el balance del contrato
    function getContractBalance() external view returns (uint256) {
        return contrato.balance;
    }



    

}