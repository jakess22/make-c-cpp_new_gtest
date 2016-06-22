make-c-cpp
==========

A Makefile for auto-building single-target C/C++ projects.

Features
--------

- Build C++, C, or mixed projects.
- Binaries and shared libraries.
- Compile and link options are easily configurable.
- Automatic dependency discovery, including header files.
- Integrated support for testing with Google's C++ testing framework.
- Integrated support for syntax style checking with Google's cpplint.py.

Requirements
------------

`Makefile` requires GNU Make, the GCC toolchain, and makes use of several
Unix commands. It may be possible to use `Makefile` in other environments
with little or no modification, but it hasn't been tested here!

Binary Build Commands
---------------------

| Command    | Description |
|------------|------------ |
| make all   | (default) same as 'make app lint test' |
| make app   | builds the target application |
| make lint  | runs the cpplint syntax checker on all source files |
| make test  | builds the test application |
| make clean | removes all dependency files, object files, and binaries |
| make count | reports statistics for lines of code, number of files, and git commits |

Library Build Commands
----------------------

| Command    | Description |
|------------|------------ |
| make all   | (default) same as 'make libs libd libh lint test' |
| make libs  | builds the static library |
| make libd  | builds the dynamic library |
| make libh  | builds the library include directory |
| make lint  | runs the cpplint syntax checker on all source files |
| make test  | builds the test application |
| make clean | removes all dependency files, object files, and binaries |
| make count | reports statistics for lines of code, number of files, and git commits |

Excluding Features
------------------

If you don't want to use Google's cpplint syntax checker, leave the LINT
variable empty or delete the line.
If you don't want to use Google's test framework, leave the GTEST_BASE
variable empty or delete the line.

Environment Setup
-----------------

The following commands setup the make environment completely within `~/.makeccpp`.
```bash
git clone https://github.com/nicmcd/make-c-cpp ~/.makeccpp
cd ~/.makeccpp
make
```

Example Project
---------------
See [this example project](https://github.com/nicmcd/make-c-cpp-test) for a simple
example of how to use this make system.