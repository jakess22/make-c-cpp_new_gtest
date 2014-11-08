# Copyright (c) 2014, Grant Ayers, Nic McDonald
# All rights reserved.
#
# license available at https://raw.github.com/grantea/makefiles/master/LICENSE
# license available at https://raw.github.com/nicmcd/make-c-cpp/master/LICENSE
#
# THIS FILE SHOULD NOT BE ALTERED !!!

TGT_APP := $(BINARY_BASE)/$(PROGRAM_NAME)
TST_APP := $(BINARY_BASE)/$(PROGRAM_NAME)$(TEST_SUFFIX)

HDR_INC := -I$(SOURCE_BASE) -I$(LIBRARY_BASE)

ALL_SRCS := $(filter-out $(IGNORE_FILES),$(foreach EXT,$(SRC_EXTS),$(shell find $(SOURCE_BASE) -type f -iname "*$(EXT)")))
ALL_HDRS := $(filter-out $(IGNORE_FILES),$(foreach EXT,$(HDR_EXTS),$(shell find $(SOURCE_BASE) -type f -iname "*$(EXT)")))
ALL_DEPS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.d,$(ALL_SRCS))
ALL_OBJS := $(patsubst $(SOURCE_BASE)%,$(BUILD_BASE)%.o,$(ALL_SRCS))

TST_UNIT_SRCS := $(filter-out $(IGNORE_FILES),$(foreach EXT,$(SRC_EXTS),$(shell find $(SOURCE_BASE) -type f -iname "*$(TEST_SUFFIX)$(EXT)")))
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

LIBS := $(filter-out $(IGNORE_FILES),$(foreach EXT,$(LIB_EXTS),$(shell find $(LIBRARY_BASE) -type f -iname "*$(EXT)")))
LIB_INC := $(patsubst %, -L%, $(dir $(LIBS)))
LINK_FLAGS += $(foreach LIB,$(LIBS),$(patsubst %,-l%,$(shell echo $(LIB) | sed -e 's@.*/lib@@g' -e 's@\..*@@g')))

ALL_EXTS := $(shell echo $(SRC_EXTS) $(HDR_EXTS) | tr " " , | tr -d .)
LINT_FLAGS += --root=$(SOURCE_BASE) --extensions=$(ALL_EXTS)

GTEST_MAIN := $(GTEST_BASE)/make/gtest_main.a

OPTS := $(CXX_LANG) $(CXX_OPT)

.PHONY: all app lint test main_check clean count updatemk showlibs

all: app

lint:
ifneq ($(wildcard $(LINT)),)
	@echo [LINT]
	@python $(LINT) $(LINT_FLAGS) $(ALL_SRCS) $(ALL_HDRS)
else
	@echo -n
endif

app: $(TGT_APP)

test: $(TST_APP)

main_check:
	@if [ ! -e $(MAIN_FILE) ]; then echo >&2 "Main file '$(MAIN_FILE)' does not exist"; false; fi

$(BINARY_BASE):
	@mkdir -p $@

$(BLD_DIRS):
	@mkdir -p $@

$(TGT_APP): main_check $(TGT_OBJS) | $(BINARY_BASE)
	@echo [LD] $@
	@$(CXX) $(OPTS) $(TGT_OBJS) $(LIB_INC) $(LINK_FLAGS) -o $(TGT_APP)

$(TGT_OBJS): $(BUILD_BASE)/%.o: $(SOURCE_BASE)/% | $(BLD_DIRS)
	@echo [CC] $<
	@$(CXX) $(OPTS) $(HDR_INC) -MD -MP -c -o $@ $<

$(TST_APP): main_check $(TST_UNIT_OBJS) $(TST_DEPS_OBJS) | $(BINARY_BASE)
ifneq ($(wildcard $(GTEST_MAIN)),)
	@echo [LD] $@
	@$(CXX) $(OPTS) $(TST_UNIT_OBJS) $(TST_DEPS_OBJS) $(LIB_INC) $(GTEST_MAIN) $(LINK_FLAGS) -o $(TST_APP) -lpthread
else
	@echo -n
endif

$(TST_UNIT_OBJS): $(BUILD_BASE)/%.o: $(SOURCE_BASE)/% | $(BLD_DIRS)
ifneq ($(wildcard $(GTEST_MAIN)),)
	@echo [CC] $<
	@$(CXX) $(OPTS) $(HDR_INC) -I$(GTEST_BASE)/include -MD -MP -c -o $@ $<
else
	@echo -n
endif

clean:
ifeq ($(SOURCE_BASE), $(BUILD_BASE))
	rm -f $(ALL_DEPS) $(ALL_OBJS) $(TGT_APP) $(TST_APP)
else
	rm -rf $(BUILD_BASE) $(TGT_APP) $(TST_APP)
endif

count:
	@echo "lines words bytes file"
	@wc $(ALL_SRCS) $(ALL_HDRS) | sort -n -k1
	@echo "number of source files: "$(shell wc $(ALL_SRCS) | tail -n+2 | wc -l)
	@echo "number of header files: "$(shell wc $(ALL_HDRS) | tail -n+2 | wc -l)
	@echo "number of total files : "$(shell wc $(ALL_SRCS) $(ALL_HDRS) | tail -n+2 | wc -l)
	@echo "number of git commits : "$(shell git rev-list HEAD --count)

updatemk:
	wget https://raw.githubusercontent.com/nicmcd/make-c-cpp/master/auto.mk -O auto.mk

showlibs:
	@echo $(LIBS)
	@echo $(LIB_INC)
	@echo $(LINK_FLAGS)

-include $(ALL_DEPS)
