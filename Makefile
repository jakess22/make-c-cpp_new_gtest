#---------- Basic settings  ----------#
PROGRAM_NAME  = myapp
BINARY_BASE   = example/bin
BUILD_BASE    = example/bld
LIBRARY_BASE  = example/lib
SOURCE_BASE   = example/src
MAIN_FILE     = example/src/main.cc

#---------- Unit tests ----------#
TEST_SUFFIX = _TEST
GTEST_BASE  = $$HOME/.gtest-1.7.0

#---------- Compilation and linking ----------#
CXX        = g++
SRC_EXTS   = .cpp .cc .C .CPP .c++ .cp .cxx .c
HDR_EXTS   = .hpp .hh .H .HPP .h++ .hp .hxx .h
LIB_EXTS   = .a .so
CXX_LANG   = -Wall -Wextra -pedantic -Wfatal-errors -std=c++11
CXX_OPT    = -O3 -march=native -flto -g
LINK_FLAGS = -lm

#---------- Auto Makefile ----------#
include auto.mk
