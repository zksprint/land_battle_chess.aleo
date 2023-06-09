# The private key and address of player1
# "private_key": APrivateKey1zkp3CsZ1dtoqFst5JNdXRwc7BBykJa9CgH4EieH89DJuE11
# "address": aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0

# The private key and address of player2
# "private_key": APrivateKey1zkpHVRBhRaMBGBN4Zo2HckRc2RreHw26Kfnr9JRPTvhJXvH
# "address": aleo1g45rz8udefg6shnvjwvhk37z5csu8p7uu6jxfhkguwcw27gmv5fq35w55q

# The private key and address of the arbiter.
# "private_key": APrivateKey1zkp8uaGbHM6eVjC5FVvhHyDtKXGBAGP9MCdbWLVX6H191RH
# "address": aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj

# Have the first bidder place a bid of 10.
echo "
###############################################################################
########                                                               ########
########          STEP 1: Player1 Initializes the board                ########
########                                                               ########
########           +------+------+------+------+------+                ########
########           | 司令 | 军棋  | 地雷 | 炸弹 | 工兵 |                 ########
########           +------+------+------+------+------+                ########
########           | 军长 | 地雷  | 地雷 | 旅长 | 旅长  |                ########
########           +------+------+------+------+------+                ########
########           | 团长 |       | 团长 |      | 营长 |                ########
########           +------+------+------+------+------+                ########
########           | 营长 | 连长  | 连长 | 连长  | 师长 |                ########
########           +------+------+------+------+------+                ########
########           | 师长 |      | 连长  |      | 排长 |                ########
########           +------+------+------+------+------+                ########
########           | 炸弹 | 排长  | 工兵 | 工兵  | 工兵 |                ########
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
echo "{
  \"program\": \"land_battle_chess.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkp3CsZ1dtoqFst5JNdXRwc7BBykJa9CgH4EieH89DJuE11\",
      \"address\": \"aleo1hv87s9eq3dj62tjm9ctp2ndzpysfwhrq79jd4tgdx2t3prqmsugs2stkw0\"
  },
  \"license\": \"MIT\"
}" > program.json

leo run player_initialize_board 595056259965886828u64 595056260056023137u64 595056260028768355u64 595056260022468898u64 595056260027850020u64\
    1u64 0u32 0u64 1u32 aleo1x46v8qqj7q722me2keyluddgfjrxmqqcs66hr372zh7tfydp7ygss28vqj