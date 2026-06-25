#!/bin/ksh

export CURR_DIR=`pwd`
tm=`date +%Y%m%d`

stopofsaa()
{
        if [ ! -d $CURR_DIR/log ]; then
                mkdir $CURR_DIR/log
                chmod -R 755 $CURR_DIR/log
                LOG_DIR=$CURR_DIR/log
        else
                LOG_DIR=$CURR_DIR/log
                rm -rf $LOG_DIR/*.*
        fi



cd $FIC_APP_HOME/common/FICServer/bin/
./stopofsaai.sh  >> $LOG_DIR/stopofsaa_${tm}.log

sleep 10

cd $FIC_APP_HOME/icc/bin/
./iccservershutdown.sh > /dev/null 2>&1

sleep 10

cd $FIC_DB_HOME/bin/
./agentshutdown.sh  >> $LOG_DIR/stopofsaa_${tm}.log


sleep 10

cd $FIC_DB_HOME/bin/
./StopDIHWS.sh  > /dev/null 2>&1


### Service status validation ##############

        loginuser=`who am i | cut -d ' ' -f1`

        if [ -z "${LOGNAME}" ];then
        LOGNAME=$loginuser
        fi

        if [[ ${#LOGNAME} -gt 8 ]];then
        LOGNAME=`id |cut -d '=' -f2|cut -d '(' -f1`
        fi

        fic=`ps -eaf|grep $FIC_HOME|awk '!/grep/{ print $2 }' `
        icc=`ps -ef|grep $FIC_HOME|awk '!/grep/{ print $2 }' `
        msg=`ps -eaf | grep ./messageserver | grep $LOGNAME | awk '!/grep/{ print $2 } '`
        am=`ps -eaf | grep "./am$" | grep $LOGNAME | grep -v amd64 | awk '!/grep/{ print $2 } '`
        router=`ps -eaf | grep ./router | grep $LOGNAME | awk '!/grep/{ print $2 } '`
        dihws=`ps -eaf | grep $FIC_HOME | grep com.ofss.fsgbu.dih.wsServer.StartService | grep $LOGNAME | awk '!/grep/{ print $2 } '`

if [ -z "$fic" ] && [ -z "$icc" ] && [ -z "$msg" ] && [ -z "$am" ] && [ -z "$router" ] && [ -z "$dihws" ];then
return 100   # Services stopped normally

else

if [ ! -z "$fic" ];then
kill -9 $fic
fi

if [ ! -z "$icc" ];then
kill -9 $icc
fi

if [ ! -z "$msg" ];then
kill -9 $msg
fi

if [ ! -z "$am" ];then
kill -9 $am
fi

if [ ! -z "$router" ];then
kill -9 $router
fi

if [ ! -z "$dihws" ];then
kill -9 $dihws
fi

return 200  # Services stopped Forcibly
fi
}
stopofsaa

