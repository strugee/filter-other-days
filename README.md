# filter-other-days

[![Build Status](https://travis-ci.org/strugee/filter-other-days.svg?branch=master)](https://travis-ci.org/strugee/filter-other-days)

Shell script to filter logfiles for today's date in an Artificial Ignorance-compatible way

`filter-other-days` is careful to only throw away entries that we're _sure_ aren't from today. This is implemented by using `grep -v` on other dates instead of `grep` on today's date. The rationale here is that it's better to receive irrelevant information than it is to miss relevant information.

## Installation

Get the source, either by git clone or unpacked tarball. Change into the directory and run `sudo make install`.

`make install` uses `/usr/local` as the prefix by default; you may override this with `make install PREFIX=/your/custom/prefix`.

`make uninstall` also works as you'd expect.

## Usage

`filter-other-days` has one argument besides `--help` and `--version`: `-d <seconds>` can be used to override the day `filter-other-days` uses as "today", specified in [seconds since the epoch](https://en.wikipedia.org/wiki/Unix_time) (although `-d` is not available on every platform; see "What are the system requirements?" below). `filter-other-days` accepts input on stdin only.

Note that `filter-other-days` computes today's date at startup. If the time rolls over to a new day during execution, this will not be accounted for.

## Contributing

See [CONTRIBUTING.md](https://github.com/strugee/filter-other-days/blob/master/CONTRIBUTING.md).

## FAQ

### What are the system requirements?

This program is designed to require only a POSIX environment for its core functionality. GNU `seq` was required until version 1.1.0, but this has been fixed.

The `-d` option does not work under POSIX because it is impossible to implement without extensions. It is available on systems with GNU `date -d` or BSD `date -r` semantics; these are feature-tested at runtime. You can determine whether `-d` is available by examining the help output - it will not be shown if you can't use it.

That all being said, this program was tested on a GNU userland (though with `dash` as `/bin/sh`), so there may still be dependencies on GNU extensions. If you find any such dependencies, they will be considered bugs. Please [file these][file a bug] in the bug tracker.

If you want to run the test suite, you also need Bash and either `faketime` or a `date` with GNU's `date -d` semantics.

### What systems has `filter-other-days` successfully been tested on?

`filter-other-days` with the `-d` option has successfully been tested on the following systems:

* GNU/Linux
* FreeBSD 11.2-RELEASE
* OpenBSD 6.3
* OpenIndiana Hipster 20180427
* OmniOSce r151026
* Cygwin

`filter-other-days` has not been tested on any systems where `-d` is unavailable.

### I'm passing a file but it says "unrecognized option 'filename'".

Unlike many Unix programs, `filter-other-days` does not accept files on the commandline. This is because it makes the argument parsing code more complicated and your shell can accomplish the same thing just as well:

```sh
$ filter-other-days < filename
```

Besides, usually you'd want to use `cat` on multiple files before piping to `filter-other-days` anyway.

### I'm seeing entries from other days!

`filter-other-days` is intentionally designed to only filter out what it already knows about. This is because it is dangerous to throw away information you don't understand. This point is particularly salient when one is considering implementing an Artificial Ignorance system based on `filter-other-days`.

That being said, it's obviously unideal that `filter-other-days` is not doing its job. Please [file a bug][] and be sure to include some sample input and any interesting variations. When in doubt, include more. Your samples will be added to the test suite and additional filtering will be added to make those tests pass.

## License

Affero GPL 3.0 or later

## Author

AJ Jordan <alex@strugee.net>

 [file a bug]: https://github.com/strugee/filter-other-days/issues/new
