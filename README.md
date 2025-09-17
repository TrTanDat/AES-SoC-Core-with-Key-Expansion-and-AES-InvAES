# AES-SoC-Core-with-Key-Expansion-and-AES-InvAES
##Description:
This repository contains a hardware implementation of an AES-128 encryption/decryption core with integrated key expansion, fully pipelined stages (AddRoundKey, SubBytes/InvSubBytes, ShiftRows/InvShiftRows, MixColumns/InvMixColumns), designed for integration with a CPU via CSR interface. Supports both encryption and decryption, block-by-block processing, and configurable control/status registers for CPU-software interaction. Includes testbench examples and full modular design for FPGA/ASIC deployment.

##Key Features:

AES-128 encryption and decryption with pipelined architecture

Separate InvCipher module for decryption

Fully combinational stages except for SubBytes to optimize throughput

CSR interface for CPU-driven control and status monitoring

Ready for FPGA or SoC integration
