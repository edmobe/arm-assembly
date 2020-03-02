			;		===============================================================================
			;		Tecnológico de Costa Rica
			;		CE4301: Computer Architecture I
			;		First Homework: Assembly programming in ARM
			;		Teacher: Luis Chavarría Zamora
			;		Made by: Eduardo Moya Bello
			;		Date: March 6, 2020
			;		===============================================================================
			
			
			
			
			;		===============================================================================
			;		REGISTERS
			;		===============================================================================
			;		------------------------------- LFSR VARIABLES --------------------------------
			;		R0: Seed - Eduardo Moya ("y") -> #121
			;		R1: Copy of the seed used to extract bits (used as XOR_IN_1)
			;		R2: XOR_IN_2
			;		R3: Number saving address
			;		R4: Counter - Counts how many numbers must create the LFSR -> #20
			;		----------------------------- INTERFACE VARIABLES -----------------------------
			;		R5: Request address -> 0x300
			;		R6: Request response address -> 0x304
			;		R7: Operation codes -> 0xF0 for request and 0xFF for response
			;		-------------------------- PRIME NUMBERS AND MODULO ---------------------------
			;		Modulo is used as N % D = M
			;		R1: Iteration variable [N:0] bits (in this case, 8 bits -> N = 7)
			;		R2: R9 copy
			;		R8: Primal analysis will be applied to this number
			;		R9:
			;		- Divisible by 2: Flag that indicates if number is odd
			;		- Other cases: N
			;		R10: D
			;		R11: M and primality test result
			;		R12: Number retrieving address
			;		===============================================================================
			
			
			
			
			;		================================================================================
			;		LFSR (The bits that will be considered are the least significant ones)
			;		================================================================================
			;		-------------------------------- INITIALIZATIONS -------------------------------
			MOV		R3, #0x1200				; Number saving address initialization
			MOV		R0, #121					; Seed initialization
			MOV		R4, #20					; Counter initialization
			;		------------------------------------- LFSR -------------------------------------
LFSR
			MOV		R1, R0					; Initialize seed copy (XOR_IN_1) | LSB = BIT_8
			LSR		R2, R1, #2				; XOR_IN_2 (LSB) = [BIT_6]
			EOR		R2, R1, R2				; XOR_IN_2 = [BIT_8 XOR BIT_6] = X1
			LSR		R1, R1, #3				; XOR_IN_1 (LSB) = BIT_5
			EOR		R2, R1, R2				; XOR_IN_2 = [BIT_5 XOR X1] = X2
			LSR		R1, R1, #1				; XOR_IN_1 (LSB) = BIT_4
			EOR		R2, R1, R2				; XOR_IN_2 = [BIT_4 XOR X2] = X3
			AND		R2, R2, #1				; Extract new bit
			LSL		R2, R2, #7				; MSB of new number
			LSR		R0, R0, #1				; Get seed bits 7:1
			ADD		R0, R0, R2				; Generate new seed
			;		===============================================================================
			
			
			
			
			;		===============================================================================
			;		SAVING, UPDATING AND EVALUATION OF STOP CONDITION
			;		===============================================================================
			;		---------------------------------- SAVE WORD -----------------------------------
			STR		R0, [R3]					; Store new seed in memory
			;		------------------------------- UPDATE VARIABLES -------------------------------
			ADD		R3, R3, #4				; Next address in memory
			SUB		R4, R4, #1				; Update the counter
			;		-------------------------------- STOP CONDTION ---------------------------------
			CMP		R4, #0					; If the counter is not zero yet
			BNE		LFSR						; Repeat the process
			;		===============================================================================
			
			
			
			
			;		===============================================================================
			;		COMPUTER INTERFACE
			;		===============================================================================
			;		-------------------------------- DECLARATIONS ---------------------------------
			MOV		R5, #0x1300				; Request address initialization
			ADD		R6, R5, #4				; Response address initialization
			MOV		R7, #0xF0					; First a request must be made
			;		-------------------------------- SEND REQUEST ---------------------------------
			STR		R7, [R5]					; Request code
			;		------------------------ COMPUTER RESPONSE SIMULATION -------------------------
			MOV		R7, #0xFF					; Response code sent by computer
			STR		R7, [R6]					; The computer changes the memory address value
			;		------------------------------ WAIT FOR RESPONSE ------------------------------
RESPONSE
			LDR		R7, [R6]					; Loads value in response memory address
			CMP		R7, #0xFF					; Compares the response code with the expected
			BNE		RESPONSE					; If the code is not the expected, keeps waiting
			;		===============================================================================
			
			
			
			
			;		===============================================================================
			;		PRIMALITY TEST
			;		Only prime numbers below sqrt(256) = 16 are needed to confirm primality
			;		===============================================================================
			;		-------------------------------- INITIALIZATIONS -------------------------------
			MOV		R3, #0x1200				; Number retrieving address initialization
			MOV		R4, #20					; Counter initialization
			MOV		R12, #0x1400				; Number saving address initialization
