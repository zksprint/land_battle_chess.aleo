# The private key and address of player1
# "private_key": APrivateKey1zkp3CsZ1dtoqFst5JNdXRwc7BBykJa9CgH4EieH89DJuE11
# "address": aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0

# The private key and address of player2
# "private_key": APrivateKey1zkpHVRBhRaMBGBN4Zo2HckRc2RreHw26Kfnr9JRPTvhJXvH
# "address": aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q

# The private key and address of the arbiter.
# "private_key": APrivateKey1zkp8uaGbHM6eVjC5FVvhHyDtKXGBAGP9MCdbWLVX6H191RH
# "address": aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj

PLAYER1_PROGRAM="{
  \"program\": \"land_battle_chess.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkp3CsZ1dtoqFst5JNdXRwc7BBykJa9CgH4EieH89DJuE11\",
      \"address\": \"aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0\"
  },
  \"license\": \"MIT\"
}"

PLAYER2_PROGRAM="{
  \"program\": \"land_battle_chess.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpHVRBhRaMBGBN4Zo2HckRc2RreHw26Kfnr9JRPTvhJXvH\",
      \"address\": \"aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q\"
  },
  \"license\": \"MIT\"
}"

ARBITER_PROGRAM="{
  \"program\": \"land_battle_chess.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkp8uaGbHM6eVjC5FVvhHyDtKXGBAGP9MCdbWLVX6H191RH\",
      \"address\": \"aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj\"
  },
  \"license\": \"MIT\"
}"

DUMMY_MOVE="{
    game_id: 0u64,
    player: aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q,
    x: 5u64, y: 0u32, target_x: 5u64, target_y: 0u32, attack_result: 0u32,
    flag_x: 5u64, flag_y: 0u32, opp_flag_x: 5u64, opp_flag_y: 0u32, game_winner: 0u32
}"


echo "
###############################################################################
########                                                               ########
########          STEP 1: Player1 Initializes the board                ########
########                                                               ########
########           +------+------+------+------+------+                ########
########           | 司令 | 军棋 | 地雷 | 炸弹 | 工兵 |                ########
########           +------+------+------+------+------+                ########
########           | 军长 | 地雷 | 地雷 | 旅长 | 旅长 |                ########
########           +------+------+------+------+------+                ########
########           | 团长 |      | 团长 |      | 营长 |                ########
########           +------+------+------+------+------+                ########
########           | 营长 | 连长 | 连长 | 连长 | 师长 |                ########
########           +------+------+------+------+------+                ########
########           | 师长 |      | 连长 |      | 排长 |                ########
########           +------+------+------+------+------+                ########
########           | 炸弹 | 排长 | 工兵 | 工兵 | 工兵 |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########                                                               ########
###############################################################################
"
echo "$PLAYER1_PROGRAM" > program.json

LINE0=243944968059068u64
LINE1=243944970543153u64
LINE2=243944969889843u64
LINE3=243944969494674u64
LINE4=243944969840532u64
leo run player_initialize_board $LINE0 $LINE1 $LINE2 $LINE3 $LINE4\
    1u64 0u32 0u64 1u32 aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj

# output:
STATE1="{
  owner: aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  board: {
    line0: 243944968059068u64.private,
    line1: 243944970543153u64.private,
    line2: 243944969889843u64.private,
    line3: 243944969494674u64.private,
    line4: 243944969840532u64.private
  },
  flag_x: 1u64.private,
  flag_y: 0u32.private,
  game_winner: 0u32.private,
  arbiter: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  player_index: 1u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"

