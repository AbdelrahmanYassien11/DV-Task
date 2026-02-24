<p align="center">
  <img src="https://img.shields.io/badge/SystemVerilog-6B2B44?style=for-the-badge&logo=systemverilog&logoColor=white" />
  <img src="https://img.shields.io/badge/UVM-FF6A21?style=for-the-badge&logo=uvm&logoColor=white" />
  <img src="https://img.shields.io/badge/RAL-5A47FF?style=for-the-badge&logo=ral&logoColor=white" />
  <img src="https://img.shields.io/badge/UART-3B36E9?style=for-the-badge&logo=uart&logoColor=white" />
  <img src="https://img.shields.io/badge/Questasim-008080?style=for-the-badge&logo=mentor&logoColor=white" />
</p>

<h1 align="center" style="color:#6B2B44;">📡 UVM-Based UART Register Model Verification Framework 📡</h1>

<p align="center">
  <b>Professional UVM testbench for UART protocol verification with integrated Register Abstraction Layer (RAL), demonstrating industry-standard verification methodologies, modular architecture, and comprehensive register model integration.</b>
</p>

---

## 🎨 Overview

This repository showcases a **production-grade verification environment** for UART (Universal Asynchronous Receiver/Transmitter) protocol using:
- <span style="color:#6B2B44"><b>SystemVerilog</b></span> for testbench infrastructure and interfaces
- <span style="color:#FF6A21"><b>UVM (Universal Verification Methodology)</b></span> for modular, reusable verification components
- <span style="color:#5A47FF"><b>Register Abstraction Layer (RAL)</b></span> for register model abstraction and verification
- <span style="color:#3B36E9"><b>Protocol Adapters</b></span> for seamless register-to-bus translation
- <span style="color:#008080"><b>Questa/ModelSim</b></span> compatible simulation environment

The project implements **asynchronous UART timing** with proper bit-period delays, supports **multiple baud rates** (19200, 115200), and includes a complete **register model** with auto-prediction for mirror value updates.

---

## 📁 Repository Structure

```
.
├── tb/
│   ├── uart_if.sv                    # UART interface (TX, RST signals)
│   ├── uart_transaction.sv           # UART transaction with register encoding
│   ├── uart_config.sv                # Configuration object (baud rates)
│   ├── uart_driver.sv                # Asynchronous UART driver
│   ├── uart_monitor.sv               # UART monitor with auto-predict support
│   ├── uart_sequencer.sv             # UVM sequencer
│   ├── uart_agent.sv                 # Complete UART agent
│   ├── uart_reg_model.sv             # Register definitions (R1, R2)
│   │                                 # Register block and adapter
│   ├── uart_env.sv                   # Environment with RAL integration
│   ├── uart_sequences.sv             # Base sequences (valid/error transactions)
│   ├── uart_reg_sequences.sv         # Register operation sequences
│   ├── uart_tests.sv                 # Test classes
│   └── uart_tb_top.sv                # Top-level testbench
├── docs/
│   ├── TASK1_GUIDE.md                # Task 1 implementation details
│   ├── TASK2_1_GUIDE.md              # Task 2.1 RAL integration guide
│   ├── ASYNC_UART_TIMING.md          # Asynchronous timing explanation
│   ├── CLOCKING_BLOCKS_GUIDE.md      # Clocking block best practices
│   ├── ENCODE_DECODE_EXPLAINED.md    # Register encoding details
│   ├── MIRRORED_VS_DESIRED.md        # RAL value concepts
│   └── MONITOR_RAL_CONNECTION.md     # Auto-predictor flow
├── sim/
│   ├── Makefile                      # Build automation
│   ├── run_questa.sh                 # Questa simulation script
│   └── run_questa_interactive.sh     # Interactive simulation
└── README.md                         # This file
```

- <span style="color:#6B2B44"><b>/tb</b></span>: Complete UVM testbench with all verification components
- <span style="color:#FF6A21"><b>/docs</b></span>: Comprehensive documentation and guides
- <span style="color:#5A47FF"><b>/sim</b></span>: Simulation scripts and build files

---

## ✨ Features

