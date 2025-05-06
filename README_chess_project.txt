Chess FPGA Project - Detailed Implementation Guide
=================================================

This document provides an in-depth explanation of the chess FPGA project, describing how each major module and part of the code works, the flow of data, and the internal logic. PMOD8LE is excluded from this description.

1. Top-Level Integration (`chess_top.v`)
----------------------------------------
- This is the main module that instantiates and connects all other modules.
- It wires up the button inputs, board state, game logic, display interface, and OLED controller.
- It manages the flow of data between modules:
  - Button signals are routed to `game_logic`.
  - Board state is updated and shared between `game_logic`, `display_interface`, and `oledControl`.
  - Outputs from `game_logic` (such as cursor, selection, suggestion) are sent to the display modules.

2. Game Logic (`game_logic.v`)
------------------------------
- Implements the chess rules, state machine, move validation, and move suggestion.
- **Board Representation:**
  - The board is a 64-element array, each 4 bits wide, representing the piece and color on each square.
  - The board is updated on valid moves and after captures.
- **State Machine:**
  - `INITIAL`: Resets the game, sets up initial state.
  - `PIECE_SEL`: Waits for the user to select a piece. Only allows selection of the current player's pieces.
  - `SUGGEST_MOVE`: Triggers the Monte Carlo move suggestion logic for the selected piece.
  - `PIECE_MOVE`: Waits for the user to select a destination square. Validates the move using piece-specific rules.
  - `WRITE_NEW_PIECE`: Writes the selected piece to the new square.
  - `ERASE_OLD_PIECE`: Clears the old square after a move.
  - `CHECK_GAME_END`: (Stubbed) Would check for checkmate, stalemate, or draw.
- **Move Validation:**
  - Each piece type (pawn, knight, bishop, rook, queen, king) has its own movement rules, checked in combinational logic.
  - Only legal moves are allowed; illegal moves return to selection state.
- **Score Tracking:**
  - Captured pieces increment the score for the capturing player.
- **Monte Carlo Move Suggestion:**
  - When a piece is selected, the FSM enters `SUGGEST_MOVE`.
  - The Monte Carlo logic simulates random moves for the selected piece, evaluates the resulting board positions, and suggests the move with the best score.
  - The suggestion is output as `suggested_move_addr` and flagged with `show_suggestion`.
- **Outputs:**
  - `board_out_addr`, `board_out_piece`, `board_change_en_wire`: Used to update the board state in the top module.
  - `cursor_addr`, `selected_addr`: Track the cursor and selected piece.
  - `move_is_legal`: Indicates if the current move is valid.
  - `suggested_move_addr`, `show_suggestion`: For move highlighting and OLED display.
  - `white_score`, `black_score`: Player scores.

3. Display Interface (`display_interface.v`)
-------------------------------------------
- Handles VGA output for the chessboard.
- Receives the board state, cursor, selected piece, and suggested move from `game_logic`.
- Draws the chessboard, pieces, and highlights:
  - The selected piece is highlighted in one color.
  - The suggested move (if `show_suggestion` is active) is highlighted in another color.
- Uses counters and state machines to generate VGA timing and pixel data.

4. OLED Display Controller (`oledControl.v`)
--------------------------------------------
- Manages the OLED display via SPI.
- **Initialization:**
  - Runs a sequence of commands to initialize the OLED (power, addressing mode, contrast, etc.).
- **Display Buffer:**
  - An 8x8 buffer holds the data to be displayed (text or game state info).
  - The buffer is updated in a single always block to avoid multi-driven net errors.
- **Text Display:**
  - Uses a state machine to display text based on the game state (e.g., "CHESS", "W: 3", "B: 2", "WINS", "DRAW").
  - The text is converted to bitmaps using the `charROM` module.
- **Game State Display:**
  - The buffer can also show raw game state, scores, selected piece, and suggested move.
- **SPI Communication:**
  - Uses the `spiControl` module to send data/commands to the OLED.
  - Uses the `delayGen` module for timing control.

5. Character ROM (`charROM.v`)
------------------------------
- Stores 8x8 bitmap data for ASCII characters (A-Z, 0-9, symbols).
- When a character is to be displayed, its ASCII code is used as the address to fetch the bitmap.
- The bitmap is sent to the OLED display buffer for rendering.

6. Supporting Modules
---------------------
- **`spiControl.v`:** Handles SPI protocol for sending data to the OLED.
- **`delayGen.v`:** Generates programmable delays for OLED initialization and timing.

7. Data Flow Summary
--------------------
- User presses a button → `game_logic` updates state and board → outputs sent to `display_interface` and `oledControl`.
- `display_interface` draws the board and highlights on VGA.
- `oledControl` shows game state and text on the OLED using `charROM`.
- All modules are synchronized via the top-level module and share signals for game state, scores, and suggestions.

8. Key Signals and Interactions
-------------------------------
- **Button Inputs:** Routed to `game_logic` for user interaction.
- **Board State:** Shared between `game_logic`, `display_interface`, and `oledControl`.
- **Move Suggestion:** Generated in `game_logic`, shown on both VGA and OLED.
- **Display Buffer:** Only updated in one always block in `oledControl` to avoid hardware conflicts.

For further details, see the comments in each module's source file. This guide should help you understand the structure, flow, and operation of the chess FPGA project in depth. 