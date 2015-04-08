#--------------------- Basic Settings -----------------------------------------#
PROGRAM_NAME  := model
BINARY_BASE   := bin
BUILD_BASE    := bld
INCLUDE_BASE  := inc
SOURCE_BASE   := src

#--------------------- External Libraries -------------------------------------#
HEADER_DIRS   :=
STATIC_LIBS   :=

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
include ../auto_lib.mk
