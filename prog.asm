; Calculate the Fibonacci number of a given input
; fib(n) = fib(n-1) + fib(n-2)

; function calling conventions
; inputs: rdi, rsi, rdx, rcx, r8, r9
; return: rax

; +------+-------------+-----------------+-----------------+--------------+------+-----+-----+
; | %rax | System call |      %rdi       |      %rsi       |     %rdx     | %r10 | %r8 | %r9 |
; +------+-------------+-----------------+-----------------+--------------+------+-----+-----+
; |    0 | sys_read    | unsigned int fd | char *buf       | size_t count |      |     |     |
; |    1 | sys_write   | unsigned int fd | const char *buf | size_t count |      |     |     |
; |   60 | sys_exit    | int error_code  |                 |              |      |     |     |
; +------+-------------+-----------------+-----------------+--------------+------+-----+-----+

; +---------+---------+---------+--------------+-------------+--------------------+
; | 64-bit  | 32-bit  | 16-bit  | 8 high bits  | 8 low bits  |    Description     |
; +---------+---------+---------+--------------+-------------+--------------------+
; | RAX     | EAX     | AX      | AH           | AL          | Accumulator        |
; | RBX     | EBX     | BX      | BH           | BL          | Base               |
; | RCX     | ECX     | CX      | CH           | CL          | Counter            |
; | RDX     | EDX     | DX      | DH           | DL          | Data               |
; | RSI     | ESI     | SI      | N/A          | SIL         | Source             |
; | RDI     | EDI     | DI      | N/A          | DIL         | Destination        |
; | RSP     | ESP     | SP      | N/A          | SPL         | Stack Pointer      |
; | RBP     | EBP     | BP      | N/A          | BPL         | Stack Base Pointer |
; +---------+---------+---------+--------------+-------------+--------------------+

; ASCII table:
; +-----+-----+-----+---------------------------+
; | Oct | Dec | Hex |           Char            |
; +-----+-----+-----+---------------------------+
; | 000 |   0 | 00  | NUL '\0' (null character) |
; | 012 |  10 | 0A  | LF '\n' (new line)        |
; | 060 |  48 | 30  | 0 160                     |
; | 061 |  49 | 31  | 1 161                     |
; | 062 |  50 | 32  | 2 162                     |
; | 063 |  51 | 33  | 3 163                     |
; | 064 |  52 | 34  | 4 164                     |
; | 065 |  53 | 35  | 5 165                     |
; | 066 |  54 | 36  | 6 166                     |
; | 067 |  55 | 37  | 7 167                     |
; | 070 |  56 | 38  | 8 170                     |
; | 071 |  57 | 39  | 9 171                     |
; +-----+-----+-----+---------------------------+

extern printf

section .data

	SYS_EXIT	equ	60		; syscall number for exit (0x3c)
	SYS_WRITE	equ 1		; syscall number for write
	SYS_READ	equ 0		; syscall number for read
	STDIN		equ 0		; stdin file descriptor
	STDOUT		equ 1		; stdout file descriptor

	msg1	db		"Enter  a number: ", 0
	msg1len	equ		$-msg1-1		; string length, minus NULL
	msg2	db		"Fib(n) = ", 0
	msg2len	equ		$-msg2-1		; string length, minus NULL

	bufsize	equ	10			; length of input buffer
	
	FIB_0	db	0			; fib(0) = 0
	FIB_1	db	1			; fib(1) = 1
							; ...
							; fib(2) = fib(1) + fib(0) = 1
							; fib(3) = fib(2) + fib(1) = fib(1) + fib(0) + 1 = 1 + 0 + 1 = 2
							; fib(4) = fib(3) + fib(2) = 2 + 1 = 3 
							; fib(n) = fib(n-1) + fib(n-2)

	fmt		db	"Fib(n)=%ld", 10, 0

section .bss
	buffer	resb	bufsize+1		; provide space for ending 0
	fib		resb	1

