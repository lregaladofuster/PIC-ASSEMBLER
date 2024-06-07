
EE_VERIFY:
        CLRF    EE_CONT
        CLRF    EE_DIRE
VER     CLRF    EE_VALOR
        CALL    READ_EE
        MOVF    EE_VALOR,W
        XORLW   0XFF
        BTFSC   STATUS,Z
        INCF    EE_CONT,F
        INCF    EE_DIRE,F;LO PUSE ASI PARA CUANDO SEA 3 ES DECIR 4 DATOS, SE COMPARE COMO SI FUERA 4
        BTFSS   EE_DIRE,2;VERIFICA SI ES 4 , QUISE AHORRAR CODIGO
        BRA     VER
        RETURN
NEW_PASS:
        MOVLW   0XC6
        CALL    ENV_CMD
        CLRF    EE_DIRE
I1      CLRF    EE_VALOR
        CALL    TECLADO
        MOVWF   LETRA
        XORLW   .0
        BTFSC   STATUS,Z
        BRA     I1
        MOVF    LETRA,W
        MOVWF   EE_VALOR
        CALL    ENV_CAR
        CALL    WRITE_EE
        INCF    EE_DIRE,F
        BTFSS   EE_DIRE,2
        BRA     I1
        RETURN

MEN_PASS:
        MOVLW   0X01
        CALL    ENV_CMD
        MOVLW   0X80
        CALL    ENV_CMD
        CLRF    INDICE
PASS    CLRF    LETRA
        CALL    T_NEW_PASS
        MOVWF   LETRA
        XORLW   .0
        BTFSC   STATUS,Z
        RETURN
        MOVF    LETRA,W
        CALL    ENV_CAR
        INCF    INDICE,F
        BRA     PASS

T_NEW_PASS:
        RLNCF   INDICE,W;PARA EL 18F
        ;MOVF   INDICE,W;PARA EL 16F
        ADDWF   PCL,F
        DT  "  NEW PASSWORD  ",.0

