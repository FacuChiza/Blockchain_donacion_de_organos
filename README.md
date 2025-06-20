
# Sistema Ético de Emparejamiento de Órganos basado en Blockchain

Este repositorio contiene los contratos inteligentes fundamentales para un sistema descentralizado y transparente de gestión de donación y trasplante de órganos. El sistema prioriza la necesidad médica por sobre la capacidad económica, garantizando equidad, trazabilidad y auditoría social mediante tecnología blockchain.

## Componentes principales

### 1. `RegistroDonantesReceptores.sol`
Permite registrar donantes y receptores de forma anónima (hash), garantizando que solo hospitales autorizados puedan hacer registros válidos. También permite asignar roles como `Hospital` y `Auditor`.

### 2. `PrioridadMedica.sol`
Asigna un puntaje objetivo (score) a cada receptor según:
- Urgencia médica
- Compatibilidad
- Edad
- Tiempo en lista de espera

El score total es calculado con ponderaciones predefinidas, y se puede consultar públicamente.

### 3. `MatchingOrganos.sol`
Evalúa automáticamente la mejor compatibilidad para un donante entre múltiples receptores activos. Genera un emparejamiento con estado "Pendiente" y guarda un historial de matches.

### 4. `TrazabilidadTransplante.sol`
Registra en la blockchain los pasos clave del proceso:
- Preparación
- Transporte
- Cirugía
- Finalización

Cada evento es firmado por el responsable (hospital, cirujano, etc.) y queda registrado de forma auditable.

---

## Principios Éticos y Técnicos

- ✅ Prioridad basada en criterios médicos verificables
- 🔏 Privacidad mediante hashing y anonimización
- 📖 Contratos auditables, abiertos y sin intervención manual
- 🧠 Gobernanza ética participativa (ONUs, hospitales, pacientes)
- 🧾 Auditoría ciudadana incorporada

---

## Requisitos para el despliegue

- Solidity ^0.8.20
- Herramientas como Hardhat o Remix
- Opcional: IPFS y zk-SNARKs para anonimato avanzado

---

## Próximos pasos

- Testing con Hardhat (mockeo de prioridad y registros)
- Frontend de visualización ética (React + ethers.js)
- Extensión para ZKP y DAO de gobernanza


> Este proyecto busca revolucionar el sistema de donación de órganos, haciendo que la vida sea un derecho y no un privilegio.
#   B l o c k c h a i n _ d o n a c i o n _ d e _ o r g a n o s 
 
 