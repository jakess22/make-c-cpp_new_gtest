# Copyright (c) 2014, Grant Ayers
# All rights reserved.
#
# license available at https://raw.github.com/grantea/makefiles/master/LICENSE
#
# THIS FILE SHOULD NOT BE ALTERED !!!

TGT_APP := $(BINARY_BASE)/$(PROGRAM_NAME)
TST_APP := $(BINARY_BASE)/$(PROGRAM_NAME)$(TEST_SUFFIX)

HDR_INC := -I$(SOURCE_BASE) -I$(LIBRARY_BASE)
LIBS := $(foreach EXT, $(LIB_EXTS), $(shell find $(LIBRARY_BASE) -type f -iname "*$(EXT)"))

ALL_SRCS := $(foreach EXT, $(SRC_EXTS), $(shell find $(SOURCE_BASE) -type f -iname "*$(EXT)"))
ALL_HDRS := $(foreach EXT, $(HDR_EXTS), $(shell find $(SOURCE_BASE) -type f -iname "*$(EXT)"))
ALL_DEPS := $(patsubst $(SOURCE_BASE)%, $(BUILD_BASE)%.d, $(ALL_SRCS))
ALL_OBJS := $(patsubst $(SOURCE_BASE)%, $(BUILD_BASE)%.o, $(ALL_SRCS))

TST_UNIT_SRCS := $(foreach EXT, $(SRC_EXTS), $(shell find $(SOURCE_BASE) -type f -iname "*$(TEST_SUFFIX)$(EXT)"))
TST_UNIT_DEPS := $(patsubst $(SOURCE_BASE)%, $(BUILD_BASE)%.d, $(TST_UNIT_SRCS))
TST_UNIT_OBJS := $(patsubst $(SOURCE_BASE)%, $(BUILD_BASE)%.o, $(TST_UNIT_SRCS))

TGT_SRCS := $(filter-out $(TST_UNIT_SRCS), $(ALL_SRCS))
TGT_DEPS := $(patsubst $(SOURCE_BASE)%, $(BUILD_BASE)%.d, $(TGT_SRCS))
TGT_OBJS := $(patsubst $(SOURCE_BASE)%, $(BUILD_BASE)%.o, $(TGT_SRCS))

TST_DEPS_SRCS := $(filter-out $(MAIN_FILE), $(TGT_SRCS))
TST_DEPS_DEPS := $(patsubst $(SOURCE_BASE)%, $(BUILD_BASE)%.d, $(TST_DEPS_SRCS))
TST_DEPS_OBJS := $(patsubst $(SOURCE_BASE)%, $(BUILD_BASE)%.o, $(TST_DEPS_SRCS))

SRC_DIRS := $(shell find $(SOURCE_BASE) -type d -print)
BLD_DIRS := $(patsubst $(SOURCE_BASE)/%, $(BUILD_BASE)/%, $(SRC_DIRS))

LIBS := $(foreach EXT, $(LIB_EXTS), $(shell find $(LIBRARY_BASE) -type f -iname "*$(EXT)"))
LIB_INC := $(patsubst %, -L%, $(dir $(LIBS)))
LINK_FLAGS += $(foreach LIB, $(LIBS), $(patsubst %, -l%, $(shell echo $(LIB) | sed -e 's@.*/lib@@g' -e 's@\..*@@g')))

OPTS := $(CXX_LANG) $(CXX_OPT)

.PHONY: app all test clean list count

app: $(TGT_APP)

all: app test

$(BINARY_BASE):
	@mkdir -p $@

$(BLD_DIRS):
	@mkdir -p $@

$(TGT_APP): $(TGT_OBJS) | $(BINARY_BASE)
	@echo [LD] $@
	@$(CXX) $(OPTS) $(TGT_OBJS) $(LIB_INC) $(LINK_FLAGS) -o $(TGT_APP)

$(TGT_OBJS): $(BUILD_BASE)/%.o: $(SOURCE_BASE)/% | $(BLD_DIRS)
	@echo [CC] $<
	@$(CXX) $(OPTS) $(HDR_INC) -MD -MP -c -o $@ $<

$(TST_APP): $(TST_UNIT_OBJS) $(TST_DEPS_OBJS) | $(BINARY_BASE)
	@echo [LD] $@
	@$(CXX) $(OPTS) $(TST_UNIT_OBJS) $(TST_DEPS_OBJS) $(LIB_INC) $(GTEST_BASE)/make/gtest_main.a $(LINK_FLAGS) -o $(TST_APP) -lpthread

$(TST_UNIT_OBJS): $(BUILD_BASE)/%.o: $(SOURCE_BASE)/% | $(BLD_DIRS)
	@echo [CC] $<
	$(CXX) $(OPTS) $(HDR_INC) -I$(GTEST_BASE)/include -MD -MP -c -o $@ $<

test: $(TST_APP)
	@./$(TST_APP)

clean:
ifeq ($(SOURCE_BASE), $(BUILD_BASE))
	rm -f $(ALL_DEPS) $(ALL_OBJS) $(TGT_APP) $(TST_APP)
else
	rm -rf $(BUILD_BASE) $(TGT_APP) $(TST_APP)
endif

list:
	@echo "### SRC_DIRS ###"
	echo $(SRC_DIRS)
	@echo "### BLD_DIRS ###"
	echo $(BLD_DIRS)
	@echo "### ALL_SRCS ###"
	echo $(ALL_SRCS)
	@echo "### TGT_SRCS ###"
	echo $(TGT_SRCS)
	@echo "### TST_UNIT_SRCS ###"
	echo $(TST_UNIT_SRCS)
	@echo "### TST_DEPS_SRCS ###"
	echo $(TST_DEPS_SRCS)
	@echo "### TGT_APP ###"
	echo $(TGT_APP)
	@echo "### TST_APP ###"
	echo $(TST_APP)

count:
	@echo "lines words bytes file"
	@wc $(ALL_SRCS) $(ALL_HDRS) | sort -n -r -k1
	@echo "number of source files:"
	@wc $(ALL_SRCS) $(ALL_HDRS) | tail -n+2 | wc -l
	@echo "number of git commits:"
	@git rev-list HEAD --count

-include $(ALL_DEPS)
