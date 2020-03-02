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
		;		---------------------------------- CONSTANTS ----------------------------------
		;		R10: Seed - Eduardo Moya ("y") -> #121
		;		R11: Counter - Counts how many numbers must create the LFSR -> #20
		;		---------------------------------- VARIABLES ----------------------------------
		;		R1: Copy of the seed used to extract bits (used as XOR_IN_1)
		;		R2: XOR_IN_2
		;		R12: Number saving address
		;		===============================================================================
		
		
		;		================================================================================
		;		LFSR
		;		The bits that will be considered are the least significant ones
		;		================================================================================
		;		----------------------------- CONSTANTS DEFINITION -----------------------------
		MOV		R10, #121					; Seed initialization
		MOV		R11, #20					; Counter initialization
		MOV		R12, #0x200				; Number saving address initialization
		;		------------------------------------- LFSR -------------------------------------
LFSR
		MOV		R1, R10					; Initialize seed copy (XOR_IN_1) | LSB = BIT_8
		LSR		R2, R1, #2				; XOR_IN_2 (LSB) = [BIT_6]
		EOR		R2, R1, R2				; XOR_IN_2 = [BIT_8 XOR BIT_6] = X1
		LSR		R1, R1, #3				; XOR_IN_1 (LSB) = BIT_5
		EOR		R2, R1, R2				; XOR_IN_2 = [BIT_5 XOR X1] = X2
		LSR		R1, R1, #1				; XOR_IN_1 (LSB) = BIT_4
		EOR		R2, R1, R2				; XOR_IN_2 = [BIT_4 XOR X2] = X3
		AND		R2, R2, #1				; Extract new bit
		LSL		R2, R2, #7				; MSB of new number
		LSR		R10, R10, #1				; Get seed bits 7:1
		ADD		R10, R10, R2				; Generate new seed
		;		===============================================================================
		
		
		
		;		===============================================================================
		;		SAVING, UPDATING AND EVALUATION OF STOP CONDITION
		;		===============================================================================
		;		---------------------------------- SAVE WORD -----------------------------------
		STR		R10, [R12]				; Store new seed in memory
		;		------------------------------- UPDATE VARIABLES -------------------------------
		ADD		R12, R12, #4				; Next address in memory
		SUB		R11, R11, #1				; Update the counter
		;		-------------------------------- STOP CONDTION ---------------------------------
		CMP		R11, #0
		BNE		LFSR
		
		
































		