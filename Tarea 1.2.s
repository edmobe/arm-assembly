		;		===============================================================================
		;		Tecnológico de Costa Rica
		;		CE4301: Computer Architecture I
		;		First Homework: Assembly programming in ARM (part 1)
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
		;		R4: Counter - Counts how many numbers must create the LFSR -> #14
		;		--------------------------------- ENCRYPTION ----------------------------------
		;		R1: Random number of random numbers set
		;		R2: Random number address
		;		R3: Counter - Lenght of the phrase -> #14
		;		R4: Lenght of the phrase saving address -> #0x620
		;		R5: Current character of "Claude Shannon"
		;		R6: Character saving address
		;		===============================================================================
		
		
		
		
		;		================================================================================
		;		LFSR (The bits that will be considered are the least significant ones)
		;		================================================================================
		;		-------------------------------- INITIALIZATIONS -------------------------------
		MOV		R3, #0x300				; Initialize the number saving address
		MOV		R0, #121					; Seed initialization
		MOV		R4, #14					; Counter initialization
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
		;		---------------------------------- SAVE WORD ----------------------------------
		STR		R0, [R3]					; Store new seed in memory
		;		------------------------------- UPDATE VARIABLES ------------------------------
		ADD		R3, R3, #4				; Next address in memory
		SUB		R4, R4, #1				; Update the counter
		;		-------------------------------- STOP CONDTION --------------------------------
		CMP		R4, #0					; If the counter is not zero yet
		BNE		LFSR						; Repeat the process
		;		===============================================================================
		
		
		
		
		;		===============================================================================
		;		ENCRYPTION
		;		===============================================================================
		;		------------------------------- INITIALIZATIONS -------------------------------
		MOV		R3, #14					; Initialize phrase lenght (counter)
		MOV		R4, #0x620 				; Initialize the lenght of the phrase saving address
		MOV		R6, #0x500				; Initialize the character saving address
		MOV		R2, #0x300				; Initialize the random number address
		;		---------------------------- SAVE "Claude Shannon" ----------------------------
		MOV		R5, #67					; "C"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #108					; "l"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #97					; "a"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #117					; "u"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #100					; "d"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #101					; "e"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #32					; " "
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #83					; "S"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #104					; "h"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #97					; "a"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #110					; "n"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #110					; "n"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #111					; "o"
		STR		R5, [R6]					; Save the character
		ADD		R6, R6, #4				; New memory location
		MOV		R5, #110					; "n"
		STR		R5, [R6]					; Save the character
		;		------------------------------- BEFORE ENCRYPTION -----------------------------
		MOV		R6, #0x500				; Reset character saving address
		STR		R3, [R4]					; Save in memory "Claude Shannon" lenght
		;		----------------------------- ENCRYPTION ALGORITHM ----------------------------
ENCRYPT
		LDR		R1, [R2]					; Retrieve the random number from memory
		LDR		R5, [R6]					; Retrieve the character from memory
		ADD		R5, R5, #23				; Add 23d to the character
		EOR		R5, R5, R1				; (Random number) XOR (Character + 23)
		;		--------------------- SAVE, UPDATE VARIABLES AND VALIDATE ---------------------
		STR		R5, [R6]					; Replace the character with the encrypted one
		ADD		R2, R2, #4				; Next random number
		ADD		R6, R6, #4				; Next character
		SUB		R3, R3, #1				; Update counter
		CMP		R3, #0					; If the counter is greater or equal than 0
		BGT		ENCRYPT					; Repeat the process
		;		===============================================================================
		
		
		
		
		;		===============================================================================
		;		DECRYPTION
		;		===============================================================================
		;		------------------------------- INITIALIZATIONS -------------------------------
		MOV		R6, #0x500				; Initialize the encrypted character address
		MOV		R2, #0x300				; Initialize the random number address
		;		------------------------------- BEFORE DECRYPTION -----------------------------
		LDR		R3, [R4]					; Get the phrase lenght from memory (R4 was initialized in encryption)
		;		----------------------------- DECRYPTION ALGORITHM ----------------------------
DECRYPT
		LDR		R1, [R2]					; Retrieve the random number from memory
		LDR		R5, [R6]					; Retrieve the encrypted character from memory
		EOR		R5, R5, R1				; (Random number) XOR (Encryped character) = Character + 23d
		SUB		R5, R5, #23				; (Character + 23d) - 23d = Character
		;		--------------------- SAVE, UPDATE VARIABLES AND VALIDATE ---------------------
		STR		R5, [R6]					; Replace the encypted character with the character
		ADD		R2, R2, #4				; Next random number
		ADD		R6, R6, #4				; Next character
		SUB		R3, R3, #1				; Update counter
		CMP		R3, #0					; If the counter is greater or equal than 0
		BGT		DECRYPT					; Repeat the process
		;		===============================================================================
		END
		
		
		
		
		
		
		
		
		
		
		
		
		
