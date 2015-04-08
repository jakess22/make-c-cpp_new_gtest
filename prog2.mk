#--------------------- Basic Settings -----------------------------------------#
PROGRAM_NAME  := prog2
BINARY_BASE   := example/bin/prog2
BUILD_BASE    := example/bld/prog2
SOURCE_BASE   := example/src
MAIN_FILE     := example/src/prog2.cc
IGNORE_FILES  := example/src/prog1.cc

#--------------------- Cpp Lint -----------------------------------------------#
LINT          := $(HOME)/.makeccpp/cpplint/cpplint.py
LINT_FLAGS    :=

#--------------------- Unit Tests ---------------------------------------------#
TEST_SUFFIX   := _TEST
GTEST_BASE    := $(HOME)/.makeccpp/gtest

#--------------------- Compilation and Linking --------------------------------#
CXX           := g++
SRC_EXTS      := .cc .c
HDR_EXTS      := .h .tcc
CXX_FLAGS     := -Wall -Wextra -pedantic -Wfatal-errors -std=c++11
CXX_FLAGS     += -O3 -march=native -g
LINK_FLAGS    := -lz -ljsoncpp

#--------------------- Auto Makefile ------------------------------------------#
include auto.mk
