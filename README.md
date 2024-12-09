Project Overview
This project involves designing and implementing a simple part of a microprocessor in Verilog. The project is divided into two main parts: creating an Arithmetic Logic Unit (ALU) and a register file, and then integrating them to execute a simple machine code program. The design parameters and initial values are derived from your student ID, ensuring a unique design for each student.

Part 1: ALU Design
The ALU (Arithmetic Logic Unit) is responsible for performing various arithmetic and logical operations based on a 6-bit opcode. The operations and their corresponding opcodes are determined by the last digit of your student ID. The ALU has two 32-bit inputs, A and B, and a 32-bit output Result.

Part 2: Register File Design
The register file is a small, fast memory used to hold operands for the ALU. It has 32 locations, each storing a 32-bit word. The contents of the register file are initialized based on the second-to-last digit of your student ID. The register file can handle three addresses simultaneously: two read addresses and one write address.

Part 3: Integrating ALU and Register File
The ALU and register file are integrated to form the core of a simple microprocessor. Machine instructions are supplied in the form of 32-bit numbers, specifying the operation, source registers, and destination register. The register file is synchronized to a clock to ensure correct operation.
