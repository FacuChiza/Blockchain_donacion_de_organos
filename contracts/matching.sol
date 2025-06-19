// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPrioridadMedica {
    function obtenerPuntaje(bytes32 idHash) external view returns (
        uint256 urgencia,
        uint256 compatibilidad,
        uint256 edad,
        uint256 tiempoEspera,
        uint256 scoreTotal,
        uint8 estado
    );
}

contract MatchingOrganos {

    enum EstadoEmparejamiento { Pendiente, Confirmado, Rechazado }

    struct Emparejamiento {
        bytes32 idDonante;
        bytes32 idReceptor;
        uint256 scoreReceptor;
        EstadoEmparejamiento estado;
        uint256 timestamp;
    }

    address public administrador;
    IPrioridadMedica public prioridadMedica;

    mapping(bytes32 => Emparejamiento) public emparejamientos;
    bytes32[] public historialEmparejamientos;

    event EmparejamientoPropuesto(bytes32 indexed idEmparejamiento, bytes32 idDonante, bytes32 idReceptor, uint256 score);
    event EstadoEmparejamientoActualizado(bytes32 indexed idEmparejamiento, EstadoEmparejamiento nuevoEstado);

    modifier soloAdministrador() {
        require(msg.sender == administrador, "No autorizado");
        _;
    }

    constructor(address _prioridadMedica) {
        administrador = msg.sender;
        prioridadMedica = IPrioridadMedica(_prioridadMedica);
    }

    function proponerEmparejamiento(bytes32 idDonante, bytes32[] calldata receptoresCandidatos) external soloAdministrador {
        bytes32 mejorReceptor;
        uint256 mejorScore = 0;

        for (uint i = 0; i < receptoresCandidatos.length; i++) {
            (,,,, uint256 score, uint8 estado) = prioridadMedica.obtenerPuntaje(receptoresCandidatos[i]);
            if (estado == 0 && score > mejorScore) { // EstadoPaciente.Activo
                mejorScore = score;
                mejorReceptor = receptoresCandidatos[i];
            }
        }

        require(mejorReceptor != bytes32(0), "No hay receptor compatible activo");

        bytes32 idEmparejamiento = keccak256(abi.encodePacked(idDonante, mejorReceptor, block.timestamp));

        emparejamientos[idEmparejamiento] = Emparejamiento({
            idDonante: idDonante,
            idReceptor: mejorReceptor,
            scoreReceptor: mejorScore,
            estado: EstadoEmparejamiento.Pendiente,
            timestamp: block.timestamp
        });

        historialEmparejamientos.push(idEmparejamiento);

        emit EmparejamientoPropuesto(idEmparejamiento, idDonante, mejorReceptor, mejorScore);
    }

    function actualizarEstadoEmparejamiento(bytes32 idEmparejamiento, EstadoEmparejamiento nuevoEstado) external soloAdministrador {
        require(emparejamientos[idEmparejamiento].timestamp != 0, "Emparejamiento no existe");
        emparejamientos[idEmparejamiento].estado = nuevoEstado;
        emit EstadoEmparejamientoActualizado(idEmparejamiento, nuevoEstado);
    }

    function obtenerHistorial() external view returns (bytes32[] memory) {
        return historialEmparejamientos;
    }
} 
