# Copyright (c) 2014, Nic McDonald
# All rights reserved.
#
# license available at https://raw.github.com/nicmcd/make-c-cpp/master/LICENSE
#
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

.PHONY: all lint app test clean count updatemk

all: $(LINT_OUT) app test

app: $(TGT_APP)

lint: $(LINT_OUT)

test: $(TST_APP)

$(BINARY_BASE):
	@mkdir -p $@

$(BLD_DIRS):
	@mkdir -p $@

$(LINT_OUT): $(ALL_SRCS) $(ALL_HDRS) | $(BUILD_BASE)
ifneq ($(wildcard $(LINT)),)
	@echo [LINT]
	@python $(LINT) $(LINT_FLAGS) $(ALL_SRCS) $(ALL_HDRS)
	@echo "linted" > $(LINT_OUT)
else
	@echo -n
endif

$(TGT_APP): $(TGT_OBJS) $(STATIC_LIBS) | $(BINARY_BASE)
	@echo [LD] $@
	@$(CXX) $(CXX_FLAGS) $(TGT_OBJS) $(STATIC_LIBS) $(LINK_FLAGS) -o $(TGT_APP)

$(TGT_OBJS): $(BUILD_BASE)/%.o: $(SOURCE_BASE)/% | $(BLD_DIRS)
	@echo [CC] $<
	@$(CXX) $(CXX_FLAGS) $(HDR_INC) -MD -MP -c -o $@ $<

$(TST_APP): $(TST_UNIT_OBJS) $(TST_DEPS_OBJS) $(STATIC_LIBS) | $(BINARY_BASE)
ifneq ($(wildcard $(GTEST_MAIN)),)
	@echo [LD] $@
	@$(CXX) $(CXX_FLAGS) $(TST_UNIT_OBJS) $(TST_DEPS_OBJS) $(GTEST_MAIN) $(STATIC_LIBS) $(LINK_FLAGS) -o $(TST_APP) -lpthread
else
	@echo -n
endif

$(TST_UNIT_OBJS): $(BUILD_BASE)/%.o: $(SOURCE_BASE)/% | $(BLD_DIRS)
ifneq ($(wildcard $(GTEST_MAIN)),)
	@echo [CC] $<
	@$(CXX) $(CXX_FLAGS) $(HDR_INC) -I$(GTEST_BASE)/include -MD -MP -c -o $@ $<
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
	rm -rf $(BUILD_BASE) $(BINARY_BASE)

count:
	@echo "lines words bytes file"
	@wc $(ALL_SRCS) $(ALL_HDRS) | sort -n -k1
	@echo "number of source files: "$(shell wc $(ALL_SRCS) | tail -n+2 | wc -l)
	@echo "number of header files: "$(shell wc $(ALL_HDRS) | tail -n+2 | wc -l)
	@echo "number of total files : "$(shell wc $(ALL_SRCS) $(ALL_HDRS) | tail -n+2 | wc -l)
	@echo "number of git commits : "$(shell git rev-list HEAD --count)

updatemk:
	wget https://raw.githubusercontent.com/nicmcd/make-c-cpp/master/auto_bin.mk -O auto_bin.mk

-include $(ALL_DEPS)
