# 🚀 APB Slave UVM Verification

A UVM-based verification environment for an **AMBA APB memory slave**, developed using **SystemVerilog, UVM 1.2, and Synopsys VCS**.

## 📌 Project Overview

This project verifies the functionality of an APB slave including:

- Read and write operations
- Reset behavior
- Reset during transaction
- Byte strobe (`PSTRB`) handling
- Misaligned address detection
- Out-of-range address detection
- Boundary address testing
- Random address testing
- Protocol violation testing
- Random stress testing
- Functional coverage
- Code coverage

## 🧩 APB Configuration

| Parameter | Value |
| Address Width | 32 bits |
| Data Width | 64 bits |
| Strobe Width | 8 bits |
| Memory Size | 64 KB |
| Word Size | 8 bytes |
| Valid Address Range | `0x0000_0000 - 0x0000_FFFF` |
| Highest Aligned Address | `0x0000_FFF8` |

## 🏗️ UVM Environment

The verification environment contains:

- Transaction
- Sequence
- Sequencer
- Driver
- Monitor
- Agent
- Scoreboard
- Functional Coverage
- Environment
- Test Classes

Basic data flow:

Sequence → Sequencer → Driver → DUT → Monitor → Scoreboard / Coverage

## 🧪 Test Cases

- `apb_reset_test`
- `apb_reset_while_trans_test`
- `apb_successive_wr_test`
- `apb_b2b_wr_test`
- `apb_slave_error_aor_test`
- `apb_random_addr_wr_test`
- `apb_strobe_test`
- `apb_addr_misaligned_test`
- `apb_boundary_test`
- `apb_random_stress_test`
- `apb_violation_test`

## 📊 Coverage

Functional coverage includes:

- Read / Write
- Address regions
- Boundary addresses
- Aligned / Misaligned accesses
- Write strobes
- Slave error response
- Cross coverage

Code coverage is collected using **Synopsys VCS / URG** and includes:

- Line Coverage
- Condition Coverage
- Toggle Coverage

## 🛠️ Tools Used

- SystemVerilog
- UVM 1.2
- Synopsys VCS
- Synopsys URG
- DVE
- Git
- GitHub

## 📂 Project Structure

APB-Slave-UVM-Verification/
├── rtl/
├── tb/
├── sim/
├── doc/
└── README.md

## ✅ Verification Status

All implemented test scenarios are successfully executed with:

UVM_ERROR : 0  
UVM_FATAL : 0

## 👩‍💻 Author

**Nida Saeed**

Digital Design & Verification Project
