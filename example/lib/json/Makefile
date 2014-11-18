libjson.a:
	@echo [CC] $@
	@g++-4.8 -Wall -Wextra -pedantic -Wfatal-errors -std=c++11 -O3 -march=native -flto -c -o json.o json.cpp
	@echo [AR] $@
	@ar rvc libjson.a json.o
	@rm json.o

clean:
	rm -f json.o libjson.a
