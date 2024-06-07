
READ_EE:
        MOVFF   EE_DIRE, EEADR
        BCF     EECON1, EEPGD
        BCF     EECON1, CFGS
        BSF     EECON1, RD
        MOVFF   EEDATA, EE_VALOR
        RETURN

WRITE_EE:
        MOVFF   EE_DIRE, EEADR
        MOVFF   EE_VALOR, EEDATA
        BCF     EECON1, EEPGD
        BCF     EECON1, CFGS
        BSF     EECON1, WREN
        BCF     INTCON, GIE
        MOVLW   0X55
        MOVWF   EECON2
        MOVLW   0XAA
        MOVWF   EECON2
        BSF     EECON1, WR
WRI     BTFSC   EECON1, WR
        BRA     WRI
        BCF     EECON1, WREN
        RETURN


