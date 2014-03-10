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

`Makefile` requires GNU Make and the GCC toolchain (or any other that
supports `-M`-like dependency generation). It may be possible to use
`Makefile` in other environments with little or no modificaiton.

Example
-------

The example directory is an example C++ project that utilizes most of
the features of the automated Makefile system. The example project uses
two 3rd party libraries (zlib and jsoncpp), contains a unit test for 
Google's testing framework, and is compliant with Google's cpplint.py
syntax style checker.
