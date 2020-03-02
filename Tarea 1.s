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
		;		===============================================================================
		
		
		;		================================================================================
		;		LFSR
		;		The bits that will be considered are the least significant ones
		;		================================================================================
		;		-------------------------------- INITIALIZATIONS -------------------------------
		MOV		R3, #0x200				; Number saving address initialization
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
		MOV		R5, #0x300				; Request address initialization
		MOV		R6, #0x304				; Response address initialization
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
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
