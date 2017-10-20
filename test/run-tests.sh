#!/bin/bash

# This file is part of filter-other-days.
#
# filter-other-days is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# filter-other-days is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License along with filter-other-days.  If not, see
# <http://www.gnu.org/licenses/>.

SUCCESSES=0
FAILURES=0

if [[ -z $@ ]]; then
	cd $(dirname $0)
	TESTS="*.testcase"
	BINFILE=../bin/filter-other-days
else
	TESTS="$@"
	BINFILE=$(dirname $0)/../bin/filter-other-days
fi

for i in $TESTS; do
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

	WC=$(echo "$TOPIC" | faketime '2017-01-01' $BINFILE | wc -l)
	RETCODE=$?
	if [ $RETCODE == 0 ]; then
		if [ $WC == $LINES ]; then
			echo $i passed
			SUCCESSES=$(($SUCCESSES+1))
		else
			echo $i failed\; expected $LINES lines of output but saw $WC 2>&1
			FAILURES=$(($FAILURES+1))
		fi
	else
		echo $i failed\; got nonzero exit code $RETCODE when counting lines 2>&1
		FAILURES=$(($FAILURES+1))
	fi
done

echo
echo $FAILURES failed
echo $SUCCESSES succeeded

if ! [ $FAILURES = 0 ]; then exit 1; fi

exit 0
