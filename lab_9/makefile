.PHONY: m80387 mno80387 asm run clean

m80387:
	gcc test_cpp.cpp -m80387 -DM -O0 -o test_m.exe
	./test_m.exe
	
mno80387:
	gcc test_cpp.cpp -mno-80387 -O0 -o test_mno.exe
	./test_mno.exe

asm:
	gcc test_asm.cpp -masm=intel -O0 -o test_asm.exe
	./test_asm.exe


run: m80387 mno80387 asm

disasm:
	gcc -c test_cpp.cpp -m80387 -O0 -o test_m.o
	gcc -c test_cpp.cpp -mno-80387 -DMNO -O0 -o test_mno.o
	objdump -d test_m.o > test_m.txt
	objdump -d test_mno.o > test_mno.txt

clean:
	rm -rf *.o *.txt *.exe