### Core Verification Components
- <img src="https://img.shields.io/badge/UART%20Protocol-6B2B44?style=flat-square" height="18"/> Asynchronous UART with proper bit timing (no clock-based protocol)
- <img src="https://img.shields.io/badge/UVM%20Agent-FF6A21?style=flat-square" height="18"/> Complete agent with driver, monitor, sequencer
- <img src="https://img.shields.io/badge/Register%20Model-5A47FF?style=flat-square" height="18"/> Full RAL integration with auto-prediction
- <img src="https://img.shields.io/badge/Protocol%20Adapter-3B36E9?style=flat-square" height="18"/> reg2bus/bus2reg conversion layer

### Register Model (Task 2.1)
- <img src="https://img.shields.io/badge/R1%20Register-ED254E?style=flat-square" height="18"/> 4-bit Read/Write register (addr 0x0, reset 0x0)
- <img src="https://img.shields.io/badge/R2%20Register-ED254E?style=flat-square" height="18"/> 4-bit Read-Only register (addr 0x1, reset 0xA)
- <img src="https://img.shields.io/badge/Single%20Transaction-3B36E9?style=flat-square" height="18"/> Packed encoding: [Data(4)][Addr(3)][Op(1)]
- <img src="https://img.shields.io/badge/Auto%20Predict-FF6A21?style=flat-square" height="18"/> Automatic mirror value updates

### Advanced Features
- <img src="https://img.shields.io/badge/Configurable%20Baud-6B2B44?style=flat-square" height="18"/> 19200 and 115200 bps support
- <img src="https://img.shields.io/badge/Even%20Parity-5A47FF?style=flat-square" height="18"/> Automatic parity calculation
- <img src="https://img.shields.io/badge/Error%20Injection-ED254E?style=flat-square" height="18"/> Sequences with protocol violations
- <img src="https://img.shields.io/badge/Comprehensive%20Docs-3B36E9?style=flat-square" height="18"/> Detailed guides and explanations

---

## 🔧 UART Protocol Implementation

### Transaction Format
```
Complete UART Frame (11 bits):
┌──────┬───┬───┬───┬───┬───┬───┬───┬───┬────────┬──────┐
│Start │D0 │D1 │D2 │D3 │D4 │D5 │D6 │D7 │ Parity │ Stop │
├──────┼───┼───┼───┼───┼───┼───┼───┼───┼────────┼──────┤
│  0   │Op │  Address  │     Data      │   P    │  1   │
└──────┴───┴───┴───┴───┴───┴───┴───┴───┴────────┴──────┘
         └1┘└────3────┘└──────4───────┘

Bit 0:     Operation (0=read, 1=write)
Bits 3:1:  Address (3 bits, 8 addresses)
Bits 7:4:  Data (4 bits)
Parity:    Even parity
```

### Register Encoding Example
```systemverilog
// Write 0x7 to R1 (address 0x0)
Operation: 1 (write)
Address:   000 (0x0)
Data:      0111 (0x7)

UART byte: [0111][000][1] = 0x71

Complete frame:
Start│1│0│0│0│1│1│1│0│Parity│Stop
  0  │ └──Register info──┘   │ 1
```

---

## 🏗️ Architecture

### Component Hierarchy
```
uart_tb_top
  └── uart_test (test)
        └── uart_env (environment)
              ├── uart_agent (agent)
              │     ├── uart_driver
              │     ├── uart_monitor
              │     └── uart_sequencer
              ├── uart_reg_block (register model)
              │     ├── reg_r1 (R1 register)
              │     └── reg_r2 (R2 register)
              └── uart_reg_adapter (protocol adapter)
```

### Data Flow: Register Write
```
Test Sequence
     ↓
reg_model.R1.write(0x7)
     ↓
Adapter (reg2bus)
     ↓ Encodes to 0x71
Driver → UART TX
     ↓
Monitor ← UART TX
     ↓ Decodes from 0x71
Adapter (bus2reg)
     ↓
Auto-Predictor
     ↓
Register Model (MIRRORED = 0x7)
```

---

## 🚀 Getting Started

