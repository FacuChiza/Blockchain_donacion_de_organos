// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PrioridadMedica {

    enum EstadoPaciente { Activo, Inactivo }

    struct Puntaje {
        uint256 urgencia;        // 0 - 100
        uint256 compatibilidad;  // 0 - 100
        uint256 edad;            // en años
        uint256 tiempoEspera;    // en días
        uint256 scoreTotal;      // calculado
        EstadoPaciente estado;
    }

    address public administrador;
    mapping(bytes32 => Puntaje) public puntajes;

    event PuntajeAsignado(bytes32 indexed idHash, uint256 scoreTotal);
    event EstadoActualizado(bytes32 indexed idHash, EstadoPaciente estado);

    modifier soloAdministrador() {
        require(msg.sender == administrador, "No autorizado");
        _;
    }

    constructor() {
        administrador = msg.sender;
    }

    function calcularScoreTotal(uint256 urgencia, uint256 compatibilidad, uint256 edad, uint256 tiempoEspera) public pure returns (uint256) {
        // Ejemplo de ponderación (ajustable)
        // urgencia: 40%, compatibilidad: 30%, edad: 10%, tiempo de espera: 20%
        return (urgencia * 40 + compatibilidad * 30 + edad * 10 + tiempoEspera * 20) / 100;
    }

    function asignarPuntaje(
        bytes32 idHash,
        uint256 urgencia,
        uint256 compatibilidad,
        uint256 edad,
        uint256 tiempoEspera
    ) external soloAdministrador {
        uint256 total = calcularScoreTotal(urgencia, compatibilidad, edad, tiempoEspera);
        puntajes[idHash] = Puntaje({
            urgencia: urgencia,
            compatibilidad: compatibilidad,
            edad: edad,
            tiempoEspera: tiempoEspera,
            scoreTotal: total,
            estado: EstadoPaciente.Activo
        });

        emit PuntajeAsignado(idHash, total);
    }

    function actualizarEstado(bytes32 idHash, EstadoPaciente nuevoEstado) external soloAdministrador {
        require(puntajes[idHash].scoreTotal > 0, "Paciente no registrado");
        puntajes[idHash].estado = nuevoEstado;
        emit EstadoActualizado(idHash, nuevoEstado);
    }

    function obtenerPuntaje(bytes32 idHash) external view returns (Puntaje memory) {
        return puntajes[idHash];
    }
} 
