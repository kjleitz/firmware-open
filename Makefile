SRC=$(wildcard src/*.c)
INCLUDE=$(wildcard src/include/*.h)
OBJ=$(patsubst src/%.c,build/%.rel,$(SRC))

all: build/ec.rom

clean:
	rm -rf build

sim: build/ec.rom
	cargo run \
		--release \
		--manifest-path ecsim/Cargo.toml \
		--no-default-features \
		-- $<

build/ec.rom: build/ec.ihx
	mkdir -p build
	makebin -p < $< > $@

build/ec.ihx: $(OBJ)
	mkdir -p build
	sdcc -mmcs51 -o $@ $^

build/%.rel: src/%.c $(INCLUDE)
	mkdir -p build
	cd build && \
	sdcc -mmcs51 -c ../$<