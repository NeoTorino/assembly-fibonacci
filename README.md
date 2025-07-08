# Fibonacci Calculator - x86-64 Assembly

A command-line program written in x86-64 assembly that calculates Fibonacci numbers using recursive implementation.

## Overview

This program demonstrates low-level programming concepts including:
- x86-64 assembly language programming
- System calls for I/O operations
- Recursive function implementation
- String to integer conversion
- Stack frame management

## Files

- `prog.asm` - Main assembly source code
- `Makefile` - Build configuration
- `README.md` - This documentation

## Requirements

- **Operating System**: Linux (x86-64)
- **Assembler**: NASM (Netwide Assembler)
- **Linker**: GCC
- **Make**: GNU Make utility

### Installation on Ubuntu/Debian
```bash
sudo apt update
sudo apt install nasm gcc make
```

### Installation on Red Hat/CentOS/Fedora
```bash
sudo yum install nasm gcc make
# or for newer versions:
sudo dnf install nasm gcc make
```

## Building

Use the provided Makefile to build the program:

```bash
make
```

This will:
1. Assemble `prog.asm` into `prog.o` using NASM
2. Link the object file with GCC to create the executable `prog`

## Usage

Run the program:
```bash
./prog
```

The program will prompt you to enter a number and then display the corresponding Fibonacci number.

### Example
```
Enter a number: 10
Fib(n)=55
```

## Algorithm

The program implements the classic recursive Fibonacci algorithm:
- `fib(0) = 0`
- `fib(1) = 1`
- `fib(n) = fib(n-1) + fib(n-2)` for n > 1

## Program Structure

### Main Components

1. **Input Handling**
   - Prompts user for input
   - Reads from stdin using system calls
   - Converts ASCII string to integer

2. **Fibonacci Calculation**
   - Recursive implementation in `fn_fib`
   - Base cases for n=0 and n=1
   - Proper stack frame management

3. **Output**
   - Uses `printf` for formatted output
   - Displays result with "Fib(n)=" prefix

### Key Functions

- `fn_read` - Read input from stdin
- `fn_write` - Write output to stdout
- `fn_fib` - Recursive Fibonacci calculation
- `_fn_strlen` - Calculate string length with validation
- `_fn_exit` - Clean program termination

## Technical Details

### Calling Conventions
- Uses System V AMD64 ABI
- Function parameters: `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`
- Return value: `rax`

### System Calls Used
- `sys_read` (0) - Read from stdin
- `sys_write` (1) - Write to stdout
- `sys_exit` (60) - Exit program

### Memory Layout
- `.data` section: Constants and messages
- `.bss` section: Uninitialized buffers
- `.text` section: Program code

## Limitations

1. **Input Validation**: Only accepts numeric input (0-9)
2. **Buffer Size**: Input limited to 10 characters
3. **Performance**: Recursive implementation has exponential time complexity
4. **Range**: Limited by register size and stack depth

## Error Handling

- Invalid characters in input return error code 1
- Input validation checks for digits only
- Proper stack cleanup on all exit paths

## Cleaning Up

Remove generated files:
```bash
make clean
```

This removes the executable and object files.

## Educational Value

This program demonstrates:
- Assembly language syntax and structure
- System call interface
- Function calling conventions
- Stack management
- Recursive algorithms in assembly
- String processing at the byte level

## Performance Notes

The recursive implementation has O(2^n) time complexity, making it inefficient for large numbers. For educational purposes, this showcases the overhead of function calls and stack management in assembly language.

## Modifications

To extend this program, you could:
- Implement iterative Fibonacci calculation
- Add support for larger numbers (64-bit arithmetic)
- Implement memoization for better performance
- Add more robust error handling
- Support negative numbers or floating-point input

## License

This is educational code provided for learning purposes.
