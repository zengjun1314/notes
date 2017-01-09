#!/bin/bash
#usage ./ssh_trust.sh host1 user1 passwd1 host2 user2 passwd2
#即建立从user1@host1到user2@host2的ssh信任。
src_host=$1
src_username=$2
src_passwd=$3

dst_host=$4
dst_username=$5
dst_passwd=$6

#在远程主机1上生成公私钥对
Keygen()
{
expect << EOF
spawn ssh $src_username@$src_host ssh-keygen -t rsa
while 1 {
        expect {
                 "password:" {
                              send "$src_passwd\n"
                               }
                "yes/no*" {
                            send "yes\n"
                          }
                        "Enter file in which to save the key*" {
                                        send "\n"
                        }
                        "Enter passphrase*" {
                                        send "\n"
                        }
                        "Enter same passphrase again:" {
                                        send "\n"
                                        }

                        "Overwrite (y/n)" {
                                        send "n\n"
                        }
                        eof {
                                   exit
                        }
        }
}
EOF
}
#从远程主机1获取公钥保存到本地
Get_pub()
{
expect << EOF
spawn scp $src_username@$src_host:~/.ssh/id_rsa.pub /tmp
expect {
             "password:" {
                           send "$src_passwd\n";exp_continue
                }
                "yes/no*" {
                           send "yes\n";exp_continue
                }
                eof {
                                exit
                }
}
EOF
}
#将公钥的内容附加到远程主机2的authorized_keys
Put_pub()
{
src_pub="$(cat /tmp/id_rsa.pub)"
expect << EOF
spawn ssh $dst_username@$dst_host "mkdir -p ~/.ssh;echo $src_pub >> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys"
expect {
            "password:" {
                        send "$dst_passwd\n";exp_continue
             }
            "yes/no*" {
                        send "yes\n";exp_continue
             }
            eof {
                        exit
             }
}
EOF
}
Keygen
Get_pub
Put_pub