### Prerequisites
- **Questa/ModelSim** (10.5 or later)
- **UVM Library** (usually included with Questa)
- **Make** (for build automation)

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/uart-uvm-verification.git
   cd uart-uvm-verification
   ```

2. **Navigate to simulation directory**
   ```bash
   cd sim
   ```

3. **Run simulation (using Makefile)**
   ```bash
   make compile   # Compile all files
   make sim       # Run in console mode
   make gui       # Run with GUI and waveforms
   ```

4. **Alternative: Manual compilation**
   ```bash
   # Set UVM_HOME if not already set
   export UVM_HOME=/path/to/questa/verilog_src/uvm-1.2
   
   # Compile
   vlog -sv \
        +incdir+$UVM_HOME/src \
        $UVM_HOME/src/uvm_pkg.sv \
        ../tb/*.sv
   
   # Run
   vsim -c uart_tb_top \
        +UVM_TESTNAME=uart_reg_test \
        +UVM_VERBOSITY=UVM_MEDIUM \
        -do "run -all; quit -f"
   ```

### Using Interactive Script
```bash
chmod +x run_questa_interactive.sh
./run_questa_interactive.sh
# Choose: 1 for console, 2 for GUI
```

---

## 📊 Test Scenarios

### Task 1: Basic UART Verification
- **seq1**: 10 valid random UART transactions
- **seq2**: 10 transactions with random errors (start/stop/parity violations)
- **Verification**: Monitor collects and prints all transactions

### Task 2.1: Register Model Integration
- **Register writes**: Write random data to R1 and R2
- **RO verification**: Verify R2 (Read-Only) rejects writes
- **Mirror check**: Verify mirrored values match expected values
- **Auto-prediction**: Validate automatic mirror updates

Expected output:
```
UVM_INFO: Writing 0x7 to R1 (addr=0x0)
UVM_INFO: DRIVER: Driving Data=0x71 [WR, Addr=0x0, RegData=0x7]
UVM_INFO: MONITOR: Collected Data=0x71 [WR, Addr=0x0, RegData=0x7]
UVM_INFO: R1: Wrote=0x7, Mirrored=0x7, PASS ✓
UVM_INFO: R2: Wrote=0x3, Mirrored=0xA, PASS (RO protected) ✓
```

---

## 📖 Documentation

### Quick References
- **[Task 1 Guide](docs/TASK1_GUIDE.md)**: Basic UART testbench setup
- **[Task 2.1 Guide](docs/TASK2_1_GUIDE.md)**: Register model integration
- **[Integration Guide](docs/INTEGRATION_GUIDE_TASK2_1.md)**: Step-by-step integration instructions

### Concept Explanations
- **[Async UART Timing](docs/ASYNC_UART_TIMING.md)**: Why UART doesn't use clocking blocks
- **[Clocking Blocks Guide](docs/CLOCKING_BLOCKS_GUIDE.md)**: When and how to use them
- **[Encode/Decode](docs/ENCODE_DECODE_EXPLAINED.md)**: Register field packing/unpacking
- **[Mirrored vs Desired](docs/MIRRORED_VS_DESIRED.md)**: Understanding RAL values
- **[Monitor-RAL Connection](docs/MONITOR_RAL_CONNECTION.md)**: Auto-predictor flow

### Advanced Topics
- **[Register Parameterization](docs/UVM_REG_PARAMETERIZATION.md)**: Scalable register definitions
- **[Complete UART Frame](docs/UART_FRAME_COMPLETE_EXPLANATION.md)**: Bit-by-bit breakdown

---

## 🎯 Key Concepts Demonstrated

### UVM Methodology
- ✅ **Factory Pattern**: All components use `type_id::create()`
- ✅ **Configuration Objects**: Baud rate configuration via `uart_config`
- ✅ **TLM Ports**: Analysis ports for monitor-to-RAL communication
- ✅ **Phases**: Proper use of build, connect, reset, and run phases

### Register Abstraction Layer (RAL)
- ✅ **Register Definitions**: `uvm_reg` with field configuration
- ✅ **Register Block**: `uvm_reg_block` with address map
- ✅ **Adapter Pattern**: `reg2bus` and `bus2reg` conversion
- ✅ **Auto-Prediction**: Automatic mirror value updates from bus activity

### Protocol Implementation
- ✅ **Asynchronous Timing**: Pure `#delay` based, no clock dependencies
- ✅ **Bit Encoding**: Efficient packing of operation/address/data
- ✅ **Parity Generation**: Automatic even parity calculation
- ✅ **Error Injection**: Controllable protocol violations for coverage

---

## 🔬 Verification Features

### Randomization
```systemverilog
// Constrained random with valid UART framing
constraint valid_start_bit { start_bit == 1'b0; }
constraint valid_stop_bit { stop_bit == 1'b1; }
constraint valid_parity_bit { parity_bit == ^data; }
```

### Register Verification
```systemverilog
// Write and verify
reg_model.R1.write(status, 4'h7);
assert(reg_model.R1.get_mirrored_value() == 4'h7)
  else `uvm_error("TEST", "Mirror mismatch!")
```

### Coverage (Future Enhancement)
- Protocol coverage: Start/stop/parity combinations
- Register coverage: All addresses, access types
- Error coverage: Various protocol violations

---

## 🖼️ Example Waveforms

### Valid UART Transaction (Write 0x7 to R1)
```
Time (ns): 0      8680   17360  26040  34720  43400  52080  60760  69440  78120  86800
           │       │      │      │      │      │      │      │      │      │      │
TX:    ────┘       └──────┘      └─────────────────────────────────┘      └──────────
       IDLE│START  │ D0   │ D1   │ D2   │ D3   │ D4   │ D5   │ D6   │ D7   │ PAR  │STOP
           │  0    │  1   │  0   │  0   │  0   │  1   │  1   │  1   │  0   │  1   │ 1
           └───────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴───
                    └Op=W─┘└───Addr=0───┘└─────Data=7──────┘

Duration: 95.48 μs (115200 baud)
Encoded: 0x71 = [0111][000][1]
```

---

## 🛠️ Makefile Targets

```bash
make compile      # Compile all files
make sim          # Run in console mode
make gui          # Run with GUI
make sim_low      # Run with UVM_LOW verbosity
make sim_high     # Run with UVM_HIGH verbosity
make sim_debug    # Run with UVM_DEBUG verbosity
make clean        # Clean all artifacts
make help         # Show help
```

---

## 🔄 Future Enhancements

### Task 2.1* (8-bit Registers, 3-Transaction Protocol)
- Extend to 8-bit registers
- Implement multi-transaction protocol:
  1. Command transaction
  2. Address transaction
  3. Data transaction

### Task 2.2 (Bidirectional UART)
- Add RX line support
- Implement bidirectional agent
- Create dual-agent topology

### Task 2.3 (Register Read Operations)
- Implement read protocol
- Add read-back verification
- Support TX → RX read flow

### Task 2.4 (Complete Register File)
- Full register file with scoreboard
- Read/write verification
- Data integrity checking

---

## 📚 Learning Resources

This project demonstrates concepts from:
- **UVM 1.2 User Guide** (IEEE 1800.2)
- **SystemVerilog LRM** (IEEE 1800-2017)
- **UART Protocol Specification** (Wiki: Universal Asynchronous Receiver-Transmitter)
- Industry best practices for register model verification

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure:
- Code follows UVM coding standards
- All tests pass
- Documentation is updated
- Commit messages are descriptive

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📫 Contact

<p>
  <img src="https://img.shields.io/badge/GitHub-YourUsername-6B2B44?style=flat-square&logo=github&logoColor=white" height="18"/> <a href="https://github.com/YOUR_USERNAME">GitHub Profile</a><br>
  <img src="https://img.shields.io/badge/LinkedIn-Your%20Name-AA1745?style=flat-square&logo=linkedin&logoColor=white" height="18"/> <a href="https://www.linkedin.com/in/YOUR_PROFILE">LinkedIn Profile</a><br>
  <img src="https://img.shields.io/badge/Email-your.email@example.com-ED254E?style=flat-square&logo=gmail&logoColor=white" height="18"/> <a href="mailto:your.email@example.com">Email</a>
</p>

---

## 🙏 Acknowledgments

- **UVM Community** for the Universal Verification Methodology
- **UART Protocol** designers for the simple yet robust asynchronous protocol
- **Verification Engineers** worldwide for sharing best practices
- **Open Source Community** for tools and resources

---

<p align="center" style="color:#ED254E; font-size:1.2em;">
  <b>⭐ If this project helped you learn UVM or UART verification, please star it! ⭐</b>
</p>

<p align="center">
  <sub>Built with ❤️ for the verification community</sub>
</p>
