		
;******************************************************************************
;   This file is a basic template for assembly code for a PIC18F4550. Copy    *
;   this file into your project directory and modify or add to it as needed.  *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on the         *
;   features of the assembler.                                                *
;                                                                             *
;   Refer to the PIC18Fx455/x550 Data Sheet for additional                    *
;   information on the architecture and instruction set.                      *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:                                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             * 
;******************************************************************************
;                                                                             *
;    Files Required: P18F4550.INC                                             *
;                                                                             *
;******************************************************************************

	LIST P=18F4550		;directive to define processor
	#include <P18F4550.INC>	;processor specific variable definitions

;******************************************************************************
;Configuration bits
;Microchip has changed the format for defining the configuration bits, please 
;see the .inc file for futher details on notation.  Below are a few examples.



;   Oscillator Selection:
    CONFIG	FOSC = XT_XT         ;XT oscillator, XT used by USB

;******************************************************************************
;Variable definitions
; These variables are only needed if low priority interrupts are used. 
; More variables may be needed to store other special function registers used
; in the interrupt routines.

		CBLOCK	0x080
		WREG_TEMP	;variable used for context saving 
		STATUS_TEMP	;variable used for context saving
		BSR_TEMP	;variable used for context saving
		ENDC

		CBLOCK	0x000
		EXAMPLE		;example of a variable in access RAM
		ENDC

;******************************************************************************
;EEPROM data
; Data to be programmed into the Data EEPROM is defined here

		ORG	0xf00000

		DE	"Test Data",0,1,2,3,4,5

;******************************************************************************
;Reset vector
; This code will start executing when a reset occurs.

		ORG	0x0000

		goto	Main		;go to start of main code

;******************************************************************************
;High priority interrupt vector
; This code will start executing when a high priority interrupt occurs or
; when any interrupt occurs if interrupt priorities are not enabled.

		ORG	0x0008

		bra	HighInt		;go to high priority interrupt routine

;******************************************************************************
;Low priority interrupt vector and routine
; This code will start executing when a low priority interrupt occurs.
; This code can be removed if low priority interrupts are not used.

		ORG	0x0018

		movff	STATUS,STATUS_TEMP	;save STATUS register
		movff	WREG,WREG_TEMP		;save working register
		movff	BSR,BSR_TEMP		;save BSR register

;	*** low priority interrupt code goes here ***


		movff	BSR_TEMP,BSR		;restore BSR register
		movff	WREG_TEMP,WREG		;restore working register
		movff	STATUS_TEMP,STATUS	;restore STATUS register
		retfie

;******************************************************************************
;High priority interrupt routine
; The high priority interrupt code is placed here to avoid conflicting with
; the low priority interrupt vector.

HighInt:

;	*** high priority interrupt code goes here ***


		retfie	FAST

;******************************************************************************
;Start of main program
; The main program code is placed here.

Main:

;	*** main code goes here ***


;******************************************************************************
;End of program

		END

		
		
		


;**************************************************************************
; TUTOR.ASM
;
; This sample program runs on most all PIC devices.  To ensure 
; proper execution, replace the processor specified in the LIST directive 
; with your target processor.
;
; Program execution starts at location H'50'.  The loop routine executes 
; seven times.  The routines Reduce and Double execute one time for each 
; loop.
;
; After the loop executes seven times, the program repeats execution from 
; the beginning.
;
;
; Variable    Initial    Description
;              Value
;--------------------------------------------------------------------------
; CountDown     255      Decreases to 128 by subtracting Doubler
; Doubler        1       Increases to 128 by adding to itself
; OuterLoop      7       Decrements by one to 0
;
;           
; The program generates the following values:
;
; Cycle #    CountDown   Doubler     OuterLoop
;   0           255           1           7
;   1           254           2           6
;   2           252           4           5
;   3           248           8           4
;   4           240          16           3
;   5           224          32           2  
;   6           192          64           1   
;   7           128         128           0  
;
;**************************************************************************

        LIST P=16C64, R=DEC

;--------------------------------------------------------------------------
;   Set ScratchPadRam here.  If you are using a PIC16C5X device, use: 
;ScratchPadRam EQU     0x10
;   Otherwise, use:
;ScratchPadRam EQU     0x20
;--------------------------------------------------------------------------

ScratchPadRam   EQU     0x20

;--------------------------------------------------------------------------
; Variables
;--------------------------------------------------------------------------

CountDown       EQU     ScratchPadRam+0
Doubler         EQU     ScratchPadRam+1
OuterLoop       EQU     ScratchPadRam+2


;--------------------------------------------------------------------------
; Program Code
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;   Set the reset vector here.  If you are using a PIC16C5X device, use:
;               ORG     <last program memory location>
;   Otherwise, use:
;               ORG     0
;--------------------------------------------------------------------------

                ORG     0       
                GOTO    Start

;--------------------------------------------------------------------------
; Main Program
;--------------------------------------------------------------------------

                ORG     H'50'

Start
                MOVLW   255             ;   Initialize the variables to
                MOVWF   CountDown       ; their starting values.
                MOVLW   1               
                MOVWF   Doubler      
                MOVLW   7
                MOVWF   OuterLoop    
Loop                    
                CALL    Reduce          ;   Perform the inner portion of
                DECFSZ  OuterLoop,f     ; the loop.
                GOTO    Loop   

                GOTO    Start           ;   Repeat the whole thing.

;--------------------------------------------------------------------------
Reduce
                SWAPF   Doubler,f       ;   Reduce CountDown by the
                SWAPF   Doubler,w       ; value of Doubler.  Then
                SWAPF   Doubler,f       ; call the doubling routine.
                SUBWF   CountDown,f     
                CALL    Double
                RETLW   0

;--------------------------------------------------------------------------
Double
                SWAPF   Doubler,f       ;   Double the value of Doubler
                SWAPF   Doubler,w       ; by adding it to itself.
                SWAPF   Doubler,f 
                ADDWF   Doubler,f       
                RETLW   0

                END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
