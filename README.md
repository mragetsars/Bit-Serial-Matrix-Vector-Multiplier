# Bit-Serial Matrix-Vector Multiplier (Stripes Accelerator)

> **Computer-Aided Design of Digital Systems (CAD) – University of Tehran – Department of Electrical & Computer Engineering**

![Language](https://img.shields.io/badge/Language-Verilog-orange) ![Tool](https://img.shields.io/badge/Tool-ModelSim-blue) ![Status](https://img.shields.io/badge/Status-Completed-success)

## 📌 Overview

This repository contains the Register Transfer Level (RTL) implementation of a **Bit-Serial Matrix-Vector Multiplication Unit**, inspired by the **Stripes Accelerator** architecture. This project was developed as the *Second Assignment* of the *Computer-Aided Design of Digital Systems (CAD)* course at the University of Tehran.

The core concept of this design is **Bit-Serial Computing**, where data is processed bit-by-bit over multiple clock cycles (specifically from MSB to LSB), allowing for significant hardware reduction compared to fully parallel architectures. The system performs matrix-vector multiplication by orchestrating multiple **Processing Elements (PEs)**.

## 🎯 Project Objectives

- ✅ Implementing **Bit-Serial arithmetic** (processing serial input A against parallel input B).
- ✅ Designing a **Strips Processing Element (PE)** for dot-product calculation.
- ✅ Developing a **Matrix-Vector Multiplication Processing Unit (MVMPU)**.
- ✅ Handling memory interfacing for reading Matrix/Vector data and writing results.
- ✅ Breaking down $8\times8$ matrix operations into smaller hardware-constrained chunks ($4\times4$).

## 🧠 System Architecture & Modules

The design is hierarchical, strictly separating **Datapath** and **Control Logic**, and consists of the following key subsystems:

### 1️⃣ Strips Processing Element (PE)

The fundamental computational unit located in `Source/PU_Module`.

* **Function:** Calculates the dot product of two vectors ($\vec{A} \cdot \vec{B}$).
* **Mechanism:** Receives Vector $A$ serially (bit-by-bit) and Vector $B$ in parallel.
* **Logic:** Uses "And-and-Shift" logic but processes from **MSB to LSB**, requiring distinct accumulation and subtraction logic for signed numbers.

### 2️⃣ Matrix-Vector Multiplication Unit (MVMPU)

The top-level controller and datapath located in `Source/`.

* **Function:** Multiplies an $8\times8$ Matrix by an $8\times1$ Vector.
* **Constraint Handling:** Since PEs are designed for 4-element vectors, the MVMPU schedules operations to decompose the $8\times8$ problem into smaller sub-problems and accumulates the results.
* **Memory Interface:** Reads inputs from `memory.v` and writes back the calculated 34-bit results.

### 3️⃣ Register Files & Memory

Located in `Source/Reg_File_Module` and `Source/Memory_Module`.

* **RegFiles:** Efficiently store and shift the input vectors during computation.
* **Main Memory:** A unified memory block storing the Input Vector, Input Matrix, and Output Result.

## 📂 Repository Structure

The project is organized as follows:

```text
Bit-Serial Matrix-Vector Multiplier/
├── Description/           # Project specifications & Test Cases
│   ├── CAD-CA2.pdf        # Assignment description
│   └── TestCases/         # Input/Output memory maps for verification
├── Source/                # Synthesizable RTL Source files
│   ├── MVMPU_*.v          # Top-Level Controller & Datapath
│   ├── PU_Module/         # Processing Element (PE) & Bit counters
│   │   ├── Strips_PE.v    # Core PE Logic
│   │   └── ...
│   ├── Memory_Module/     # Main System Memory
│   └── Reg_File_Module/   # Register Files for Vectors A & B
├── Project/               # ModelSim Simulation files
│   └── work/              # Compiled libraries
├── Reports/               # Final Documentation & Analysis
│   ├── report_1.pdf
│   └── report_2.pdf
└── README.md

```

## 🛠️ Tools & Verification

* **HDL Language:** Verilog (IEEE 1364)
* **Simulation Tool:** Mentor Graphics ModelSim
* **Verification Method:**
* The system reads data from `input_memory.txt`.
* Computes the matrix-vector multiplication.
* Writes results to memory, which are then compared against `output_memory.txt`.

## 👥 Contributors

This project was developed as a team effort for the **CAD** course at the **University of Tehran**.

* **[Sadra Salehi](https://github.com/im-w)**
* **[Meraj Rastegar](https://github.com/mragetsars)**