PRIME_CALC
			;		------------------------------- RETRIEVE NUMBER -------------------------------
			LDR		R8, [R3]					; Get value saved in memory
			;		--------------------- PRIME NUMBER CONDITIONS VALIDATION ----------------------
			CMP		R8, #1					; If its 1 or less
			BLE		NOT_PRIME					; Then it is not prime
			;		------------------------------- DIVISIBLE BY 2 --------------------------------
			CMP		R8, #2					; If the number is 2
			BEQ		PRIME					; Then it is prime
			AND		R9, R8, #1				; Get LSB
			CMP		R9, #0					; If LSB is 0
			BEQ		NOT_PRIME					; Then its not prime
			;		------------------------------- DIVISIBLE BY 3 --------------------------------
			MOV		R10, #3					; Modulo variable D is 3
			MOV		R9, R8					; Copy the value of R8 for modulo variable N
			BL		MODULO					; Apply modulo operation
			;		------------------------------- DIVISIBLE BY 5 --------------------------------
			MOV		R10, #5					; Modulo variable D is 5
			MOV		R9, R8					; Copy the value of R8 for modulo variable N
			BL		MODULO					; Apply modulo operation
			;		------------------------------- DIVISIBLE BY 7 --------------------------------
			MOV		R10, #7					; Modulo variable D is 7
			MOV		R9, R8					; Copy the value of R8 for modulo variable N
			BL		MODULO					; Apply modulo operation
			;		------------------------------- DIVISIBLE BY 11 --------------------------------
			MOV		R10, #11					; Modulo variable D is 11
			MOV		R9, R8					; Copy the value of R8 for modulo variable N
			BL		MODULO					; Apply modulo operation
			;		------------------------------- DIVISIBLE BY 13 --------------------------------
			MOV		R10, #13					; Modulo variable D is 13
			MOV		R9, R8					; Copy the value of R8 for modulo variable N
			BL		MODULO					; Apply modulo operation
			;		------------------------------------ ELSE -------------------------------------
			B		PRIME					; Else, the number is prime
			;		===============================================================================
			
			
			
			
			;		===============================================================================
			;		MODULO OPERATION (USING LONG DIVISION ALGORITHM)
			;		===============================================================================
MODULO
			;		--------------------- INITIAL VALIDATIONS AND DECLARATIONS --------------------
			CMP		R8, R10					; If the number can only be divided by D
			BEQ		PRIME					; Then it is prime
			MOV		R1, #7					; 8 bit data iterator (i)
			MOV		R11, #0					; M = 0
MODULO_LOOP
			LSL		R11, R11, #1				; M := M << 1
			MOV		R2, R9					; Copy the value of N to operate it
			LSR		R2, R2, R1				; Get number value at N
			AND		R2, R2, #1				; Use only LSB
			ADD		R11, R11, R2				; Set M LSB -> M[0] := N[i]
			CMP		R11, R10					; If M < D
			BLT		MODULO_REPEAT				; Verify if a new iteration is needed
			SUB		R11, R11, R10				; M := M - D
MODULO_REPEAT
			SUB		R1, R1, #1				; i--
			CMP		R1, #0					; If i >= 0
			BGE		MODULO_LOOP				; Then repeat the modulo loop
			CMP		R11, #0					; If modulo is 0
			BEQ		NOT_PRIME					; Then, the number is not prime
			MOV		PC, LR					; Else, try again with other divisor
			;		===============================================================================
			
			
			
			
			;		===============================================================================
			;		MODULO OPERATION (USING REPEATED SUBTRACTION ALGORITHM)
			;		===============================================================================
			;MODULO
			;CMP		R8, R10
			;BEQ		PRIME
			;SUB		R9, R9, R10
			;CMP		R9, #0
			;BGE		MODULO
			;ADD		R11, R10, R9
			;CMP		R11, #0
			;BEQ		NOT_PRIME
			;MOV		PC, LR
			;		===============================================================================
			
			
			
			
			;		===============================================================================
			;		SET PRIMALITY RESULT
			;		===============================================================================
			;		----------------------------- FOR PRIME NUMBERS ------------------------------
PRIME
			MOV		R11, #1					; Set prime flag: 1
			B		VALIDATE_CALC
			;		--------------------------- FOR COMPOSITE NUMBERS ----------------------------
NOT_PRIME
			MOV		R11, #0					; Set prime flag: 1
			;		===============================================================================
			
			
			
			
			;		===============================================================================
			;		SAVING, UPDATING AND EVALUATION OF STOP CONDITION
			;		===============================================================================
			;		------------------------------- UPDATE VARIABLES -------------------------------
VALIDATE_CALC
			STR		R11, [R12]				; Save the flag value in memory
			ADD		R3, R3, #4				; Next address in memory reading
			ADD		R12, R12, #4				; Next address in memory writing
			SUB		R4, R4, #1				; Update the counter
			;		-------------------------------- STOP CONDTION ---------------------------------
			CMP		R4, #0					; If the counter is not zero yet
			BNE		PRIME_CALC				; Repeat the process
			END
			;		===============================================================================
			
			
			
			
			
			
			
			
			
			
			
			
			
			
