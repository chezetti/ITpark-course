#!/bin/bash
set -e

tos=/home/chezetti/tonos-cli/target/release/tonos-cli
if test -f "$tos"; then
    echo "$tos exists."
else
    echo "$tos not found in current directory. Please, copy it here and rerun script."
    exit
fi

DEBOT_NAME=../FillingShoppingListDebot
giver=0:841288ed3b55d9cdafa806807f02a0ae0c169aa5edfe88a789a6482429756a94
function giver {
$tos --url http://127.0.0.1 call --abi giver.abi.json $giver sendGrams "{\"dest\":\"$1\",\"amount\":10000000000}"
}

function get_address {
echo $(cat log.log | grep "Raw address:" | cut -d ' ' -f 3)
}

function genaddr {
$tos genaddr $1.tvc $1.abi.json --genkey $1.keys.json > ./Deploy/log.log
}

function get_decode {
echo $(cat ShoppingList.decode.json | grep "data:" | cut -d ' ' -f 3)
}

LOCALNET=http://127.0.0.1
DEVNET=https://net.ton.dev
MAINNET=https://main.ton.dev
NETWORK=$LOCALNET

echo GENADDR DEBOT
genaddr $DEBOT_NAME
DEBOT_ADDRESS=$(get_address)

echo ASK GIVER
giver $DEBOT_ADDRESS
DEBOT_ABI=$(cat $DEBOT_NAME.abi.json | xxd -ps -c 20000)

echo DEPLOY DEBOT $DEBOT_ADDRESS
$tos --url $NETWORK deploy $DEBOT_NAME.tvc "{}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json
$tos --url $NETWORK call $DEBOT_ADDRESS setABI "{\"dabi\":\"$DEBOT_ABI\"}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json
$tos --url $NETWORK call --abi $DEBOT_NAME.abi.json --sign $DEBOT_NAME.keys.json $DEBOT_ADDRESS setShoppingListCode ShoppingList.decode.json

echo DONE
echo $DEBOT_ADDRESS > ./Deploy/address.log
echo debot $DEBOT_ADDRESS