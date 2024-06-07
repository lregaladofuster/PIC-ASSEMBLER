; ********************************************************
; Desarrollo de Microcontroladores y DSPS
; Manejo de un LCD
; Práctica 4
;
; Fecha: 18/06/2012
; Notas: Controlar un LCD LM016
;
; ek
; ************************************************************
    LIST P = 18F4550
    INCLUDE <P18F4550.INC>
    ;************************************************************
    CONFIG FOSC = HS
    CONFIG PWRT = ON
    CONFIG BOR = OFF
    CONFIG WDT = OFF
    CONFIG MCLRE = ON
    CONFIG PBADEN = OFF
    CONFIG LVP = OFF
    CONFIG DEBUG = OFF
    CONFIG XINST = OFF
    ; CODE ******************************************************
    CBLOCK 0x0C
	Conta1
	Conta2
	Conta3
	dat1
	dat2
	dat3
	dat4
    ENDC
 
#define LCD_RS PORTD,0
#define LCD_E  PORTD,1
 
    ORG	    0x00

    clrf    PORTB
    clrf    PORTD

    clrf    TRISB
    clrf    TRISD

    call    LCD_Inicializa
    bcf	    LCD_E
 
Inicio
    movlw   0x38
    call    LCD_Comando
    movlw   0x80
    call    LCD_Comando
    movlw   'V'
    call    LCD_Caracter
    movlw   'O'
    call    LCD_Caracter
    movlw   'L'
    call    LCD_Caracter
    movlw   'T'
    call    LCD_Caracter
    movlw   'A'
    call    LCD_Caracter
    movlw   'J'
    call    LCD_Caracter
    movlw   'E'
    call    LCD_Caracter
    movlw   ':'
    call    LCD_Caracter
    call    Delay
ADC
    movlw   b'00001110'
    movwf   ADCON1
    movlw   b'00000000'
    movwf   ADCON0
    movlw   b'00111101'
    movwf   ADCON2
    bsf	    ADCON0,.0
    
Trabajo
    clrf    ADRESH
    clrf    ADRESL
    clrf    PRODH
    clrf    PRODL
    clrf    dat1
    clrf    dat2
    clrf    dat3
    clrf    dat4
    bsf	    ADCON0,.1
t1  btfsc   ADCON0,.1
    goto    t1
    
    movf    ADRESH,.0
    mullw   .5
    movff   PRODH,dat1
    movf    PRODL,.0
    addlw   .5
    bnc	    t2
    incf    dat1,.1
  
t2  mullw   .10
    movff   PRODH,dat2
    movf    PRODL,.0
    
    mullw   .10
    movff   PRODH,dat3
    movf    PRODL,.0
    
    mullw   .10
    movff   PRODH,dat4
    
trab
    movlw   0xC0
    call    LCD_Comando	
    
    movf    dat1,.0
    addlw   0x30
    call    LCD_Caracter
    
    movlw   '.'
    call    LCD_Caracter
    
    movf    dat2,.0
    addlw   0x30
    call    LCD_Caracter
    
    movf    dat3,.0
    addlw   0x30
    call    LCD_Caracter
    
    movf    dat4,.0
    addlw   0x30
    call    LCD_Caracter
    
    movlw   'V'
    call    LCD_Caracter
    
    goto    Trabajo
 
    
    
LCD_Inicializa
    call    Retardo_20ms ;Esperar 20 ms
    movlw   b'00110000' ;Mandar 0x30 -> W
    movwf   PORTB ;Enviar W -> PORTB

    call    Retardo_5ms ;Esperar 5ms
    movlw   b'00110000' ;Enviar 0x30 -> W
    movwf   PORTB

    call    Retardo_50us ;Acumular 100us
    call    Retardo_50us ;Acumular 100us
    movlw   b'00110000'
    movwf   PORTB

    movlw   0x0F
    movwf   PORTB

    bsf	    LCD_E
    bcf	    LCD_E
    return
 
LCD_Caracter
    bsf	    LCD_RS ;Modo Caracter RS = 1
    movwf   PORTB ;Lo que se cargó previamente en W -> PORTB
    bsf	    LCD_E ;Activar Enable
    call    Retardo_50us ;Esperar 50us para enviar información
    bcf	    LCD_E ;Transición del Enable a 0
    call    Retardo_20ms ;Esperar a poner la siguiente llamada
    return

LCD_Comando
    bcf	    LCD_RS ;Modo Comando RS = 0
    movwf   PORTB ;Envia W -> PORTB
    bsf	    LCD_E ;Activa Enable
    call    Retardo_50us ;Espera que se envie la información
    bcf	    LCD_E ;Transición del Enable
    call    Retardo_50us
    return
 
  
;Retardo_20ms *********************
Retardo_20ms
    movlw  .247
    movwf  Conta1
    movlw  .26
    movwf  Conta2
Re_20ms
    decfsz Conta1, F  ;Salta cuando Conta1 llega a 0
    bra    Re_20ms    ;Salta a Repeat para Decrementar Conta1
    decfsz Conta2, F  ;Salta cuando Conta2 llega a 0
    bra    Re_20ms    ;Salta a Repeat
    Return
 
;Retardo_5ms *********************
Retardo_5ms
    movlw  .146
    movwf  Conta1
    movlw  .7
    movwf  Conta2
Re_5ms
    decfsz Conta1, F ;Salta cuando Conta1 llega a 0
    bra    Re_5ms    ;Salta a Repeat para Decrementar Conta1
    decfsz Conta2, F ;Salta cuando Conta2 llega a 0
    bra    Re_5ms    ;Salta a Repeat
    Return
 
;Retardo_200us *********************
Retardo_200us
    movlw  .65
    movwf  Conta1
Re_200us
    decfsz  Conta1, F ;Salta cuando Conta1 llega a 0
    bra     Re_200us  ;Salta a Repeat para Decrementar Conta1
    Return
 
;Retardo_2ms *********************
Retardo_2ms
    movlw  .151
    movwf  Conta1
    movlw  .3
    movwf  Conta2
Re_2ms
    decfsz  Conta1, F ;Salta cuando Conta1 llega a 0
    bra     Re_2ms    ;Salta a Repeat para Decrementar Conta1
    decfsz  Conta2, F ;Salta cuando Conta2 llega a 0
    bra     Re_2ms    ;Salta a Repeat
    Return
 
;Retardo_50us *********************
Retardo_50us
    movlw  .15
    movwf  Conta1
Re_50us
    decfsz Conta1, F ;Salta cuando Conta1 llega a 0
    bra    Re_50us   ;Salta a Repeat para Decrementar Conta1
    Return
 
Delay
    clrf   Conta1
    clrf   Conta2
    movlw  .3
    movwf  Conta3
Re_Delay
    decfsz Conta1, F ;Salta cuando Conta1 llega a 0
    bra    Re_Delay  ;Salta a Repeat para Decrementar Conta1
 
    decfsz Conta2, F ;Salta cuando Conta2 llega a 0
    bra    Re_Delay  ;Salta a Repeat
 
    decfsz Conta3, F
    bra    Re_Delay
 
    Return
	
 
    END ;Fin de Programa
	
