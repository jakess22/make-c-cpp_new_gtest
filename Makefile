all:
	git submodule init
	git submodule update
	cd gtest/make && $(MAKE) gtest_main.a
