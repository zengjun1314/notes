#!/bin/bash

expect <<END
spawn ./talk.sh
expect "Who"
send "firefly\n"
expect "happy?"
send "Yes,I am happy.\n"
expect "why?"
send "Because it worked!\n"
expect eof
exit
END