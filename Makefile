#--------------------- Basic Settings -----------------------------------------#
PROGRAM_NAME  = myapp
BINARY_BASE   = example/bin
BUILD_BASE    = example/bld
LIBRARY_BASE  = example/lib
SOURCE_BASE   = example/src
MAIN_FILE     = example/src/main.cc

#--------------------- Cpp Lint -----------------------------------------------#
LINT          = $(HOME)/.google/cpplint.py
LINT_FLAGS    =

#--------------------- Unit Tests ---------------------------------------------#
TEST_SUFFIX   = _TEST
GTEST_BASE    = $(HOME)/.google/gtest-1.7.0

#--------------------- Compilation and Linking --------------------------------#
CXX           = g++
SRC_EXTS      = .cc .c
HDR_EXTS      = .h .tcc
LIB_EXTS      = .a .so
CXX_LANG      = -Wall -Wextra -pedantic -Wfatal-errors -std=c++11
CXX_OPT       = -O3 -march=native -g
LINK_FLAGS    = -lm

#--------------------- Auto Makefile ------------------------------------------#
include auto.mk
