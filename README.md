# ALSU
ALSU Design and Verification
Overview
This project implements an Arithmetic Logic and Shift Unit (ALSU) using SystemVerilog and verifies it through a Universal Verification Methodology (UVM) testbench. The ALSU performs a set of arithmetic, logical, and shift operations on two input operands, with configurable control signals determining the operation type. The design supports constrained random stimulus generation and functional coverage to ensure thorough verification.

Design Features
Arithmetic Operations: Addition, subtraction, increment, decrement, etc.

Logical Operations: AND, OR, XOR, NOR, NAND, etc.

Shift Operations: Logical left, logical right, arithmetic right.

Operand Width: Parameterized (default: 8/16/32 bits depending on configuration).

Result Flags:

Zero flag (ZF)

Negative flag (NF)

Carry flag (CF)

Overflow flag (OF)

Parameterizable Data Width for flexibility in different applications.

Verification Methodology
Testbench Architecture: Built entirely in UVM with reusable components.

Stimulus Generation:

Constrained random generation for operands and operation type.

Directed tests for corner cases (overflow, zero, sign change, etc.).

Scoreboard:

Compares DUT output against a reference model to detect mismatches.

Assertions:

Ensures protocol compliance and detects illegal operations.

Functional Coverage:

Operation type coverage.

Operand value distribution.

Flag behavior coverage.

Verification Environment Components
UVM Sequencer: Generates transactions with random or directed inputs.

UVM Driver: Converts transactions into DUT interface signals.

UVM Monitor: Captures DUT inputs/outputs for checking and coverage.

Scoreboard: Implements result checking against the golden model.

Coverage Collector: Covergroups to ensure 100% functional coverage.

Simulation & Coverage
Simulation Tool: Tested on Mentor QuestaSim / Synopsys VCS.

Achieved:

100% Functional Coverage

100% Code Coverage

Verified under multiple random seeds to ensure robustness.
