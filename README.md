# 🚀 PIC16F84A Guessing Game – Finite State Machine Implementation (ECSE 281)

This repository contains an assembly-language implementation of a **Guessing Game state machine** for the **PIC16F84A** microcontroller.  
Developed using **MPLAB X**, the system cycles through a rotating LED pattern on PORTB while reading user guess inputs (G1–G4) from PORTA. The program transitions into **WIN** or **ERR** states based on user inputs and returns to the main sequence after displaying the appropriate output.

This project was created for **ECSE 281 – Logic Design and Computer Organization**, demonstrating low-level hardware programming and microcontroller-based state machine design.

---

## 🔧 Features

### ✔ One-Hot Encoded FSM  
Implements states S1 → S2 → S3 → S4, plus:  
- **WIN** (correct guess)  
- **ERR** (incorrect guess)

Each state maps directly to output bits on **PORTB (RB0–RB5)**.

### ✔ Input-Driven State Transitions  
- Inputs **G1–G4** (RA0–RA3) determine whether the user guessed correctly.  
- Correct guess → transition to **WIN**  
- Incorrect input → transition to **ERR**

### ✔ Accurate 1-Second Timing  
Uses a calibrated 32×256 nested loop delay to achieve a ~1.0 second state delay at a 100 kHz system clock.

### ✔ MPLAB X Simulation Support  
Compatible with the course-provided stimulus workbook (`guessing_game_stimuli_Fall2025.sbs`).  
Breakpoints are used after each state change to verify outputs.

### ✔ Clean Assembly Structure  
Uses macros for readability:
- `IFCLR` – conditional branch on cleared bit  
- `MOVLF` – load literal into file register  
- `MOVFF` – file register copy

---

## 🛠 Technologies & Tools Used
- **PIC16F84A Microcontroller**
- **MPLAB X IDE**
- **MPASM (Microchip Assembly)**
- **Watch Window & Stimulus Workbook Testing**
- **Hardware-level timing & GPIO control**

---

## 🧠 What This Project Demonstrates
This project highlights capabilities in:

- Embedded assembly programming  
- Finite state machine implementation  
- Register and memory-mapped I/O manipulation  
- Hardware debugging and simulation  
- Timing control without interrupts  
- Microcontroller-based digital system design  

---

## 🚦 State Definitions

| State | Output (PORTB) | Description |
|-------|----------------|-------------|
| S1 | `00000001` | First LED (L1) |
| S2 | `00000010` | Second LED (L2) |
| S3 | `00000100` | Third LED (L3) |
| S4 | `00001000` | Fourth LED (L4) |
| ERR | `00010000` | Incorrect guess indicator |
| WIN | `00100000` | Correct guess indicator |

---

## ▶️ Running the Program

1. Open **MPLAB X**  
2. Load the `guessing_game.asm` file  
3. Set processor: **PIC16F84A**  
4. Load stimulus file:  
   **Stimulus → Open Workbook → Apply before Debugging**  
5. Add breakpoints after each state transition  
6. Start simulation and verify outputs in the **Watch Window**

---

## 📜 License
This project is for academic demonstration and educational use.
