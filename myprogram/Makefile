#--------------------- Basic Settings -----------------------------------------#
PROGRAM_NAME  := myprogram
BINARY_BASE   := bin
BUILD_BASE    := bld
SOURCE_BASE   := src
MAIN_FILE     := src/prog.cc

#--------------------- External Libraries -------------------------------------#
HEADER_DIRS   := ../libmodel/inc
STATIC_LIBS   := ../libmodel/bld/libmodel.a

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
CXX_FLAGS     += -O2 -march=native -g
LINK_FLAGS    := -lz -ljsoncpp

#--------------------- Auto Makefile ------------------------------------------#
include ../auto_bin.mk
