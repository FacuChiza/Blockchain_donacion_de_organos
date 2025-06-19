// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RegistroDonantesReceptores {
    
    enum Rol { Ninguno, Hospital, Auditor }
    enum Tipo { Donante, Receptor }

    struct Persona {
        bytes32 idHash;
        Tipo tipo;
        uint256 timestamp;
        address registradoPor;
    }

    address public administrador;
    mapping(address => Rol) public roles;
    mapping(bytes32 => Persona) public personas;

    event PersonaRegistrada(bytes32 indexed idHash, Tipo tipo, address registradoPor);
    event RolAsignado(address indexed cuenta, Rol rol);

    modifier soloAdministrador() {
        require(msg.sender == administrador, "No autorizado");
        _;
    }

    modifier soloHospital() {
        require(roles[msg.sender] == Rol.Hospital, "Solo hospitales pueden registrar");
        _;
    }

    constructor() {
        administrador = msg.sender;
        roles[msg.sender] = Rol.Auditor;
    }

    function asignarRol(address cuenta, Rol rol) external soloAdministrador {
        require(rol != Rol.Ninguno, "Rol invalido");
        roles[cuenta] = rol;
        emit RolAsignado(cuenta, rol);
    }

    function registrarPersona(bytes32 idHash, Tipo tipo) external soloHospital {
        require(personas[idHash].timestamp == 0, "Ya registrado");

        personas[idHash] = Persona({
            idHash: idHash,
            tipo: tipo,
            timestamp: block.timestamp,
            registradoPor: msg.sender
        });

        emit PersonaRegistrada(idHash, tipo, msg.sender);
    }

    function verificarRegistro(bytes32 idHash) external view returns (bool existe, Tipo tipo, address registradoPor, uint256 timestamp) {
        Persona memory p = personas[idHash];
        if (p.timestamp > 0) {
            return (true, p.tipo, p.registradoPor, p.timestamp);
        } else {
            return (false, Tipo.Donante, address(0), 0);
        }
    }
}
