# MSP430FR2355 Assembly Blink

A lightweight, low-level assembly language program for the Texas Instruments MSP430FR2355 microcontroller. This project configures the microcontroller from scratch and utilizes a software delay loop to toggle the onboard LED1 (P1.0) approximately every 0.1 seconds.

## Hardware Setup

* **Microcontroller:** MSP430FR2355 (FRAM LaunchPad)
* **Clock Configuration:** MCLK = SMCLK = default DCODIV ~1MHz
* **Target Peripheral:** Port 1, Pin 0 (P1.0) connected to onboard LED1
* **Jumper Configuration:** Ensure the `P1.0` jumper on the LaunchPad isolation block is securely shorted/connected.

## Project Structure

* `Asm_Blink/msp430fr235x_1.asm` - The main assembly source code.
* `Asm_Blink/lnk_msp430fr2355.cmd` - Linker command file defining the hardware memory layout.
* `Asm_Blink/targetConfigs/MSP430FR2355.ccxml` - Target configuration file for the JTAG debugger.
* `.theia/` & `Asm_Blink/.project` - Core IDE configuration settings for Code Composer Studio / Theia.

## How It Works

1. **Watchdog Disable:** The Watchdog Timer (WDT) is stopped immediately at the `RESET` vector to prevent unexpected system resets.
2. **FRAM GPIO Unlock:** The `LOCKLPM5` bit in the `PM5CTL0` register is cleared to disable the high-impedance mode on the I/O pins, allowing digital state transitions.
3. **GPIO Configuration:** Pin 1.0 is designated as an output pin (`P1DIR`).
4. **Blink Loop:** An `XOR` operation toggles the `P1OUT` state of pin 1.0, followed by a software register decrement countdown loop (`0xFFFF` to `0`) using CPU register `R4`.

> ⚠️ **Debugger Note:** A `nop` (No Operation) instruction is placed inside the execution pipeline right before the main branch loop. This ensures that modern JTAG debuggers maintain synchronization with the fast-cycling CPU and prevents the IDE from visually freezing on the `xor.b` line during active emulation.

## Requirements

* Code Composer Studio (CCS) or CCS Theia IDE
* TI-CGT (Texas Instruments Compiler Generation Tools) for MSP430
