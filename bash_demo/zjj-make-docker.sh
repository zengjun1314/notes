#! /bin/bash

user_name=zjj
container_name=$user_name-image
jgq_base_conf=/tmp/jgq-base.conf
repo_file=/tmp/jgq.repo
container_on0_ip=138.1.1.20
PWD=$(cd $(dirname $0); pwd)

function err_clean
{
    docker-manage rm $container_name
    rm -rf $jgq_base_conf
    exit 1
}

function run
{
    docker exec -i --privileged "$1" bash -c "$2"
}

function check_depend
{
    rpm -q docker-manage &>/dev/null || { echo "error: docker-manage is not installed"; return 1; }
    docker inspect jgq-base:1 &>/dev/null || { echo "error: image jgq-base:1 is not exist"; return 1; }
    docker inspect $container_name &>/dev/null && { echo "error: container $container_name is already existed"; return 1; }
    echo "check depend all right"
}

function is_user_image_exist
{
    docker images|grep -qw $user_name-docker && return 0 || return 1
}

function make_user_image
{
    cat >$jgq_base_conf <<EOF
{
  "docker_image":"jgq-base:1"
  "container_name": "$container_name"
  "cmd": "/bin/sh"
  "run_opts":" --privileged --entrypoint=/sbin/init"
  "ovs": "ovs-$user_name-image $container_on0_ip/24"
}
EOF
    docker-manage create $jgq_base_conf
    rm -rf $jgq_base_conf
    cat >/tmp/pip.tmp <<EOF
[global]
trusted-host = 10.43.211.62
find-links = http://10.43.211.62/podm_install
no-index = true
EOF
    run $container_name "mkdir -p /root/.pip"
    docker cp /tmp/pip.tmp $container_name:/root/.pip/pip.conf
    rm -rf /tmp/pip.tmp
    cat >create.sh <<EOF
#! /bin/bash
EOF
    chmod 755 create.sh
    docker cp create.sh $container_name:/root/create.sh
    rm -rf create.sh

    # user required rpms
    run $container_name "yum -y install git git-review dos2unix tree"
    run $container_name "pip install autopep8 pep8 flake8"

    # repair lack of locale
    run $container_name "yum -y install yum-utils"
    run $container_name "mkdir -p /home/glibc"
    run $container_name "cd /home/glibc; yumdownloader glibc glibc-common"
    run $container_name "cd /home/glibc; rpm -Uvh --oldpackage glibc-*.x86_64.rpm"
    run $container_name "rm -rf /home/glibc"
    run $container_name "echo 'LANG=\"en_US.UTF-8\"' >> /etc/locale.conf"

    user_define_func
    commit_image
}

function commit_image
{
    local date_tag=$(date '+%Y.%m.%d')
    echo "docker commit $container_name $user_name-docker:$date_tag ..."
    docker commit -m "$user_name working docker" $container_name $user_name-docker:$date_tag || { echo "docker commit $container_name err!"; return 1;}
    docker-manage rm $container_name
}

function user_define_func
{
    # user settings
    run $container_name "systemctl disable podm-scheduler podm-concrete podm-versioner podm-alarm podm-alarmagent podm-api"
    run $container_name "systemctl stop podm-scheduler podm-concrete podm-versioner podm-alarm podm-alarmagent podm-api"
    run $container_name "rm -rf /lib/python2.7/site-packages/podm"
    run $container_name "rm -rf /lib/python2.7/site-packages/podmclient"
    run $container_name "ln -sv /home/zengjj/zxocsa/podm/podm/podm/podm /lib/python2.7/site-packages/podm"
    run $container_name "ln -sv /home/zengjj/zxocsa/podm/podm/podmclient/podmclient /lib/python2.7/site-packages/podmclient"
    run $container_name "echo 'source /root/.keystone_admin' >> /etc/profile"
}

function create_working_container
{
    local image_id=$(docker images|grep -w "$user_name-docker"|sed -n 1p|awk '{print $3}')
    [[ "$image_id" = "" ]] && image_id=IMAGEID
    local create_file=/tmp/$user_name-docker.conf
    cat >$create_file <<EOF
{
  "docker_image":"$image_id"
  "container_name": "$user_name-docker"
  "cmd": "-c /bin/sh"
  "run_opts": "--privileged -p 20080:80 -p 20022:22 -p 23306:3306 -v /home/zengjj:/home/zengjj"
  "exec_create_cmd": "sh /root/create.sh"
  "ovs": "ovs-$user_name 138.1.1.20/24"
}
EOF
    docker-manage create $create_file
    local port=$(grep run_opts $create_file|grep -o '[[:digit:]]*:22'|awk -F: '{print $1}')
    [[ "$?" -eq 0 ]] && echo "please use ssh on port $port to connect your new container"
    return
}

function main
{
    check_depend || exit 1
    is_user_image_exist || make_user_image
    create_working_container
}

main
