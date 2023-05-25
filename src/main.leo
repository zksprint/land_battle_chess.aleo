// The 'land_battle_chess' program.
program land_battle_chess.aleo {
    /* Piece
        Empty = 0,
        Flag = 1,
        Bomb = 2,
        Landmine = 3,
        Engineer = 4,
        Lieutenant = 5,
        Captain = 6,
        Major = 7,
        Colonel = 8,
        Brigadier = 9,
        MajorGeneral = 10,
        General = 11,
        FieldMarshal = 12,
        Invalid = 13,
        Opponent = 16,
     */
    struct board_state {
        line0: u64,
        line1: u64,
        line2: u64,
        line3: u64,
        line4: u64,
    }

    record player_state {
        owner: address,
        gates: u64,

        board: board_state,
        flag_x: u64,
        flag_y: u32,
    }

    inline get_piece(board: board_state, x: u64, y: u32) -> u64 {
        let line: u64 = get_line(board, x);
        return get_piece_from_line(line, y);
    }


    inline get_line(board: board_state, x: u64) -> u64 {
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

    inline get_piece_from_line(x: u64, y: u32) -> u64 {
        let mask: u64 = 31u64;
        let row: u32 = y * 5u32;
        let val: u64 = mask << row;
        return (val & x) >> row;
    }

    inline check_range(board: board_state, is_player2: bool) -> bool {
        let val: u64 = 1u64 << 30u32; 
        let mask: u64 = val - 1u64;
        if !is_player2 {
            mask = mask << 30u32;
        }

        let line0: u64 = board.line0 & mask;
        let line1: u64 = board.line1 & mask;
        let line2: u64 = board.line2 & mask;
        let line3: u64 = board.line3 & mask;
        let line4: u64 = board.line4 & mask;

        if line0 == 0u64 || line1 == 0u64 || line2 == 0u64 || line3 == 0u64 || line4 == 0u64 {
            return false;
        }

        return true;
    }

    inline check_flag(board: board_state, is_player2: bool) -> bool {
        let flag: u64 = 1u64;
        let base0: u64 = get_piece(board, 0u64, 11u32);
        let base1: u64 = get_piece(board, 3u64, 11u32);

        if is_player2 {
            base0 = get_piece(board, 0u64, 11u32);
            base1 = get_piece(board, 3u64, 11u32);
        }

        if base0 != flag && base1 != flag {
            return false;
        }
        return true;
    }

/*
    inline check_camp(board: board_state, is_player2: bool) -> bool {
        let camp0: u64 = get_piece(board, 1u64, 7u32);
        let camp1: u64 = get_piece(board, 1u64, 9u32);
        let camp2: u64 = get_piece(board, 3u64, 7u32);
        let camp3: u64 = get_piece(board, 3u64, 9u32);

        if is_player2 {
            camp0 = get_piece(board, 1u64, 2u32);
            camp1 = get_piece(board, 1u64, 4u32);
            camp2 = get_piece(board, 3u64, 2u32);
            camp3 = get_piece(board, 3u64, 4u32);
        }

        if camp0 != 0u64 || camp1 != 0u64 || camp2 != 0u64 || camp3 != 0u64 {
            return false;
        }
        return true;
    }

    inline check_landmine(board: board_state, is_player2: bool) -> bool {
        let landmine: u64 = 3u64;
        let landmine_cnt: u64 = 0u64;

        let local0: u64 = get_piece(board, 0u64, 0u32);
        let local1: u64 = get_piece(board, 1u64, 0u32);
        let local2: u64 = get_piece(board, 2u64, 0u32);
        let local3: u64 = get_piece(board, 3u64, 0u32);
        let local4: u64 = get_piece(board, 4u64, 0u32);
        let local5: u64 = get_piece(board, 0u64, 1u32);
        let local6: u64 = get_piece(board, 1u64, 1u32);
        let local7: u64 = get_piece(board, 2u64, 1u32);
        let local8: u64 = get_piece(board, 3u64, 1u32);
        let local9: u64 = get_piece(board, 4u64, 1u32);

        if is_player2 {
            local0 = get_piece(board, 0u64, 10u32);
            local1 = get_piece(board, 1u64, 10u32);
            local2 = get_piece(board, 2u64, 10u32);
            local3 = get_piece(board, 3u64, 10u32);
            local4 = get_piece(board, 4u64, 10u32);
            local5 = get_piece(board, 0u64, 11u32);
            local6 = get_piece(board, 1u64, 11u32);
            local7 = get_piece(board, 2u64, 11u32);
            local8 = get_piece(board, 3u64, 11u32);
            local9 = get_piece(board, 4u64, 11u32);
        }

        if local0 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }

        if local1 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }

        if local2 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }
        if local3 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }
        if local4 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }
        if local5 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }
        if local6 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }
        if local7 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }
        if local8 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }
        if local9 == landmine {
            landmine_cnt = landmine_cnt + 1u64;
        }

        if landmine_cnt != 3u64 {
            return false;
        }

        return true;
    }

    inline check_bomb(board: board_state, is_player2: bool) -> bool {
        let bomb: u64 = 2u64;
        let local0: u64 = get_piece(board, 0u64, 5u32);
        let local1: u64 = get_piece(board, 1u64, 5u32);
        let local2: u64 = get_piece(board, 2u64, 5u32);
        let local3: u64 = get_piece(board, 3u64, 5u32);
        let local4: u64 = get_piece(board, 4u64, 5u32);

        if is_player2 {
            local0 = get_piece(board, 0u64, 6u32);
            local1 = get_piece(board, 1u64, 6u32);
            local2 = get_piece(board, 2u64, 6u32);
            local3 = get_piece(board, 3u64, 6u32);
            local4 = get_piece(board, 4u64, 6u32);
        }

        if local0 == bomb || local1 == bomb || local2 == bomb || local3 == bomb || local4 == bomb {
            return false;
        }
        return true;
    }

    inline check_initial_placement(board: board_state, is_player2: bool) -> bool {
        if !check_range(board, is_player2) {
            return false;
        }

        if !check_bomb(board, is_player2) {
            return false;
        }

        if !check_landmine(board, is_player2) {
            return false;
        }

        if !check_camp(board, is_player2) {
            return false;
        }

        if !check_flag(board, is_player2) {
            return false;
        }

        return true;
    }
    */

    transition player_setup(board: board_state, flag_x: u64, flag_y: u32) -> player_state {
        return player_state {
            owner: self.caller,
            gates: 0u64,

            board: board,
            flag_x: flag_x,
            flag_y: flag_y,
        };
    }
}
