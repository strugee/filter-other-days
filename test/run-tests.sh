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
