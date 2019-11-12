#!/bin/sh

# TODO update versions and manpage timestamp
# TODO check for changelog entry
# TODO run `git tag`
# TODO make sure a version number is passed

VERSION=$1
test -z "$FILTER_OTHER_DAYS_GPG" && FILTER_OTHER_DAYS_GPG=gpg

die() {
	echo $0: $1 1>&2
	exit 1
}

if test -z "$VERSION"; then
	die 'no version provided'
fi

if ! test -d .git; then
	die 'need to be run from the root of the git repo'
fi

if ! git diff-index --quiet --cached HEAD --; then
	die 'changes staged but not committed'
fi

if ! git diff-files --quiet; then
	die 'unstaged changes present'
fi

if u="$(git ls-files --exclude-standard --others)" && ! test -z "$u"; then
	die 'untracked files present'
fi

echo 'Cleaning worktree'
if ! git clean -dfX; then
	die '`git clean -dfX` failed'
fi

# We put these in a temporary directory so the first archive isn't included in the second, etc.
echo 'Creating temporary directory'
TMPDIR=$(mktemp -d)

pack_archives() {
	FILETAG=$1

	echo "Packing$TAG archive"

	TARBALL=$TMPDIR/filter-other-days${FILETAG}_$VERSION.tar
	# We use * instead of . so that dotfiles are excluded
	if ! tar --owner=0 --group=0 --numeric-owner --mtime="@SOURCE_DATE_EPOCH" --sort=name -cv * > $TARBALL; then
		die '`tar` failed'
	fi

	echo 'Compressing archive with gzip'
	if ! gzip -n <$TARBALL >$TARBALL.gz; then
		die '`gzip` failed'
	fi

	echo 'Compressing archive with xz'
	if ! xz <$TARBALL >$TARBALL.xz; then
		die '`xz` failed'
	fi

	for i in $TARBALL $TARBALL.gz $TARBALL.xz; do
		echo Signing $(basename $i)
		if ! $FILTER_OTHER_DAYS_GPG --detach-sign $i --output $i.gpg; then
			die '`gpg` failed'
		fi
	done
}

pack_archives '' ''

echo 'Applying FreeBSD workaround patch'
patch filter-other-days freebsd-bug-237752-hack.patch

pack_archives _freebsd 'patched FreeBSD'

echo 'Normalizing permissions'
chmod 644 $TMPDIR/*

echo 'Moving files out of temporary directory'
mv $TMPDIR/* .

echo 'Cleaning up'
rmdir $TMPDIR

echo 'Release complete.'
