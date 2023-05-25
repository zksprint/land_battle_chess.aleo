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

    function check_range(board: board_state, is_player2: bool) -> bool {
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

    function check_flag(board: board_state, is_player2: bool) -> bool {
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

    function check_camp(board: board_state, is_player2: bool) -> bool {
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

    function check_landmine(board: board_state, is_player2: bool) -> bool {
        let landmine: u64 = 3u64;
        let cnt: u32 = 0u32;

        if is_player2 {
            for i: u64 in 0u64..5u64 {
                let piece: u64 = get_piece(board, i, 10u32);
                if piece == landmine {
                    cnt += 1u32;
                }
            }
            for i: u64 in 0u64..5u64 {
                let piece: u64 = get_piece(board, i, 11u32);
                if piece == landmine {
                    cnt += 1u32;
                }
            }
        } else {
            for i: u64 in 0u64..5u64 {
                let piece: u64 = get_piece(board, i, 0u32);
                if piece == landmine {
                    cnt += 1u32;
                }
            }
            for i: u64 in 0u64..5u64 {
                let piece: u64 = get_piece(board, i, 1u32);
                if piece == landmine {
                    cnt += 1u32;
                }
            }

        }

        if cnt != 3u32 {
            return false;
        }
        return true;
    }

    function check_bomb(board: board_state, is_player2: bool) -> bool {
        let bomb: u64 = 2u64;
        if is_player2 {
            for i: u64 in 0u64..5u64 {
                let piece: u64 = get_piece(board, 0u64, 6u32);
                if piece == bomb {
                    return false;
                }
            }
        } else {
            for i: u64 in 0u64..5u64 {
                let piece: u64 = get_piece(board, 0u64, 5u32);
                if piece == bomb {
                    return false;
                }
            }
        }
        return true;
    }

    function check_piece_num(board: board_state, is_player2: bool) -> bool {
        /*
        Flag = 1, n: 1
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
        */
        let flag_num = 0u32;
        let bomb_num = 0u32;
        let landmine_num = 0u32;
        let engineer_num = 0u32;
        let lieutenant_num = 0u32;
        let captain_num = 0u32;
        let major_num = 0u32;
        let colonel_num = 0u32;
        let brigadier_num = 0u32;
        let major_general_num = 0u32;
        let general_num = 0u32;
        let field_marshal_num = 0u32;

        if is_player2 {
            for x: u64 in 0u64..5u64 {
                for y: u64: in 6u32..12u32 {
                    let piece: u64 = get_piece(board, x, y);
                    if piece == 1u32 {
                        flag_num += 1u32;
                    } else if piece == 2u32 {
                        bomb_num += 1u32;
                    } else if piece == 3u32 {
                        landmine_num += 1u32;
                    } else if piece == 4u32 {
                        engineer_num += 1u32;
                    } else if piece == 5u32 {
                        lieutenant_num += 1u32;
                    } else if piece == 6u32 {
                        captain_num += 1u32;
                    } else if piece == 7u32 {
                        major_num += 1u32;
                    } else if piece == 8u32 {
                        colonel_num += 1u32;
                    } else if piece == 9u32 {
                        brigadier_num += 1u32;
                    } else if piece == 10u32 {
                        major_general_num += 1u32;
                    } else if piece == 11u32 {
                        general_num += 1u32;
                    } else if piece == 12u32 {
                        field_marshal_num += 1u32;
                    }
                }
            }
        } else {
            for x: u64 in 0u64..5u64 {
                for y: u64: in 0u32..6u32 {
                    let piece: u64 = get_piece(board, x, y);
                    if piece == 1u32 {
                        flag_num += 1u32;
                    } else if piece == 2u32 {
                        bomb_num += 1u32;
                    } else if piece == 3u32 {
                        landmine_num += 1u32;
                    } else if piece == 4u32 {
                        engineer_num += 1u32;
                    } else if piece == 5u32 {
                        lieutenant_num += 1u32;
                    } else if piece == 6u32 {
                        captain_num += 1u32;
                    } else if piece == 7u32 {
                        major_num += 1u32;
                    } else if piece == 8u32 {
                        colonel_num += 1u32;
                    } else if piece == 9u32 {
                        brigadier_num += 1u32;
                    } else if piece == 10u32 {
                        major_general_num += 1u32;
                    } else if piece == 11u32 {
                        general_num += 1u32;
                    } else if piece == 12u32 {
                        field_marshal_num += 1u32;
                    }
                }
            }
        }
        if flag_num != 1u32 {
            return false;
        } else if bomb_num != 3u32 {
            return false;
        } else if landmine_num != 3u32 {
            return false;
        } else if engineer_num != 3u32 {
            return false;
        } else if lieutenant_num != 2u32 {
            return false;
        } else if captain_num != 2u32 {
            return false;
        } else if major_num != 2u32 {
            return false;
        } else if colonel_num != 2u32 {
            return false;
        } else if brigadier_num != 2u32 {
            return false;
        } else if major_general_num != 2u32 {
            return false;
        } else if general_num != 1u32 {
            return false;
        } else if field_marshal_num != 1u32 {
            return false;
        }
        return true;
    }

    transition player_setup(board: board_state, flag_x: u64, flag_y: u32, is_player2: bool) -> (player_state, bool) {
        let state:player_state = player_state{
            owner: self.caller,
            gates: 0u64,

            board: board,
            flag_x: flag_x,
            flag_y: flag_y,
        };

        if !check_range(board, is_player2) {
            return (state, false);
        }

        if !check_bomb(board, is_player2) {
            return (state, false);
        }

        if !check_landmine(board, is_player2) {
            return (state, false);
        }

        if !check_camp(board, is_player2) {
            return (state, false);
        }

        if !check_flag(board, is_player2) {
            return (state, false);
        }

        if !check_piece_num(board, is_player2) {
            return (state, false);
        }

        return (state, true);
    }
}
