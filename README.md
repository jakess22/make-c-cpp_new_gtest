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

Example
-------

The example directory is an example C++ project that utilizes most of
the features of the automated Makefile system. The example project uses
two 3rd party libraries, zlib and jsoncpp (must be installed on the system), 
contains a unit test for Google's testing framework, and is compliant with 
Google's cpplint.py syntax style checker. The example is comprised of two
subprojects, one shared library, and one binary.

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
| make all   | (default) same as 'make libd libd libh lint test' |
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

If you want to run this example application out-of-the-box with no changes, run the following commands prior 
to running any make commands:

The example application needs libjsoncpp and libz
```bash
sudo apt-get install libjsoncpp-dev zlib1g-dev
```

```bash
mkdir ~/.makeccpp
cd ~/.makeccpp
git clone https://github.com/nicmcd/gtest.git
git clone https://github.com/nicmcd/cpplint.git
cd gtest/make
make gtest_main.a
```
