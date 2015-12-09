#Makefile for FFT Testbench

TARGET = tb_main
OBJ = bit_revise.o tb_main.o

HPATH = inc/
SPATH = src/

all: $(TARGET)

$(TARGET) : $(OBJ)
	g++ -o tb_main $(OBJ)
	./tb_main

tb_main.o : $(SPATH)tb_main.cpp
	g++ -I $(HPATH) -c $(SPATH)tb_main.cpp

bit_revise.o : $(HPATH)bit_revise.hpp $(SPATH)bit_revise.cpp
	g++ -I $(HPATH) -c $(SPATH)bit_revise.cpp

clean:
	rm -f *.o $(TARGET)

