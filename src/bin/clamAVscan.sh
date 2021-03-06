#!/bin/sh

CLAMSCAN=clamscan
SCANOPTS="--stdout --no-summary"

STATUS=255
CONTENT="ERROR"
AGENT="REG_SA_VC_CLAMAV"

TARGET=$1

EchoAndExit()
{
        echo STATUS=${STATUS}
        echo CONTENT=${CONTENT}
        echo AGENT=${AGENT}
        exit ${STATUS}
}

# Check is file exist

if [ ! -f "${TARGET}" ]
then
   CONTENT="File not found"
   EchoAndExit
fi


# Check file size is less than 2GB

file_size=`ls -Ll "${TARGET}" | awk '{print $5}'`
file_size_tb=`echo "$file_size / 1024 / 1024 / 4096" | bc`

# by setting the status to 2 (>1) the new plugin will set the scanning result to 'undetermined'

if [ $file_size_tb -ne 0 ]
then
    STATUS=2
        CONTENT="Virus Check is limited to a 4GB file size and thus has been ignored"
        AGENT="REG_SA_VC_CLAMAV"
    EchoAndExit
fi

# Scan file

CONTENT=`${CLAMSCAN} ${SCANOPTS} "${TARGET}"`
STATUS=$?
EchoAndExit