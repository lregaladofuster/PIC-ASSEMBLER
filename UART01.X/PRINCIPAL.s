

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
    
; When assembly code is placed in a psect, it can be manipulated as a
; whole by the linker and placed in memory.  
;
; In this example, barfunc is the program section (psect) name, 'local' means
; that the section will not be combined with other sections even if they have
; the same name.  class=CODE means the barfunc must go in the CODE container.
; PIC18 should have a delta (addressible unit size) of 1 (default) since they
; are byte addressible.  PIC10/12/16 have a delta of 2 since they are word
; addressible.  PIC18 should have a reloc (alignment) flag of 2 for any
; psect which contains executable code.  PIC10/12/16 can use the default
; reloc value of 1.  Use one of the psects below for the device you use:

GLOBAL max ;make this global so it is watchable when debugging
;objects in common (Access bank) memory
PSECT udata
max:
 DS 1 ;reserve 1 byte for max
tmp:
 DS 1 ;1 byte for tmp
 
PSECT resetVec,class=CODE,delta=2,abs
    ORG 0x0000	; no funciona, se agrega 
		;-Wl,-presetVec=0h
		;en pic-as global option(configuracion
		;aditional information
resetVec:
    PAGESEL (main)
    GOTO main
    
PSECT code,delta=2,abs	; "org" necesita "abs"
    ORG 0x0100		; para funcionar
main:
    BANKSEL(PCON)
    BSF PCON,3 ;4MHZ
    BANKSEL (INTCON)
    BCF INTCON,0
    BCF INTCON,1
    BANKSEL (PORTA); funciona
    CLRF BANKMASK(PORTA);cuando se quiera modificar	
    MOVLW 0x07		;el valor del registro
    MOVWF BANKMASK(CMCON )
    BANKSEL (TRISA)
    MOVLW 0x10	
    MOVWF BANKMASK(TRISA) 
    BANKSEL (PORTA)
    CLRF BANKMASK(PORTA)
    MOVLW 0x00
    MOVWF BANKMASK(PORTA)

START:
    BANKSEL (TRISB)
    BSF TRISB,3
    BANKSEL (CCP1CON)
    CLRF BANKMASK(CCP1CON) ;REINICIAR
    MOVLW 00000100B
    MOVWF BANKMASK(CCP1CON) ;CCP1IF(PIR1,2)
    BANKSEL (T1CON)
    CLRF BANKMASK(T1CON)
    MOVLW 00110000B;PRES=8,OSC=OFF,CLOCK INTERNAL 
    MOVWF BANKMASK(T1CON)
    BCF T1CON,0
    NOP
    NOP
    BSF T1CON,0
    BANKSEL(PIR1)
H0001:
    BTFSS PIR1,2
    GOTO $-1;UNA INSTRUCCION ATRAS
    
    BCF PIR1,2
    BCF PIR1,0
    CLRF BANKMASK(TMR1H)
    CLRF BANKMASK(TMR1L)
    MOVF CCPR1L,W
    ANDLW 0X0F
    MOVWF BANKMASK (PORTA)
    GOTO H0001
    GOTO $
    END resetVec 
