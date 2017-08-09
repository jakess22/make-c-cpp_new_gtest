# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# - Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# - Neither the name of prim nor the names of its contributors may be used to
# endorse or promote products derived from this software without specific prior
# written permission.
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# THIS FILE SHOULD NOT BE ALTERED !!!

.SUFFIXES:

TGT_APP := $(BINARY_BASE)/$(PROGRAM_NAME)
TST_APP := $(BINARY_BASE)/$(PROGRAM_NAME)$(TEST_SUFFIX)

HDR_INC := -I$(SOURCE_BASE) $(addprefix -I,$(HEADER_DIRS))

ALL_SRCS := $(foreach EXT,$(SRC_EXTS),$(shell find $(SOURCE_BASE) -type f -iname "*$(EXT)"))
ALL_HDRS := $(foreach EXT,$(HDR_EXTS),$(shell find $(SOURCE_BASE) -type f -iname "*$(EXT)"))
ALL_DEPS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.d,$(ALL_SRCS))
ALL_OBJS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.o,$(ALL_SRCS))

TST_UNIT_SRCS := $(foreach EXT,$(SRC_EXTS),$(shell find $(SOURCE_BASE) -type f -iname "*$(TEST_SUFFIX)$(EXT)"))
TST_UNIT_DEPS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.d,$(TST_UNIT_SRCS))
TST_UNIT_OBJS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.o,$(TST_UNIT_SRCS))

TGT_SRCS := $(filter-out $(TST_UNIT_SRCS),$(ALL_SRCS))
TGT_DEPS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.d,$(TGT_SRCS))
TGT_OBJS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.o,$(TGT_SRCS))

TST_DEPS_SRCS := $(filter-out $(MAIN_FILE),$(TGT_SRCS))
TST_DEPS_DEPS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.d,$(TST_DEPS_SRCS))
TST_DEPS_OBJS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.o,$(TST_DEPS_SRCS))

SRC_DIRS := $(shell find $(SOURCE_BASE) -type d -print)
BLD_DIRS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%,$(SRC_DIRS))

ALL_EXTS := $(shell echo $(SRC_EXTS) $(HDR_EXTS) | tr " " , | tr -d .)
LINT_FLAGS += --root=$(SOURCE_BASE) --extensions=$(ALL_EXTS)
LINT_OUT := $(BUILD_BASE)/$(PROGRAM_NAME).lint

GTEST_MAIN := $(GTEST_BASE)/make/gtest_main.a
GTEST_PARALLEL_RUN := $(GTEST_PARALLEL)/gtest-parallel

VERBOSE = 0
ifeq ($(VERBOSE), 0)
  AT=@
else
  AT=
endif

.PHONY: all lint app test clean count updatemk check

all: lint app test

app: $(TGT_APP)

lint: $(LINT_OUT)

test: $(TST_APP)

$(BINARY_BASE):
	$(AT)mkdir -p $@

$(BLD_DIRS):
	$(AT)mkdir -p $@

$(LINT_OUT): $(ALL_SRCS) $(ALL_HDRS) | $(BUILD_BASE)
ifneq ($(wildcard $(LINT)),)
	@echo [LINT]
	$(AT)python $(LINT) $(LINT_FLAGS) $(ALL_SRCS) $(ALL_HDRS)
	$(AT)echo "linted" > $(LINT_OUT)
else
	@echo -n
endif

$(TGT_APP): $(TGT_OBJS) $(STATIC_LIBS) | $(BINARY_BASE)
	@echo [LD] $@
	$(AT)$(CXX) $(CXX_FLAGS) $(TGT_OBJS) $(STATIC_LIBS) $(LINK_FLAGS) -o $(TGT_APP)

$(TGT_OBJS): $(BUILD_BASE)/%.o: $(SOURCE_BASE)/% | $(BLD_DIRS)
	@echo [CC] $<
	$(AT)$(CXX) $(CXX_FLAGS) $(HDR_INC) -MD -MP -c -o $@ $<

$(TST_APP): $(TST_UNIT_OBJS) $(TST_DEPS_OBJS) $(STATIC_LIBS) | $(BINARY_BASE)
ifneq ($(wildcard $(GTEST_MAIN)),)
	@echo [LD] $@
	$(AT)$(CXX) $(CXX_FLAGS) $(TST_UNIT_OBJS) $(TST_DEPS_OBJS) $(GTEST_MAIN) $(STATIC_LIBS) $(LINK_FLAGS) -o $(TST_APP) -lpthread
else
	@echo -n
endif

$(TST_UNIT_OBJS): $(BUILD_BASE)/%.o: $(SOURCE_BASE)/% | $(BLD_DIRS)
ifneq ($(wildcard $(GTEST_MAIN)),)
	@echo [CC] $<
	$(AT)$(CXX) $(CXX_FLAGS) $(HDR_INC) -I$(GTEST_BASE)/include -MD -MP -c -o $@ $<
else
	@echo -n
endif

check: test
ifneq ($(wildcard $(GTEST_MAIN)),)
ifneq ($(wildcard $(GTEST_PARALLEL_RUN)),)
	@$(GTEST_PARALLEL_RUN) $(TST_APP)
else
	@$(TST_APP)
endif
else
	@echo -n
endif

checkm: test
ifneq ($(wildcard $(GTEST_MAIN)),)
	@valgrind --log-fd=1 --leak-check=full --show-reachable=yes --track-origins=yes --track-fds=yes $(TST_APP)
else
	@echo -n
endif

clean:
ifeq ($(SOURCE_BASE), $(BUILD_BASE))
	@echo "Awwww, clean will destroy your source if you build in the same spot!"
	false
endif
ifeq ($(SOURCE_BASE), $(BINARY_BASE))
	@echo "Awwww, clean will destroy your source if you build in the same spot!"
	false
endif
	$(AT)rm -rf $(BUILD_BASE) $(BINARY_BASE)

count:
	@echo "lines words bytes file"
	@wc $(ALL_SRCS) $(ALL_HDRS) | sort -n -k1
	@echo "files : "$(shell echo $(ALL_SRCS) $(ALL_HDRS) | wc -w)
	@echo "commits : "$(shell git rev-list HEAD --count)

-include $(ALL_DEPS)
