
# ---- declare all wallets here ----
declare wallet_ethw="address"
declare wallet_etc="address"
declare wallet_kas="address"
declare wallet_ubq="address"
declare wallet_rvn="address"
declare wallet_erg="address"
declare wallet_neoxa="address"
declare wallet_vtc="address"
declare wallet_grin="address"
declare wallet_aion="address"
declare wallet_dagger="address"

declare -A algo
algo=(
    # algo      wallet      algo            pool                            config options
    ["ethw"]=($wallet_ethw "ethash" "stratum+tcp://ethw.2miners.com:2020" "--eth_config=B")
    ["etc"]=($wallet_etc "etchash" "stratum+tcp://eu1-etc.ethermine.org:4444" "")
    ["erg"]=($wallet_erg "autolykos2" "stratum+tcp://pool.eu.woolypooly.com:3100" "")
)

echo ${algo["ethw"]}