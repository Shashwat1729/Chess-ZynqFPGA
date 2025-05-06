# FPGA Chess Game with Monte Carlo Evaluation

This project implements a chess game on an FPGA board with Monte Carlo evaluation for computer moves. The game features a VGA display for the chess board and an OLED display for game state information.

## Features
- Chess game with Monte Carlo evaluation for AI moves.
- VGA display for the chessboard.
- OLED display for game state information.
- User interaction via buttons.

## Hardware Requirements
- ZedBoard FPGA development board
- VGA monitor
- OLED display (connected to PMOD JB)
- USB keyboard (optional)

## Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/Shashwat1729/Chess-ZynqFPGA.git
   cd Chess-ZynqFPGA
   ```
2. Open the project in Vivado.

3. Generate the bitstream and program the FPGA.

## Game Controls
- **BtnU (Up)**: Move cursor up
- **BtnD (Down)**: Move cursor down
- **BtnL (Left)**: Move cursor left
- **BtnR (Right)**: Move cursor right
- **BtnC (Center)**: Select piece/make move

## Contribution
Contributions are welcome! Please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.