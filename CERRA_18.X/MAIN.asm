        LIST    P=18f
        RADIX   HEX
        #include "p18F4550.inc"
        CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
        CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
        CONFIG  USBDIV = 1
        CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
        CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
        CONFIG  IESO = OFF
        CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
        CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
        CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting)
        CONFIG  VREGEN = OFF
        CONFIG  WDT = OFF              ; Watchdog Timer Enable bit (WDT enabled)
        CONFIG  WDTPS = 32768
        CONFIG  CCP2MX = OFF          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RB3)
        CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
        CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
        CONFIG  MCLRE = OFF
        CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
        CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
        CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
        CONFIG  XINST = OFF
        CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
        CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
        CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
        CONFIG  CP3 = OFF
        CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
        CONFIG  CPD = OFF
        CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
        CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
        CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
        CONFIG  WRT3 = OFF
        CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
        CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
        CONFIG  WRTD = OFF
        CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
        CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
        CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
        CONFIG  EBTR3 = OFF
        CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)
        CBLOCK  ;VARIABLES GLOBALES
            LETRA,INDICE
            EE_VALOR,EE_DIRE
            EE_CONT
        ENDC
#DEFINE SALIDA  LATD
#DEFINE ENTRADA PORTD
        ORG 0X0000
        BRA     CONF_IO

        ORG 0X0020
CONF_IO:
        CLRF    LATC
        CLRF    LATD
        CLRF    PORTC
        CLRF    PORTD
        MOVLW   0X0F
        MOVWF   ADCON1 ; for digital inputs
        MOVLW   0X07
        MOVWF   CMCON
        MOVLW   0X0F
        MOVWF   TRISD
        CLRF    TRISC
        CALL    CONFIG_LCD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CONTRA_INICIAL:;LIBRERY VERIFICACION
        CLRF    EE_CONT
        CALL    EE_VERIFY
        MOVF    EE_CONT,W
        XORLW   .0
        BTFSC   STATUS,Z
        BRA     INICIO
        CALL    MEN_PASS
        CALL    NEW_PASS
        BRA     INICIO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INICIO:
        CALL    WELCOME
        CALL	MEN_PUT
        CALL    PUT_PASS;EE_CONT,2=1 SIGNIFICA CONTRASENA CORRECTA 
        CALL    MEN_INGRESE
        CALL    ROTA_MENSAJE
        BRA     INICIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WELCOME:
        MOVLW   0X01
        CALL    ENV_CMD
        MOVLW   0X80
        CALL    ENV_CMD
        CLRF    INDICE
WEL     CLRF    LETRA
        CALL    T_WELCOME
        MOVWF   LETRA
        XORLW   .0
        BTFSC   STATUS,Z
        BRA	WEL2
        MOVF    LETRA,W
        CALL    ENV_CAR
        INCF    INDICE,F
        BRA     WEL
WEL2	CALL    TECLADO
        XORLW   "C"	;APLASTAR "C" PARA SALIR DEL ERROR
        BTFSS   STATUS,Z
        BRA     WEL2
        RETURN
	
T_WELCOME:
        RLNCF   INDICE,W;PARA EL 18F
        ADDWF   PCL,F
        DT  "   BIENVENIDO   ",.0
	
        ORG 0X0100
        #INCLUDE    "VERIFICACION.INC"
        #INCLUDE    "EEPROM.INC"
        ORG 0X0200
        #INCLUDE    "PASSWORD.INC"
        ORG 0X0300
        #INCLUDE    "LIBRERIA.INC"
        ORG 0X0410

MEN_INGRESE:
        MOVLW   0X01
        CALL    ENV_CMD
        MOVLW   0X80
        CALL    ENV_CMD
        CLRF    INDICE
MINGRE	CLRF    LETRA
        CALL    T_INGRESE
        MOVWF   LETRA
        XORLW   .0
        BTFSC   STATUS,Z
        RETURN
        MOVF    LETRA,W
        CALL    ENV_CAR
        INCF    INDICE,F
        BRA     MINGRE

T_INGRESE:
        RLNCF   INDICE,W;PARA EL 18F
        ADDWF   PCL,F
        DT  "ACCESO AUTORIZADO  QUE TENGA UN BUEN DIA",.0

ROTA_MENSAJE:
        MOVLW 0X18
        CALL ENV_CMD
        MOVLW 0X3F
        CALL MILIS
        BRA  ROTA_MENSAJE
        RETURN
FINISH:
        END