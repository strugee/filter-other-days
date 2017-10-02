#!/bin/bash

cd $(dirname $0)

NEEDFAIL=false

for i in *.testcase; do
	exec 3<> $i
	read TOPIC <&3
	read EXPECTED <&3
	exec 3>&-

	if [ "$EXPECTED" == 'output' ]; then
		LINES=1
	elif [ "$EXPECTED" == 'no output' ]; then
		LINES=0
	else
		echo "unknown expectation '$EXPECTED' in $i" 2>&1
		exit 1
	fi

	WC=$(echo "$TOPIC" | faketime '2017-10-20' ../bin/filter-other-days | wc -l)
	RETCODE=$?
	if [ $RETCODE == 0 ]; then
		if [ $WC == $LINES ]; then
			echo $i passed
		else
			echo $i failed\; expected $LINES lines of output but saw $WC 2>&1
			NEEDFAIL=true
		fi
	else
		echo $i failed\; got nonzero exit code $RETCODE when counting lines 2>&1
		NEEDFAIL=true
	fi
done

if $NEEDFAIL; then exit 1; fi

exit 0
