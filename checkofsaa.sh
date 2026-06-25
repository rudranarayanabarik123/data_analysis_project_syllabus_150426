
PID=`ps -eaf|grep $FIC_HOME|grep ficserver.home|awk '!/grep/{ print $2 }' `

if [ ! -z "${PID}" ]
then
        echo "FICServer Status: FICServer is active (PID: $PID)"
else
        echo "Action required: OFSAA Infrastructure Services: FICServer is NOT running."
fi

PID=`ps -ef|grep $FIC_HOME|grep iccserver.ICCServer|awk '!/grep/{ print $2 }' `

if [ ! -z "${PID}" ]
then
        echo "ICCServer Status: ICCServer is active (PID: $PID)"
else
        echo "Action required: OFSAA Infrastructure Services: ICCServer is NOT running."
fi


loginuser=`who am i | cut -d ' ' -f1`

if [ -z "${LOGNAME}" ];then
  LOGNAME=$loginuser
fi

if [[ ${#LOGNAME} -gt 8 ]];then
   LOGNAME=`id |cut -d '=' -f2|cut -d '(' -f1`
fi

PID=`ps -eaf | grep ./messageserver | grep $LOGNAME | awk '!/grep/{ print $2 } '`
if [ ! -z "${PID}" ];then
        echo "MESSAGE Server Status: MESSAGE Server is active (PID: $PID)"
else
                echo "Action required: OFSAA Infrastructure Services: MESSAGE Server is NOT running."
fi

PID=`ps -eaf | grep "./am$" | grep $LOGNAME | grep -v amd64 | awk '!/grep/{ print $2 } '`
if [ ! -z "${PID}" ];then
        echo "AM Server Status: AM Server is active (PID: $PID)"
else
                echo "Action required: OFSAA Infrastructure Services: AM Server is NOT running."
fi

PID=`ps -eaf | grep ./router | grep $LOGNAME | awk '!/grep/{ print $2 } '`
if [ ! -z "${PID}" ];then
        echo "ROUTER Server Status: ROUTER Server is active (PID: $PID)"
else
                echo "Action required: OFSAA Infrastructure Services: ROUTER Server is NOT running."
fi

PID=`ps -eaf|grep $FIC_HOME| grep com.ofss.fsgbu.dih.wsServer.StartService |awk '!/grep/{print $2 }' `

if [ ! -z "${PID}" ]
then
        echo "DIHServer Status: DIHServer Server is active (PID: $PID)"
else
        echo "Action required: OFSAA Infrastructure Services: DIHServer is NOT running."
fi

