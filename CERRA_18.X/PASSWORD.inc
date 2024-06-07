

PUT_PASS:
        CLRF    EE_DIRE
        CLRF    EE_CONT
        MOVLW   0XC6
        CALL    ENV_CMD
        MOVLW   " "
        CALL    ENV_CAR
        MOVLW   " "
        CALL    ENV_CAR
        MOVLW   " "
        CALL    ENV_CAR
        MOVLW   " "
        CALL    ENV_CAR
        MOVLW   " "
        CALL    ENV_CAR
        MOVLW   0XC6
        CALL    ENV_CMD
        ;;;;;;;;;;;;;;
PUT1    CLRF    EE_VALOR
        CALL    TECLADO
        MOVWF   LETRA
        XORLW   .0
        BTFSC   STATUS,Z
        BRA     PUT1
        MOVF    LETRA,W
        CALL    ENV_CAR
        CALL    READ_EE
        MOVF    LETRA,W
        XORWF   EE_VALOR,W
        BTFSC   STATUS,Z
        INCF    EE_CONT,F
        INCF    EE_DIRE,F
        BTFSS   EE_DIRE,2
        BRA     PUT1
PUT2	BTFSC   EE_CONT,2
        RETURN
        CALL	MEN_ERROR
PUT3	CALL    TECLADO
        XORLW   "C"	;APLASTAR "C" PARA SALIR DEL ERROR
        BTFSS   STATUS,Z
        BRA     PUT3
        BRA     PUT_PASS


MEN_PUT:
        MOVLW   0X01
        CALL    ENV_CMD
        MOVLW   0X80
        CALL    ENV_CMD
        CLRF    INDICE
MPUT	CLRF    LETRA
        CALL    T_PUT
        MOVWF   LETRA
        XORLW   .0
        BTFSC   STATUS,Z
        RETURN
        MOVF    LETRA,W
        CALL    ENV_CAR
        INCF    INDICE,F
        BRA     MPUT

T_PUT:
        RLNCF   INDICE,W;PARA EL 18F
        ADDWF   PCL,F
        DT  "  PUT PASSWORD  ",.0
	
MEN_ERROR:
        MOVLW   0XC0
        CALL    ENV_CMD
        CLRF    INDICE
MERROR	CLRF    LETRA
        CALL    T_ERROR
        MOVWF   LETRA
        XORLW   .0
        BTFSC   STATUS,Z
        RETURN
        MOVF    LETRA,W
        CALL    ENV_CAR
        INCF    INDICE,F
        BRA	MERROR

T_ERROR:
	RLNCF   INDICE,W;PARA EL 18F
        ADDWF   PCL,F
        DT  "      ERROR     ",.0