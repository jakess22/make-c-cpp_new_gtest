#--------------------- External Libraries -------------------------------------#
LIBS_LOC       := ../
HEADER_DIRS    := \
    $(LIBS_LOC)libprim/inc \
    $(LIBS_LOC)librnd/inc \
    $(LIBS_LOC)libmut/inc \
    $(LIBS_LOC)libbits/inc \
    $(LIBS_LOC)libjson/inc \
    $(LIBS_LOC)libstrop/inc \
    $(LIBS_LOC)libsettings/inc \
    $(LIBS_LOC)libfio/inc \
    $(LIBS_LOC)libcolhash/inc \
    $(LIBS_LOC)libfactory/inc
STATIC_LIBS    := \
    $(LIBS_LOC)libprim/bld/libprim.a \
    $(LIBS_LOC)librnd/bld/librnd.a \
    $(LIBS_LOC)libmut/bld/libmut.a \
    $(LIBS_LOC)libbits/bld/libbits.a \
    $(LIBS_LOC)libjson/bld/libjson.a \
    $(LIBS_LOC)libstrop/bld/libstrop.a \
        $(LIBS_LOC)libsettings/bld/libsettings.a \
    $(LIBS_LOC)libfio/bld/libfio.a \
    $(LIBS_LOC)libcolhash/bld/libcolhash.a \
    $(LIBS_LOC)libfactory/bld/libfactory.a

#--------------------- Cpp Lint -----------------------------------------------#

#--------------------- Unit Tests ---------------------------------------------#
TEST_SUFFIX    := _TEST

#--------------------- Compilation and Linking --------------------------------#
CXX            := g++
SRC_EXTS       := .cc
HDR_EXTS       := .h .tcc
CXX_FLAGS      := -Wall -Wextra -pedantic -Wfatal-errors -std=c++11
CXX_FLAGS      += -Wno-unused-parameter
CXX_FLAGS      += -g -O3 -flto
LINK_FLAGS     := -lz
LINK_FLAGS    += -Wl,-rpath=/p/svl/p1/pubtools/supersim_tools/lib:/p/svl/p1/pubtools/supersim_tools/lib64

#--------------------- Auto Makefile ------------------------------------------#
include ${HOME}/.makeccpp/auto_bin.mk
