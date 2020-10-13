set timeout -1

spawn rocketpool node deposit

expect "Please choose an amount of ETH to deposit:"

send -- "2\r"

expect "Do you want to use the suggested minimum?"

send -- "y\r"

expect eof