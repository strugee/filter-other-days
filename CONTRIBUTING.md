# Contributing

Here are some guidelines for contributing to `filter-other-days`.

## Filing issues

When in doubt, file issues. Be sure to include the version (or the git
revision if you cloned from source) and any relevant logfile
entries. Also make sure to specify what you think is going wrong, or
what's confusing you.

If `filter-other-days` is crashing, please also include the name and
revision of your operating system.

## Submitting patches

I can help you clean this up when I land your patch, but it makes
everything easier if you [write good commit messages][msgs].

If you're adding a new style of timestamp, you're also expected to put
some examples in-source and, far more important, write a thorough test
suite. See "running tests" below.

## Running tests

In order to run the tests you will need Bash, which usually comes with
all modern systems, and `faketime`, which usually doesn't. So you'll
probably need to install the latter (the package is usually called
`faketime`). If you also install `colordiff`, the diff that's
displayed when failures occur will be colorized. But it's not a
requirement.

To actually run the test suite, just invoke `test/run-tests.sh`. You
can also tell it to run only specific tests by passing it
filename(s) - for example, `test/run-tests.sh test/standard*` to run
only tests for the standard style.

It is extremely simple to write new testcases: just create a file that
ends in `.testcase` and the test suite will automatically pick it
up. The first line is the input that will be fed to
`filter-other-days` and the second line is either `output` or `no
output`, to indicate what the expected result is. The test environment
is set up such that `filter-other-days` will always believe the date
is January 1st, 2017, but if you need to override this you can put a
third line in your testcase. This line will be passed directly to
`faketime` as its first argument.

## Code of Conduct

`filter-other-days` is developed under the [Contributor
Covenant][covenant] Code of Conduct. Project contributors are expected
to respect these terms.

For the full Code of Conduct, see
[CODE_OF_CONDUCT.md][coc.md]. Violations may be reported to
<alex@strugee.net>.

 [covenant]: http://contributor-covenant.org/
 [coc.md]: https://github.com/strugee/filter-other-days/blob/master/CODE_OF_CONDUCT.md
 [msgs]: https://chris.beams.io/posts/git-commit/
