// The 'land_battle_chess' program.

/*
Y
^
|
+------+--------+------+--------+------+
|      |   HQ   |      |   HQ   |      |
+------+--------+------+--------+------+
|      |        |      |        |      |
+------+--------+------+--------+------+
|      |  Camp  |      |  Camp  |      |
+------+--------+------+--------+------+
|      |        |      |        |      |
+------+--------+------+--------+------+
|      |  Camp  |      |  Camp  |      |
+------+--------+------+--------+------+
|      |        |      |        |      |
+------+--------+------+--------+------+
|      |        |      |        |      |
+------+--------+------+--------+------+
|      |  Camp  |      |  Camp  |      |
+------+--------+------+--------+------+
|      |        |      |        |      |
+------+--------+------+--------+------+
|      |  Camp  |      |  Camp  |      |
+------+--------+------+--------+------+
|      |        |      |        |      |
+------+--------+------+--------+------+
|      |   HQ   |      |   HQ   |      |
+------+--------+------+--------+------+---> X

position range:
    0 <= X < 5
    0 <= Y < 12

piece value:
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
    Opponent = 16,
*/

program land_battle_chess.aleo {
    //Each column of the board is represented by the "lineX" field.
    struct board_state {
        line0: u64, 
        line1: u64,
        line2: u64,
        line3: u64,
        line4: u64,
    }

    struct move {
        player: address,

        x: u64,
        y: u32,
        target_x: u64,
        target_y: u32,

        attack_result: u32 // 0: simple move, 1: win, 2: draw, 3: lose

        flag_x: u64,
        flag_y: u32,
        opp_flag_x: u64,
        opp_flag_y: u32,

        game_winner: u32,
    }

    record player_state {
        owner: address,
        gates: u64,

        board: board_state,
        flag_x: u64,
        flag_y: u32,

        game_winner: u32, // 0, 1 or 2
        arbiter: address,
        player_index: u32, // 1 or 2
    }

    record piece_info {
        owner: address,
        gates: u64,

        player: address,
        piece: u64,
        x: u64,
        y: u32,

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

/*
    Since many check functions generate large bytecode, to save on deployment costs,
they are temporarily commented out.

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
        let flag_num: u32 = 0u32;
        let bomb_num: u32 = 0u32;
        let landmine_num: u32 = 0u32;
        let engineer_num: u32 = 0u32;
        let lieutenant_num: u32 = 0u32;
        let captain_num: u32 = 0u32;
        let major_num: u32 = 0u32;
        let colonel_num: u32 = 0u32;
        let brigadier_num: u32 = 0u32;
        let major_general_num: u32 = 0u32;
        let general_num: u32 = 0u32;
        let field_marshal_num: u32 = 0u32;

        if is_player2 {
            for x: u64 in 0u64..5u64 {
                for y: u32 in 6u32..12u32 {
                    let piece: u64 = get_piece(board, x, y);
                    if piece == 1u64 {
                        flag_num += 1u32;
                    } else if piece == 2u64 {
                        bomb_num += 1u32;
                    } else if piece == 3u64 {
                        landmine_num += 1u32;
                    } else if piece == 4u64 {
                        engineer_num += 1u32;
                    } else if piece == 5u64 {
                        lieutenant_num += 1u32;
                    } else if piece == 6u64 {
                        captain_num += 1u32;
                    } else if piece == 7u64 {
                        major_num += 1u32;
                    } else if piece == 8u64 {
                        colonel_num += 1u32;
                    } else if piece == 9u64 {
                        brigadier_num += 1u32;
                    } else if piece == 10u64 {
                        major_general_num += 1u32;
                    } else if piece == 11u64 {
                        general_num += 1u32;
                    } else if piece == 12u64 {
                        field_marshal_num += 1u32;
                    }
                }
            }
        } else {
            for x: u64 in 0u64..5u64 {
                for y: u32 in 0u32..6u32 {
                    let piece: u64 = get_piece(board, x, y);
                    if piece == 1u64 {
                        flag_num += 1u32;
                    } else if piece == 2u64 {
                        bomb_num += 1u32;
                    } else if piece == 3u64 {
                        landmine_num += 1u32;
                    } else if piece == 4u64 {
                        engineer_num += 1u32;
                    } else if piece == 5u64 {
                        lieutenant_num += 1u32;
                    } else if piece == 6u64 {
                        captain_num += 1u32;
                    } else if piece == 7u64 {
                        major_num += 1u32;
                    } else if piece == 8u64 {
                        colonel_num += 1u32;
                    } else if piece == 9u64 {
                        brigadier_num += 1u32;
                    } else if piece == 10u64 {
                        major_general_num += 1u32;
                    } else if piece == 11u64 {
                        general_num += 1u32;
                    } else if piece == 12u64 {
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
*/

    transition player_initialize_board(line0: u64, line1: u64, line2: u64, line3: u64, line4: u64,
        flag_x: u64, flag_y: u32, public player_index: u32, public arbiter: address) -> (player_state, bool) {
        let board: board_state = board_state{line0:line0, line1:line1,line2:line2,line3:line3,line4:line4};
        let state:player_state = player_state{
            owner: self.caller,
            gates: 0u64,

            board: board,
            flag_x: flag_x,
            flag_y: flag_y,

            game_winner: 0u32,
            arbiter: arbiter,
            player_index: player_index,
        };

        let is_player2: bool = player_index == 2u32;
        if !check_range(board, is_player2) {
            return (state, false);
        }

/*
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
*/

        return (state, true);
    }

    transition move_piece(state: player_state, self_move: move, opp_move: move,
        public x: u64, public y: u32, public target_x: u64, public target_y: u32) -> (player_state, piece_info) {
        assert_eq(state.game_winner, 0u32);
        let board: board_state = board_state{line0:state.board.line0, line1:state.board.line1,line2:state.board.line2, line3:state.board.line3,line4:state.board.line4};
        let game_winner: u32 = 0u32;
        if self_move.x < 5u64 {
            let piece: u64 = get_piece(board, self_move.x, self_move.y);
            board = empty_board(board, self_move.x, self_move.y);
            if self_move.attack_result == 0u32 || self_move.attack_result == 1u32 {// win or simple move
                board = place_piece(board, self_move.target_x, self_move.target_y, piece);
            } else if self_move.attack_result == 2u32 { // draw
                board = empty_board(board, self_move.x, self_move.y);
            }
        }
        
        if opp_move.x < 5u64 {
            board = empty_board(board, opp_move.x, opp_move.y);
            if opp_move.attack_result == 0u32 || opp_move.attack_result == 1u32 {
                board = place_piece(board, opp_move.target_x, opp_move.target_y, 16u64);
            } else if opp_move.attack_result == 2u32 {
                board = empty_board(board, opp_move.target_x, opp_move.target_y);
            }
        }

        if self_move.game_winner != 0u32 {
            game_winner = self_move.game_winner;
        } else if opp_move.game_winner != 0u32 {
            game_winner = opp_move.game_winner;
        }

        if game_winner != 0u32 {
            return (player_state {
                owner: self.caller,
                gates: 0u64,
                board: board,
                game_winner: game_winner,
                flag_x: state.flag_x,
                flag_y: state.flag_y,
                arbiter: state.arbiter,
                player_index: state.player_index,
            }, piece_info { owner: state.arbiter, gates: 0u64, player:state.owner, piece:0u64, x:0u64, y:0u32, flag_x:0u64, flag_y:0u32});
        }

        let piece: u64 = get_piece(board, x, y);
        let flag_x: u64 = 5u64;
        let flag_y: u32 = 0u32;
        if piece == 12u64 {
            flag_x = state.flag_x;
            flag_y = state.flag_y;
        }

        return (player_state {
            owner: self.caller,
            gates: 0u64,
            board: board,
            flag_x: state.flag_x,
            flag_y: state.flag_y,
            arbiter: state.arbiter,
            game_winner: 0u32,
            player_index: state.player_index,
        }, piece_info { owner: state.arbiter, gates: 0u64, player:state.owner, piece:piece, x:x, y:y, flag_x:flag_x, flag_y:flag_y});
    }

    transition whisper_piece(state: player_state, x: u64, y: u32) -> piece_info {
        let piece: u64 = get_piece(state.board, x, y);
        let flag_x: u64 = 5u64;
        let flag_y: u32 = 0u32;
        if piece == 12u64 {
            flag_x = state.flag_x;
            flag_y = state.flag_y;
        }

        return piece_info { owner: state.arbiter, gates: 0u64, player:state.owner,piece:piece, x:x, y:y, flag_x:flag_x, flag_y:flag_y};
    }

    transition compare_piece(attacker: piece_info, target: piece_info) -> (move, move) {
        let attack_result: u32 = 0u32;
        let victim: u64 = 0u64;
        let opp_victim: u64 = 0u64;
        let flag_x: u64 = 5u64;
        let flag_y: u32 = 12u32;
        let opp_flag_x: u64 = 5u64;
        let opp_flag_y: u32 = 12u32;
        let game_winner: u32 = 0u32;

        if target.piece == 0u64 {
            attack_result = 0u32;
        } else if attacker.piece == 2u64 || target.piece == 2u64 { //bomb
            attack_result = 2u32;
            opp_victim = target.piece;
        } else if target.piece == 3u64 {//landmine
            if attacker.piece == 4u64 {//engineer
                attack_result = 1u32;
            } else {
                attack_result = 3u32;
            }
        } else if attacker.piece > target.piece {
            attack_result = 1u32;
        } else if attacker.piece == target.piece {
            attack_result = 2u32;
        } else {
            attack_result = 3u32;
        }

        if attack_result == 1u32 {
            opp_victim = target.piece;
        } else if attack_result == 2u32 {
            opp_victim = target.piece;
            victim = attacker.piece;
        } else if attack_result == 3u32 {
            victim = attacker.piece;
        }

        if victim == 12u64 {
            flag_x = attacker.flag_x;
            flag_y = attacker.flag_y;
        }

        if opp_victim == 12u64 {
            opp_flag_x = target.flag_x;
            opp_flag_y = target.flag_y;
        }

        // flag
        if victim == 1u64 {
            game_winner = 2u32;
        } else if opp_victim == 1u64 {
            game_winner = 1u32;
        }

        return (move {
            player: attacker.player,
            x: attacker.x,
            y: attacker.y,
            target_x: target.x,
            target_y: target.y,
            attack_result: attack_result,
            flag_x: flag_x,
            flag_y: flag_y,
            opp_flag_x: opp_flag_x,
            opp_flag_y: opp_flag_y,
            game_winner: game_winner,
        }, move {
            player: target.player,
            x: attacker.x,
            y: attacker.y,
            target_x: target.x,
            target_y: target.y,
            attack_result: attack_result,
            flag_x: flag_x,
            flag_y: flag_y,
            opp_flag_x: opp_flag_x,
            opp_flag_y: opp_flag_y,
            game_winner: game_winner,
        });
    }

    function empty_board(board: board_state, x: u64, y: u32) -> board_state {
        let line0: u64 = board.line0;
        let line1: u64 = board.line1;
        let line2: u64 = board.line2;
        let line3: u64 = board.line3;
        let line4: u64 = board.line4;

        let val: u64 = 31u64 << (y * 5u32);
        let mask: u64 = 18446744073709551615u64 - val;

        // empty square
        if x == 0u64 {
            line0 = mask & line0;
        } else if x == 1u64 {
            line1 = mask & line1;
        } else if x == 2u64 {
            line2 = mask & line2;
        } else if x == 3u64 {
            line3 = mask & line3;
        } else {
            line4 = mask & line4;
        }
        return board_state { line0: line0, line1: line1, line2:line2, line3:line3, line4: line4};
    }

    function place_piece(board: board_state, x: u64, y: u32, piece: u64) -> board_state {
        let line0: u64 = board.line0;
        let line1: u64 = board.line1;
        let line2: u64 = board.line2;
        let line3: u64 = board.line3;
        let line4: u64 = board.line4;

        let shift: u32 = y * 5u32;
        piece = piece << shift;

        if x == 0u64 {
            line0 = piece | line0;
        } else if x == 1u64 {
            line1 = piece | line1;
        } else if x == 2u64 {
            line2 = piece | line2;
        } else if x == 3u64 {
            line3 = piece | line3;
        } else {
            line4 = piece | line4;
        }

        return board_state { line0: line0, line1: line1, line2:line2, line3:line3, line4: line4};
    }

}
