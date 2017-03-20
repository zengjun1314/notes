#!/bin/bash
logfile="/home/result.log"
function checkRabbitmq()
{
        retn=0
        rabbitmqctl -q status | grep "running_applications.*rabbit" >> $logfile

        if [ $? -eq 0 ];then
                retn=0
        else
                retn=1
        fi

        return $retn
}

echo "start rabbitmq" | tee -a $logfile
export HOME=/var/lib/rabbitmq
rabbitmqctrl_file=/usr/lib/rabbitmq/bin/rabbitmqctl
if [ ! -e $rabbitmqctrl_file ];
then
    echo "Rabbitmq server abnormal!" >> $logfile
    exit 3
else
    checkRabbitmq
    if [ $? -eq 0 ];then
        echo "Rabbitmq has been started!" | tee -a $logfile
    else
        echo "Rabbitmq not started!" | tee -a $logfile
        rm -rf /var/lib/rabbitmq/*
        rm -rf /var/lib/rabbitmq/.erlang.cookie
        rm -rf /var/lib/rabbitmq/.OpenIPMI_db
        rm -rf /var/log/rabbitmq/*
        systemctl restart rabbitmq-server.service >> $logfile
        chkconfig rabbitmq-server on >> $logfile
        try=1
        max_retry=60
        while [ "$try" -lt "$max_retry" ]
        do
            echo "detect RabbitMq server $try time" | tee -a $logfile
            checkRabbitmq
            if [ $? -eq 0 ];
            then
                try=$max_retry
            else
                try=$(($try+1))
                sleep 1
            fi
        done
    fi
fi