echo "
###############################################################################
########                                                               ########
########          STEP 2: Player2 Initializes the board                ########
########                                                               ########
########           +------+------+------+------+------+                ########
########           | l0   | l1   | l2   | l3   | l4   |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | XXX  | XXX  | XXX  | XXX  | XXX  |                ########
########           +------+------+------+------+------+                ########
########           | 营长 | 连长 | 连长 | 连长 | 师长 |                ########
########           +------+------+------+------+------+                ########
########           | 师长 |      | 连长 |      | 排长 |                ########
########           +------+------+------+------+------+                ########
########           | 炸弹 | 排长 | 工兵 | 工兵 | 工兵 |                ########
########           +------+------+------+------+------+                ########
########           | 团长 |      | 团长 |      | 营长 |                ########
########           +------+------+------+------+------+                ########
########           | 军长 | 地雷 | 地雷 | 旅长 | 旅长 |                ########
########           +------+------+------+------+------+                ########
########           | 司令 | 地雷 | 炸弹 | 军棋 | 工兵 |                ########
########           +------+------+------+------+------+                ########
########                                                               ########
###############################################################################
"
echo "$PLAYER2_PROGRAM" > program.json

LINE0=223762022522333u64
LINE1=56096683056605u64
LINE2=39051568471517u64
LINE3=27505085767133u64
LINE4=80764089523677u64
leo run player_initialize_board $LINE0 $LINE1 $LINE2 $LINE3 $LINE4\
    1u64 11u32 0u64 2u32 aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj

# output:
STATE2="{
  owner: aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  board: {
    line0: 223762022522333u64.private,
    line1: 56096683056605u64.private,
    line2: 39051568471517u64.private,
    line3: 27505085767133u64.private,
    line4: 80764089523677u64.private
  },
  flag_x: 1u64.private,
  flag_y: 11u32.private,
  game_winner: 0u32.private,
  arbiter: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  player_index: 2u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"


echo "
###############################################################################
########                                                               ########
########              STEP 3: Player1 Moves a Piece                    ########
########                                                               ########
###############################################################################
"
echo "$PLAYER1_PROGRAM" > program.json

leo run move_piece "$STATE1" "$DUMMY_MOVE" 0u64 5u32 0u64 6u32

# output:
STATE1="{                                                                                                                                                        
  owner: aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0.private,
  gates: 0u64.private,
  game_id: 0u64.private,                                                                                                                                    
  board: {                           
    line0: 243944968059068u64.private,
    line1: 243944970543153u64.private,
    line2: 243944969889843u64.private,
    line3: 243944969494674u64.private,
    line4: 243944969840532u64.private
  },
  flag_x: 1u64.private,
  flag_y: 0u32.private,
  game_winner: 0u32.private,
  arbiter: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  player_index: 1u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"
PIECE1="{
  owner: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  player: aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0.private,
  piece: 2u64.private,
  x: 0u64.private,
  y: 5u32.private,
  flag_x: 5u64.private,
  flag_y: 0u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"

echo "
###############################################################################
########                                                               ########
########         STEP 4: Player2 Whispers the Target Piece             ########
########                                                               ########
###############################################################################
"
echo "$PLAYER2_PROGRAM" > program.json

leo run whisper_piece "$STATE2" "$DUMMY_MOVE" 0u64 6u32

# output:
STATE2="{
  owner: aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  board: {
    line0: 223762022522333u64.private,
    line1: 56096683056605u64.private,
    line2: 39051568471517u64.private,
    line3: 27505085767133u64.private,
    line4: 80764089523677u64.private
  },
  flag_x: 1u64.private,
  flag_y: 11u32.private,
  game_winner: 0u32.private,
  arbiter: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  player_index: 2u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"
PIECE2="{
  owner: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  player: aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q.private,
  piece: 7u64.private,
  x: 0u64.private,
  y: 6u32.private,
  flag_x: 5u64.private,
  flag_y: 0u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"

echo "
###############################################################################
########                                                               ########
########           STEP 5: Aribter Compares pieces                     ########
########                                                               ########
###############################################################################
"
echo "$ARBITER_PROGRAM" > program.json

leo run compare_pieces "$PIECE1" "$PIECE2"
# output:
PLAYER1_MOVE=" {
  game_id: 0u64,
  player: aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0,
  x: 0u64,
  y: 5u32,
  target_x: 0u64,
  target_y: 6u32,
  attack_result: 2u32,
  flag_x: 5u64,
  flag_y: 0u32,
  opp_flag_x: 5u64,
  opp_flag_y: 0u32,
  game_winner: 0u32
}"


