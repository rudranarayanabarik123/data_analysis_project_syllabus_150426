#!/bin/ksh
#Wrapper script to start all OFSAA Services


export CURR_DIR=`pwd`
tm=`date +%Y%m%d`

        if [ ! -d $CURR_DIR/log ]; then
                mkdir $CURR_DIR/log
                chmod -R 755 $CURR_DIR/log
                LOG_DIR=$CURR_DIR/log
        else
                LOG_DIR=$CURR_DIR/log
                rm -rf $LOG_DIR/*.*
        fi

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
        dihws=`ps -eaf | grep dih.wsServer.StartService | grep $LOGNAME | awk '!/grep/{ print $2 } '`

startofsaa()
{
echo "starting AAI main service......"  >> $LOG_DIR/startofsaa_${tm}.log
cd $FIC_APP_HOME/common/FICServer/bin/
rm -rf nohup.out.bak
mv nohup.out nohup.out.bak
nohup ./startofsaai.sh & >> $LOG_DIR/startofsaa_${tm}.log

sleep 60

echo "starting icc......" >> $LOG_DIR/startofsaa_${tm}.log
cd $FIC_APP_HOME/icc/bin/
rm -rf nohup.out.bak
mv nohup.out nohup.out.bak
nohup ./iccserver.sh & >> $LOG_DIR/startofsaa_${tm}.log

sleep 30

echo "starting agent......" >> $LOG_DIR/startofsaa_${tm}.log
cd $FIC_DB_HOME/bin/
rm -rf nohup.out.bak
mv nohup.out nohup.out.bak
nohup ./agentstartup.sh & >> $LOG_DIR/startofsaa_${tm}.log

sleep 30


echo "starting DIHWS......" >> $LOG_DIR/startofsaa_${tm}.log
cd $FIC_DB_HOME/bin/
rm -rf nohup.out.bak
mv nohup.out nohup.out.bak
nohup ./StartDIHWS.sh & >> $LOG_DIR/startofsaa_${tm}.log

sleep 30


        fic=`ps -eaf|grep $FIC_HOME|awk '!/grep/{ print $2 }' `
        icc=`ps -ef|grep $FIC_HOME|awk '!/grep/{ print $2 }' `
        msg=`ps -eaf | grep ./messageserver | grep $LOGNAME | awk '!/grep/{ print $2 } '`
        am=`ps -eaf | grep "./am$" | grep $LOGNAME | grep -v amd64 | awk '!/grep/{ print $2 } '`
        router=`ps -eaf | grep ./router | grep $LOGNAME | awk '!/grep/{ print $2 } '`
        dihws=`ps -eaf | grep dih.wsServer.StartService | grep $LOGNAME | awk '!/grep/{ print $2 } '`

sleep 15


if [ ! -z "$fic" ] && [ ! -z "$icc" ] && [ ! -z "$msg" ] && [ ! -z "$am" ] && [ ! -z "$router" ] && [ ! -z "$dihws" ];then

cd $CURR_DIR
/u02/OFSAA/OFSAA_SRV/checkofsaa.sh  >> $LOG_DIR/startofsaa_${tm}.log

return 100   # Services started normally


else

if [ -z "$fic" ];then
cd $FIC_APP_HOME/common/FICServer/bin/
nohup ./startofsaai.sh & >> $LOG_DIR/startofsaa_${tm}.log
sleep 60
fi

if [ -z "$icc" ];then
cd $FIC_APP_HOME/icc/bin/
nohup ./iccserver.sh & >> $LOG_DIR/startofsaa_${tm}.log
sleep 30
fi

if [ -z "$msg" ];then
cd $FIC_DB_HOME/bin/
nohup ./messageserver & >> $LOG_DIR/startofsaa_${tm}.log
sleep 30
fi


if [ -z "$am" ];then
cd $FIC_DB_HOME/bin/
nohup ./am & >> $LOG_DIR/startofsaa_${tm}.log
sleep 30
fi


if [ -z "$router" ];then
cd $FIC_DB_HOME/bin/
nohup ./router & >> $LOG_DIR/startofsaa_${tm}.log
sleep 30
fi

if [ -z "$dihws" ];then
cd $FIC_DB_HOME/bin/
nohup ./StartDIHWS.sh & >> $LOG_DIR/startofsaa_${tm}.log
sleep 30
fi


cd $CURR_DIR
/u02/OFSAA/OFSAA_SRV/checkofsaa.sh  >> $LOG_DIR/startofsaa_${tm}.log

return 200  # Services started Forcibly

fi

}

stopservice()
{
echo "All the services not stopped properly. Please execute stopofsaa service first.." >> $LOG_DIR/startofsaa_${tm}.log
return 250
}

if [ -z "$fic" ] && [ -z "$icc" ] && [ -z "$msg" ] && [ -z "$am" ] && [ -z "$router" ]  && [ -z "$dihws" ];then
startofsaa
else
stopservice
fi