section .text
	global main

	main:

		push	rbp
		mov		rbp, rsp

		; write to stdout
		mov		rsi, msg1			; address of string
		mov		rdx, msg1len		; length of string
		call	fn_write

		; read stdin
		mov		rsi, buffer			; address of buffer
		mov		rdx, bufsize		; length of buffer
		call	fn_read



		; Convert string of numbers to integer
		; Input:
		;	rsi points to the string of numbers
		; Output:
		;	rcx contains the integer representation
		; Modifies:
		;	rcl
		xor		rbx, rbx			; clear rbx, to store the decimal part
		xor		rcx, rcx			; clear rcx, to store the final number
		mov		r8,	0x0A			; base 10

		_init:
			; Input rsi points to string
			; Output rax contains length
			; Modifies eax
			call _fn_strlen

			cmp		al, 0
			je		_end

			cmp		al, -1
			je		_err

			mov		rdx, rax
			mov		rax, 0x01

		_base:						; create base 10 position
			dec		dl
			cmp		dl, 0
			jle		_decimal
			imul	rax, r8
			jmp		_base

		_decimal:
			mov		bl, byte [rsi]
			sub		bl, 0x30			; to get integer representation
									; from a char number in ASCII
			mul		rbx				; add the integer part
			add		rcx, rax		; store decimal value

			inc		rsi

			jmp		_init


		_end:
			; Calculate the Fibonacci number 'n'
			; Input:
			;	rdx
			; Output:
			;	rax
			; Modifies:
			;	rdx
			xor		rax, rax			; clear return value
			mov		rdx, rcx			; move 'n' to dl
			call	fn_fib

			; write to stdout
			mov		rdi, fmt
			mov		rsi, rax			; address of string
			xor		rax, rax
			call	printf

			; exit program
			;xor		rdi, rdi			; error code = 0
			;call	_fn_exit

			leave
			ret

		_err:
			mov		rax, 0x01			; error code = 1
			call _fn_exit	

	; Input
	;	rdi contains the return code
	_fn_exit:
		; exit 
		mov		rax, SYS_EXIT		; syscall for exit
		syscall						; call kernel

	; reads from stdin
	; Input rsi -> buffer
	;		rdx = buffer length
	; modifies rax, rdi
	fn_read:
		mov		rax, SYS_READ		; syscall for read
		mov		rdi, STDIN			; stdin file descriptor
		syscall						; execute read(0, buffer, bufsize)
		ret
	
	; write string to stdout
	; Input rsi -> string
	;       rdx = string length
	; Modifies rax, rdi
	fn_write:
		mov		rax, SYS_WRITE		; syscall for write
		mov		rdi, STDOUT			; stdout file descriptor
		syscall						; execute write()
		ret

	; Calculate the Fibonacci number 'n'
	; Input:
	;	rdx
	; Output:
	;	rax
	; Modifies:
	;	rdx
	; push n-1 to stack
	; push n-2 to stack
	fn_fib:
		push	rbp
		mov		rbp, rsp

		cmp		dl, 0				; input == 0 ?
		jne		SKIP1
		add		al, byte [FIB_0]

		leave
		ret

	SKIP1:
		cmp		dl, 1				; input == 1 ?
		jne		SKIP2
		add		al, byte [FIB_1]

		leave
		ret

	SKIP2:
		dec		dl					; calculate n-1
		push	rdx					; store n-1 on the stack

		call	fn_fib				; recursion n-1

		pop		rdx					; load n-1 into rdx
		dec		dl					; calculate n-2

		cmp		dl, 0
		call	fn_fib				; recursion n-2

		leave
		ret


	; Input rsi points to string
	; Output rax contains length.
	; Error, rax returns -1
	_fn_strlen:
		xor		rax, rax			; clear rax

		.loop:

			cmp		BYTE [rsi + rax], 0x0A	; compare with LF '\n'
			je		.break
			cmp		BYTE [rsi + rax], 0x00	; compare with NUL '\0'
			je		.break
			cmp		BYTE [rsi + rax], 0x30	; compare with num. 0
			jl		.error
			cmp		BYTE [rsi + rax], 0x39	; compare with num. 9
			jg		.error

			inc		rax

			jmp		.loop

		.break:
			ret 

		.error:
			xor		rax, rax			; set to 0 (all 0s)
			not		rax					; invert (all 1s)
			ret
