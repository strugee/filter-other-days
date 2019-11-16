#!/bin/sh

# This is useful to do because it suppresses messages about individual hunks
cp filter-other-days filter-other-days.freebsd && patch filter-other-days.freebsd freebsd-bug-237752-hack.patch && diff -u filter-other-days{,.freebsd} > freebsd-bug-237752-hack.patch
