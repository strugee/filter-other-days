#!/usr/bin/env bash

# Copyright 2017, 2018 AJ Jordan <alex@strugee.net>
#
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
# <https://www.gnu.org/licenses/>.

SUCCESSES=0
FAILURES=0

GDATE=date
# OmniOS; probably other illumosen
test -x /usr/gnu/bin/date && GDATE=/usr/gnu/bin/date
type gdate >/dev/null 2>&1 && GDATE=gdate

if ! type faketime &>/dev/null && ! $(dirname $0)/../filter-other-days -h | grep -- '-d' >/dev/null; then
	echo $0: faketime and -d are not available; cannot run tests
	exit 1
fi

if type colordiff &>/dev/null; then
	DIFF=colordiff
else
	DIFF=diff
fi

if [[ -z $@ ]]; then
	cd $(dirname $0)
	TESTS="*.testcase"
	BINFILE=../filter-other-days
else
	TESTS="$@"
	BINFILE=$(dirname $0)/../filter-other-days
fi

for i in $TESTS; do
	exec 3<> $i
	read TOPIC <&3
	read EXPECTED <&3
	read FAKETIME <&3
	exec 3>&-

	if [ "$EXPECTED" == 'output' ]; then
		LINES=1
		EXPECTED_OUTPUT="$TOPIC"
	elif [ "$EXPECTED" == 'no output' ]; then
		LINES=0
		EXPECTED_OUTPUT=""
	else
		echo "unknown expectation '$EXPECTED' in $i" 2>&1
		exit 1
	fi

	if [ -z $FAKETIME ]; then FAKETIME=2017-01-01; fi

	# TODO refactor this to not rely on $WC and just directly use diff or something
	if type faketime >/dev/null 2>&1; then
		CMD="echo \"$TOPIC\" | faketime -f \"$FAKETIME 00:00:00\" $BINFILE"
	else
		CMD="echo \"$TOPIC\" | $BINFILE -d $($GDATE +%s -d $FAKETIME\ 00:00:00)"
	fi
	WC=$(eval $CMD | wc -l)
	RETCODE=$?
	if [ $RETCODE == 0 ]; then
		if [ $WC == $LINES ]; then
			echo $i passed
			SUCCESSES=$(($SUCCESSES+1))
		else
			echo $i failed\; expected $LINES lines of output but saw $WC: 2>&1

			# This is kinda confusing, but what's happening is that we're passing
			# two file descriptors to `diff`. The code here used to set up stdin
			# (with `eval $CMD |`) and fd 4 (with `4<<<$EXPECTED_OUTPUT`), then
			# invoke `diff /dev/fd/4 -`. However, this doesn't work on systems
			# that don't do /dev/fd properly - in particular, FreeBSD seems to
			# only set up /dev/fd entries for stdin, stdout and stderr, not any
			# custom file descriptors.
			#
			# So instead what we do is we use bash's builtin syntax for this. It
			# looks clumsier in this situation, but it means that if /dev/fd isn't
			# properly available bash will use FIFOs instead.
			#
			# See "Process Substitution" in bash(1) for details.
			$DIFF -u <(echo $EXPECTED_OUTPUT) <(eval $CMD) | tail -n +4  2>&1

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
