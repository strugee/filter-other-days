# `filter-other-days` changelog

`filter-other-days` follows [Semantic Versioning][1]. Support for additional timestamp styles is considered semver-minor.

## 1.1.0 - future

### Added

* A Debian package is now available
* The `-d` flag allows overriding the day to filter for

### Changed

* GNU `seq` is no longer required
* `filter-other-days(1)` is now formatted as `mdoc(7)` instead of `man(7)`
* Port the test suite to run on OpenBSD, NetBSD, illumos (OpenIndiana and OmniOSce), and Cygwin using `-d`
* Explicitly request GNU tool POSIX compliance

### Fixed

* Use EREs instead of BREs to avoid non-portable GNU extension `\|` in BREs
* Error messages are now printed to stderr
* Resolve a `sort(1)` warning message on OmniOSce and presumably other Solaris-like `sort(1)` implementations

## 1.0.1 - 2017-11-01

### Fixed

* Fix an `echo` portability issue which affected FreeBSD
* Fix some portability bugs in the test suite which affected FreeBSD
* Fix a `test` portability issue caught by `checkbashisms`

## 1.0.0 - 2017-10-20

### Added

* Initial release

 [1]: http://semver.org/
