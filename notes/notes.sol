// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.10 < 0.8.18;
pragma experimental ABIEncoderV2;

 contract notes{

    //  Direccion del profesor
    address public profesor;

    constructor () public {
        profesor = msg.sender;
    }

    //  Mapping para relacionar el hash de la identidad del alumno con su nota del examen
    mapping (bytes32 => uint) notes;

    //  Array de los alumnos que soliciten revisiones examen
    string[] revisiones;

    //Eventos
    event alumno_evaluado(bytes32);
    event evento_revision(string);

    // funcion que evalua alumno
    function evaluar(string memory _idAlumno, uint _nota) public onlyProfesor(msg.sender){
        // HASH identificador alumno
        bytes32 hashAlumno = keccak256(abi.encodePacked(_idAlumno));
        //relacion hash identificacion con nota
        notes[hashAlumno] = _nota;
        //Emitir evento
        emit alumno_evaluado(hashAlumno);
    }

    // control de funciones ejecutables por el profesor
    modifier onlyProfesor(address _direccion){
        //requiere que la direccion introducida por parametro sea igual al owner del contrato
        require(_direccion == profesor, "No tiene permisos para ejecutar esta funciona");
        _;
    }

    // funcion para ver notas
    function viewNotes(string memory _idAlumno) public view returns(uint){
        // HASH identificador alumno
        bytes32 hashAlumno = keccak256(abi.encodePacked(_idAlumno));
        // nota asociada al hash del alumno
        uint notaAlumno = notes[hashAlumno];
        return notaAlumno;
    }

    //funcion para revision de notas
    function revision(string memory _idAlumno) public{

        //almacenamiento identidad alumno
        revisiones.push(_idAlumno);
        //emision evento
        emit evento_revision(_idAlumno);
    }

    //funcion ver los alumnos que han solicitado revision
    function viewRevision() public view onlyProfesor(msg.sender) returns(string [] memory){
        //devolver las identidades de los alumnos
        return revisiones;
    }
 }