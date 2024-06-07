

; PIC16F628A Configuration Bit Settings

; Assembly source line config statements
PROCESSOR 16F628A
    #include <xc.inc>
    #include <pic.inc>
    #include <pic_as_chip_select.inc>
    #include <as16f62xa_legacy.h>
    #include <pic16f628a.inc>
    
; CONFIG
  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection bits (INTOSC oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = OFF           ; RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is digital input, MCLR internally tied to VDD)
  CONFIG  BOREN = OFF           ; Brown-out Detect Enable bit (BOD disabled)
  CONFIG  LVP = ON              ; Low-Voltage Programming Enable bit (RB4/PGM pin has PGM function, low-voltage programming enabled)
  CONFIG  CPD = OFF             ; Data EE Memory Code Protection bit (Data memory code protection off)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)
    
GLOBAL max ;make this global so it is watchable when debugging
;objects in common (Access bank) memory
PSECT udata_acs
max:
 DS 1 ;reserve 1 byte for max
tmp:
 DS 1 ;1 byte for tmp

PSECT resetVec,class=CODE,reloc=2
    ORG 0x0000
resetVec:
    PAGESEL main
    goto main   
    
PSECT code
    ORG 0x0050
main:
    CLRF PORTA	
    MOVLW 0x07	;Turn comparators off and
    MOVWF CMCON 
    BCF STATUS,6
    BSF STATUS,5 ;Select Bank1
    MOVLW 0x10	
    MOVWF TRISA 
    BCF STATUS,6
    BCF STATUS,5 ;Select Bank1
    CLRF PORTA
    MOVLW 0xF7	
    MOVWF PORTA
    GOTO $
    END resetVec
    
    
/*    
ORG 0x0000
resetVec:
    goto main   
    
ORG 0x0050
main:
    CLRF PORTA	
    MOVLW 0x07	;Turn comparators off and
    MOVWF CMCON 
    BCF STATUS,6
    BSF STATUS,5 ;Select Bank1
    MOVLW 0x1F	
    MOVWF TRISA 
    END resetVec
*/