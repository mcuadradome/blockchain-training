// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./token/ERC20.sol";
import "./utils/Context.sol";

contract Main {

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
    address payable  public contrato;
    address payable private intermediary = payable(0x72f188f3767fE8FE835b7b22191f28A3b19562D1);
    uint256 public maxEthPerTransaction = 1 ether; // Máximo 1 ETH por transacción

    //uint256 totalSupply_;

    event PaymentReceived(address from, uint256 amount);
    event PaymentSent(address to, uint256 amount);
 

    constructor(){ 
        // totalSupply_ = total;
        // token = new ERC20("MyToken", "MTK");
        owner = msg.sender;
        contrato = payable(address(this));    
    }

     modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede ejecutar esta funcion.");
        _;
    }

    function isValidAddress(address _address) external view returns (bool) {
        return (_address != address(0) && _address != address(contrato) && bytes20(_address).length == 20);
    }

    // function addEthToBalance(uint256 amount) payable external onlyOwner()  {
    //     require(msg.value > 0, "Debe enviar ETH");
    //     require(msg.value ==  SafeMath.convertToWei(amount), "El valor ingresado no es valido");
    //     require(this.contractBalance() > 0, "El contrato no tiene saldo para procesar la transaccion");

    //     uint256 balance = SafeMath.add(this.contractBalance(), msg.value); 
    //     payable(msg.sender).transfer(balance);
    // }

    // Función para agregar ETH a una dirección específica
    function addEthToAddress(address payable _receiver) external payable onlyOwner() {
        //require(_receiver != address(0), "La direccion del receptor no puede ser 0x0");
        require(this.isValidAddress(_receiver), "La direccion del receptor no es valida");
        require(msg.value > 0 && msg.value <= maxEthPerTransaction, "Cantidad de ETH no valida");
        require(this.addressBalance(msg.sender) > 0, "La cuenta origen no tiene saldo"); 
       
        // Transferir ETH a la dirección específica
        _receiver.transfer(msg.value);
        emit PaymentSent(_receiver, msg.value);
    }

        // Función para dividir un monto entre dos direcciones
    function payment(address payable _receiver) payable external onlyOwner(){
        require(msg.value > 0 && msg.value <= maxEthPerTransaction, "Cantidad de ETH no valida");
        require(this.addressBalance(msg.sender) == 0, "La cuenta origen no tiene saldo"); 
        require(this.isValidAddress(_receiver), "La direccion del receptor no es valida");

        uint256 twoPercent = SafeMath.discountTransaction(msg.value);
        uint256 remainingAmount = SafeMath.sub(msg.value, twoPercent);

        // Enviar el 2% a RECEIVER_1
        intermediary.transfer(twoPercent);
        emit PaymentReceived(_receiver, twoPercent);

        // Enviar el restante a RECEIVER_2
        _receiver.transfer(remainingAmount);
        emit PaymentReceived(_receiver, remainingAmount);
    }

    // function balance() public view returns (uint256) {
    //     return token.balanceOf(contrato);
    // }

    // function GeneraTokens(address account, uint amount) public onlyOwner(){
    //     _mint(account, amount);
    // }

    // function paymentValue(address _to, uint256 _value) external payable {
 
    //     uint coste = costValue(_value);
    //     // Se requiere que el valor de ethers pagados sea equivalente al coste 
    //     require (_value >= coste, "Compra menos Tokens o paga con mas Ethers.");
        
    //     // Diferencia a pagar 
    //     uint256 returnValue = _value - coste;
        
    //     // Tranferencia de la diferencia 
    //     payable(_to).transfer(returnValue);

    //     // Tranferencia  el coste a la cuenta intermediaria 
    //     payable(intermediary).transfer(coste);
       
    //     // Obtener el balance de Tokens del contrato 
    //     uint256 tbalance =  this.balanceOf(contrato);
        
    //     // Filtro para evaluar los tokens a comprar con los tokens disponibles 
    //     require (_value <= tbalance, "Compra un numero de Tokens adecuado.");
       
    //     // Tranferencia de Tokens al comprador  
    //     this.transfer(_to, _value);
       
    //    // Emitir el evento de compra tokens 
    //     emit PaymentSent(_to, _value);
    // }

    // Función para obtener el balance del contrato
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

     function addressBalance(address _to) external view returns (uint256) {
        return _to.balance;
    }



    

}