// The 'land_battle_chess' program.
program land_battle_chess.aleo {
    struct board {
        line0: u64,
        line1: u64,
        line2: u64,
        line3: u64,
        line4: u64,
    }

    record player_state {
        owner: address,
        gates: u64,

        board: board,
        flag_x: u64,
        flag_y: u64,
    }

    function get_piece(board: board, x: u64, y: u64) -> u64 {
        let line: u64 = get_line(board, x);
        return get_piece_from_line(line, y);
    }


    function get_line(board: board, x: u64) -> u64 {
        if x == 0u64 {
            return board.line0;
        } else if x == 1u64 {
            return board.line1;
        } else if x == 2u64 {
            return board.line2;
        } else if x == 3u64 {
            return board.line3;
        } else {
            return board.line4;
        }
    }

    function get_piece_from_line(x: u64, y: u64) -> u64 {
        let mask: u64 = 0x1Fu64;
        let row = y * 5u64;
        return ((mask << row) & x) >> row;
    }

    transition player_setup(board: board, flag_x: u64, flag_y: u64) -> player_state {
        return player_state {
            owner: self.caller,
            gates: 0u64,

            board: board,
            flag_x: flag_x,
            flag_y: flag_y,
        }
    }
}
