# Makefile for FFT

TARGET = fft_main
OBJ = fft_main.o fft.o

INPUT = fft.in
GEN_OBJ = input_gen.o
GEN_SRC = inout/input_gen.cpp

HPATH = inc/
SPATH = src/

all: $(TARGET)

$(TARGET): $(OBJ)
	g++ -o fft_main $(OBJ)

fft.o: $(HPATH)fft.hpp $(SPATH)fft.cpp
	g++ -I $(HPATH) -c $(SPATH)fft.cpp

fft_main.o: $(SPATH)fft_main.cpp
	g++ -I $(HPATH) -c $(SPATH)fft_main.cpp

input_gen: $(INPUT)
	
$(INPUT): $(GEN_OBJ)
	g++ -o input_gen $(GEN_OBJ)
	./input_gen

$(GEN_OBJ): $(GEN_SRC)
	g++ -c $(GEN_SRC)
	
clean:
	rm -f *.o $(TARGET)