echo "
###############################################################################
########                                                               ########
########              STEP 6: Player2 Moves a Piece                    ########
########                                                               ########
###############################################################################
"
echo "$PLAYER2_PROGRAM" > program.json

leo run move_piece "$STATE2" "$PLAYER1_MOVE" 1u64 6u32 0u64 6u32

# output:
STATE2="{
  owner: aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  board: {
    line0: 223762022522333u64.private,
    line1: 56096683056605u64.private,
    line2: 39051568471517u64.private,
    line3: 27505085767133u64.private,
    line4: 80764089523677u64.private
  },
  flag_x: 1u64.private,
  flag_y: 11u32.private,
  game_winner: 0u32.private,
  arbiter: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  player_index: 2u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"
PIECE2="{
  owner: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  player: aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q.private,
  piece: 6u64.private,
  x: 1u64.private,
  y: 6u32.private,
  flag_x: 5u64.private,
  flag_y: 0u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"

echo "
###############################################################################
########                                                               ########
########         STEP 7: Player1 Whispers the Target Piece             ########
########                                                               ########
###############################################################################
"
echo "$PLAYER1_PROGRAM" > program.json

leo run whisper_piece "$STATE1" "$PLAYER1_MOVE" 0u64 6u32

# output:
STATE1="{                                                                                                                                                        
  owner: aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  board: {
    line0: 243944747858108u64.private,
    line1: 243944970543153u64.private,
    line2: 243944969889843u64.private,
    line3: 243944969494674u64.private,
    line4: 243944969840532u64.private  
  },
  flag_x: 1u64.private,
  flag_y: 0u32.private,
  game_winner: 0u32.private,
  arbiter: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  player_index: 1u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"
PIECE1="{
  owner: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  player: aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0.private,
  piece: 0u64.private,
  x: 0u64.private,
  y: 6u32.private,
  flag_x: 5u64.private,
  flag_y: 0u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"

echo "
###############################################################################
########                                                               ########
########           STEP 8: Aribter Compares pieces                     ########
########                                                               ########
###############################################################################
"
echo "$ARBITER_PROGRAM" > program.json

leo run compare_pieces "$PIECE2" "$PIECE1"

# output:
PLAYER2_MOVE="{
  game_id: 0u64,
  player: aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q,
  x: 1u64,
  y: 6u32,
  target_x: 0u64,
  target_y: 6u32,
  attack_result: 0u32,
  flag_x: 5u64,
  flag_y: 0u32,
  opp_flag_x: 5u64,
  opp_flag_y: 0u32,
  game_winner: 0u32
}"

echo "
###############################################################################
########                                                               ########
########              STEP 9: Player1 Moves a Piece                    ########
########                                                               ########
###############################################################################
"
echo "$PLAYER1_PROGRAM" > program.json

leo run move_piece "$STATE1" "$PLAYER2_MOVE" 4u64 5u32 4u64 6u32

# output:
STATE1="{                                                                                                                                                        
  owner: aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0.private,
  gates: 0u64.private,
  game_id: 0u64.private,                                                                                                                                    
  board: {                           
    line0: 243944965961916u64.private,
    line1: 243944752439345u64.private,
    line2: 243944969889843u64.private,
    line3: 243944969494674u64.private,
    line4: 243944969840532u64.private
  },
  flag_x: 1u64.private,
  flag_y: 0u32.private,
  game_winner: 0u32.private,
  arbiter: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  player_index: 1u32.private,
  _nonce: 8258636820537948953013479840954863180998818914688176463155617250032541481942group.public                                                                                                                                                        
}"
PIECE1="{
  owner: aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj.private,
  gates: 0u64.private,
  game_id: 0u64.private,
  player: aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0.private,
  piece: 4u64.private,
  x: 4u64.private,
  y: 5u32.private,
  flag_x: 5u64.private,
  flag_y: 0u32.private,
}"
