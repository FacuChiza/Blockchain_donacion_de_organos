// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrazabilidadTransplante {

    enum EstadoProceso { Preparacion, EnTransporte, EnCirugia, Completado }

    struct RegistroTransplante {
        bytes32 idEmparejamiento;
        EstadoProceso estado;
        string detalle;
        uint256 timestamp;
        address responsable;
    }

    address public administrador;
    mapping(bytes32 => RegistroTransplante[]) public trazabilidad;

    event EstadoActualizado(bytes32 indexed idEmparejamiento, EstadoProceso nuevoEstado, string detalle, address responsable);

    modifier soloAdministrador() {
        require(msg.sender == administrador, "No autorizado");
        _;
    }

    constructor() {
        administrador = msg.sender;
    }

    function actualizarEstado(bytes32 idEmparejamiento, EstadoProceso nuevoEstado, string calldata detalle) external soloAdministrador {
        RegistroTransplante memory registro = RegistroTransplante({
            idEmparejamiento: idEmparejamiento,
            estado: nuevoEstado,
            detalle: detalle,
            timestamp: block.timestamp,
            responsable: msg.sender
        });

        trazabilidad[idEmparejamiento].push(registro);

        emit EstadoActualizado(idEmparejamiento, nuevoEstado, detalle, msg.sender);
    }

    function obtenerTrazabilidad(bytes32 idEmparejamiento) external view returns (RegistroTransplante[] memory) {
        return trazabilidad[idEmparejamiento];
    }
} 