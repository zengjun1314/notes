#!/bin/bash

#自动验证ssh免交互登陆
function verify_ssh
{
    local host=$1
    local password=$2
    expect << EOF
set timeout 20
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $host
expect {
    "*(yes/no)" { send "yes\n"; exp_continue }
    "*password:" { send "$password\n" }
}
spawn ssh $host
expect "*#"
send "exit\n"
expect eof
EOF
}

# the function for no verify ssh
# the input
# 1) host_ip
# 2) password (default user :root )
verify_ssh $*

