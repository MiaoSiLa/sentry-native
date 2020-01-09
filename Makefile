all: test

update-test-discovery:
	@perl -ne 'print if s/SENTRY_TEST\(([^)]+)\)/XX(\1)/' tests/*.c | sort | uniq > tests/tests.inc
.PHONY: update-test-discovery

build/Makefile: CMakeLists.txt
	@mkdir -p build
	@cd build; cmake ..

build: build/Makefile
	@$(MAKE) -C build
.PHONY: build

test: build update-test-discovery
	@./build/sentry_tests
.PHONY: test

test-leaks: build update-test-discovery
	@ASAN_OPTIONS=detect_leaks=1 ./build/sentry_tests
.PHONY: test-leaks

clean: build/Makefile
	@$(MAKE) -C build clean
.PHONY: clean

format:
	@clang-format -i src/*.c src/*.h src/*/*.c src/*/*.h tests/*.c tests/*.h
.PHONY: format
