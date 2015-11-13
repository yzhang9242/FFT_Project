# Makefile for FFT

TARGET = fft_main
OBJ = fft_main.o fft.o

HPATH = inc/
SPATH = src/

all: $(TARGET)

$(TARGET): $(OBJ)
	g++ -o fft_main $(OBJ)

fft.o: $(HPATH)fft.hpp $(SPATH)fft.cpp
	g++ -I $(HPATH) -c $(SPATH)fft.cpp

fft_main.o: $(SPATH)fft_main.cpp
	g++ -I $(HPATH) -c $(SPATH)fft_main.cpp

clean:
	rm -f *.o $(TARGET)

