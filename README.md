make-c-cpp
=========

A Makefile for auto-building single-target C/C++ projects.

`Makefile` Features
--------

- Compile C++, C, or mixed projects.
- Compile and link options are easily configurable.
- Automatic dependency discovery, including header files.
- Automatic shared library discovery and linker inclusion
- Integrated support for testing with Google's C++ testing framework.

Requirements
------------

`Makefile` requires GNU Make and the GCC toolchain (or any other that
supports `-M`-like dependency generation). It may be possible to use
`Makefile` in other environments with little or no modificaiton.
