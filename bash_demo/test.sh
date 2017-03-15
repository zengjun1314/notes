#!/bin/bash


help()
{
cat <<help
this is the help of the function
help
}

hello()
{
    echo "values of vars:"$*
	echo "hello world!"
    val=10
}

#当前目录
_SETUP_DIR=$(cd $(dirname $0); pwd)
echo $_SETUP_DIR

#-e 文件已经存在
#-f 文件是普通文件
#-s 文件大小不为零
#-d 文件是一个目录
#-r 文件对当前用户可以读取
#-w 文件对当前用户可以写入
#-x 文件对当前用户可以执行
#-g 文件的 GID 标志被设置
#-u 文件的 UID 标志被设置
#-O 文件是属于当前用户的
#-G 文件的组 ID 和当前用户相同
##########################################
#对应的操作 整数操作 字符串操作
#相同 -eq =
#不同 -ne !=
#大于 -gt >
#小于 -lt <
#大于或等于 -ge
#小于或等于 -le
#为空 -z
#不为空 -n
#比如：
#比较整数 a 和 b 是否相等就写做 if [ $a = $b ]
#判断整数 a 是否大于整数 b 就写做 if [ $a -gt $b ]
#比较字符串 a 和 b 是否相等就写作：if [ $a = $b ]
#判断字符串 a 是否为空就写作： if [ -z $a ]
#判断整数变量 a 是否大于 b 就写作：if [ $a -gt $b ]
#注意：在“[”和“]”符号的左右都留有空格。
##########################################

#[ -z "$1" ] && help
[ -d "$_SETUP_DIR" ] && help

hello $*


echo "number of vars:"$#   #入參个数
echo "values of vars:"$*   #入參明细
echo "values of vars:"$@   #入參明细
echo "value of var1:"$1
echo "value of var2:"$2
echo "value of var3:"$3
echo "value of var4:"$4


# 检测当前环境是否有可用的podm-docker的rpm包,
# function check_rpm
# {
#     rpm_type_num=$(ls $_SETUP_DIR/podm*docker*.rpm 2>/dev/null | awk -F '-docker' '{print $1}' | uniq | wc -l)
#     echo $rpm_type_num
#     [[ $rpm_type_num -gt 1 ]] && { echo "rpm conflict: podm-docker and podm-dashboard-docker can not be existed at the same time in current directory !"; return 1 ; }

#     rpm_file=$(ls $_SETUP_DIR/podm*docker*.rpm 2>/dev/null | sort -V | sed -n '$p')
#     [[ "$rpm_file" = "" ]] && { echo "rpm not found: there is no podm-docker rpm package in current directory !"; return 1; }
#     rpm_version=$(rpm -qpi $rpm_file | grep Version | awk '{print $NF}')
#     echo "rpm check all right: package used to install is `basename $rpm_file`"
# }

# sed  用法
# 删除文件中的空行开头或者全空行
sed -i '/^[[:space:]]*#/d;/^[[:space:]]*$/d'  "/home/test.txt"


