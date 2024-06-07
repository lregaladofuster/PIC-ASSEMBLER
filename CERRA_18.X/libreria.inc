;ESTA LIBRERIA OCUPA 0X0100 ESPACIOS DE MEMORIA
    ;EN EL PIC18F4550
        CBLOCK  ;VARIABLES LOCALES
            T1,T2
            ALM
            SALVA,ROTA
        ENDC
;DEFINIR ANTES DE COMENZAR
;LOCALES
#DEFINE RS      LATC,0
#DEFINE EN      LATC,1
#DEFINE LCD     LATD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LCD ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CONFIG_LCD:
        MOVLW   .10
        CALL    MILIS
        MOVLW   0X32
        CALL    ENV_CMD
        MOVLW   0X28
        CALL    ENV_CMD
        MOVLW   0X0D;EN PARPADEO, 0X0C SIN PARPADEO
        CALL    ENV_CMD
        MOVLW   0X06
        CALL    ENV_CMD
        MOVLW   0X01
        CALL    ENV_CMD
        RETURN

ENV_CMD:
        BCF	RS
        CALL    ENV_BYTE
        RETURN

ENV_CAR:
        BSF	RS
        CALL    ENV_BYTE
        RETURN

ENV_BYTE:
        MOVWF   ALM
        MOVWF   LCD
        BSF	EN
        CALL    T1M
        BCF	EN
        CALL    T1M
        SWAPF   ALM,W
        MOVWF   LCD
        BSF	EN
        CALL    T1M
        BCF	EN
        CALL    T1M
        RETURN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; KEYPAD ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TECLADO:
        MOVLW   0XF0
        MOVWF   SALIDA
        MOVF    ENTRADA,W
        ANDLW   B'00001111'
        MOVWF   SALVA
        XORLW   .0
        BTFSC   STATUS,Z
        RETLW   .0
        MOVF    SALVA,W
        CALL    AJUSTE1
        MOVWF   SALVA
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOVLW   B'11101111'
        MOVWF   ROTA
TEC1:   MOVF    ROTA,W
        ANDLW   B'11110000'
        MOVWF   SALIDA
        MOVF    ENTRADA,W
        ANDLW   B'00001111'
        XORLW   .0
        BTFSC   STATUS,Z
        BRA     TEC2
        BTFSS   ROTA,7
        RETLW   .0
        RLNCF   ROTA,F
        BRA     TEC1
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
TEC2:   CALL    AJUSTE2
        ADDWF   SALVA,F
PUT	MOVLW   0XF0
        MOVWF   SALIDA
        MOVF    ENTRADA,W
        ANDLW   B'00001111'
        XORLW   .0
        BTFSS   STATUS,Z
        BRA     PUT
        RLNCF   SALVA,W
        CALL    AJUSTE3
        RETURN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AJUSTE1:BTFSC   SALVA,0
        RETLW   .1
        BTFSC   SALVA,1
        RETLW   .2
        BTFSC   SALVA,2
        RETLW   .3
        BTFSC   SALVA,3
        RETLW   .4
        RETLW   .0

AJUSTE2:BTFSS   ROTA,4
        RETLW   .0
        BTFSS   ROTA,5
        RETLW   .4
        BTFSS   ROTA,6
        RETLW   .8
        BTFSS   ROTA,7
        RETLW   .12
        RETLW   .0

AJUSTE3:ADDWF   PCL,F
        DT  " 741C8520963=/*-+"
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RETARDO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;ORG 0X0300
MILIS:
        MOVWF   T2
L2      CALL    T1M
        DECFSZ  T2,F
        BRA     L2
        RETURN
    
T1M:
        MOVLW   .248
        MOVWF   T1
L1      NOP
        DECFSZ  T1,F
        BRA     L1
        NOP
        NOP
        NOP
        RETURN