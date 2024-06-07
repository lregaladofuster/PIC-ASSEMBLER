CONF_LCD:
    MOVLW   .10
    CALL    MILIS
    MOVLW   0X32
    CALL    ENV_CMD
    MOVLW   0X06
    CALL    ENV_CMD
    MOVLW   0X01
    CALL    ENV_CMD
    MOVLW   0X28
    CALL    ENV_CMD
    MOVLW   0X0D;EN PARPADEO, 0X0C SIN PARPADEO
    CALL    ENV_CMD
    RETURN

ENV_CMD:
    BCF	    RS
    CALL    ENV_BYTE
    RETURN

ENV_CAR:
    BSF	    RS
    CALL    ENV_BYTE
    RETURN

ENV_BYTE:
    MOVWF   ALM
    MOVWF   PORTB
    BSF	    EN
    CALL    T1M
    BCF	    EN
    CALL    T1M
    SWAPF   ALM,W
    MOVWF   PORTB
    BSF	    EN
    CALL    T1M
    BCF	    EN
    CALL    T1M
    RETURN
    
MILIS:
    MOVWF   T2
L2  CALL    T1M
    DECFSZ  T2,F
    GOTO    L2
    RETURN    
    
T1M:
    MOVLW   .248
    MOVWF   T1
L1  NOP
    DECFSZ  T1,F
    GOTO    L1
    NOP
    NOP
    NOP
    RETURN