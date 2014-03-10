make-c-cpp
=========

A Makefile for auto-building single-target C/C++ projects.

Features
--------

- Compile C++, C, or mixed projects.
- Compile and link options are easily configurable.
- Automatic dependency discovery, including header files.
- Automatic shared library discovery and linker inclusion
- Integrated support for testing with Google's C++ testing framework.
- Integrated support for syntax style checking with Google's cpplint.py

Requirements
------------

`Makefile` requires GNU Make, the GCC toolchain, and makes use of several
Unix commands. It may be possible to use `Makefile` in other environments
with little or no modification, but it hasn't been tested here!

Example
-------

The example directory is an example C++ project that utilizes most of
the features of the automated Makefile system. The example project uses
two 3rd party libraries (zlib and jsoncpp), contains a unit test for 
Google's testing framework, and is compliant with Google's cpplint.py
syntax style checker.

Common Commands
---------------

The common commands are:

| Command    | Description |
|------------|------------ |
| make       | see 'make app' |
| make app   | this builds the target application |
| make lint  | this runs the cpplint syntaz checker on all source files |
| make test  | this build the test application |
| make all   | this runs 'make lint', 'make app', and 'make test' sequentially |
| make clean | removes all dependency files, object files, and binaries |
| make count | reports statistics for lines of code, number of files, and git commits |

Excluding Features
------------------

If you don't want to use Google's cpplint syntax checker, leave the LINT
variable empty or delete the line.
If you don't want to use Google's test framework, leave the GTEST_BASE
variable empty or delete the line.
