# $@ = target file
# $< = first dependency
# $^ = all dependencies

binary=prog

# First rule is the one executed when no parameters are fed to the Makefile
#all: run

#run: prog
#	./$<

#run: prog
#	qemu-system-x86_64 -fda $<
#
prog: prog.o
#	ld -o $@ $<
	gcc -Wall -no-pie -z noexecstack -o $@ $<

prog.o: prog.asm
	nasm -f elf64 -g -F dwarf $<

.PHONY: clean

clean:
	$(RM) $(binary) *.o
