    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SEGUNDOS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    ;MOVLW   .250
TXS:
    ;MOVLW   .2
    MOVWF   T5
LAZO5
    CALL    T1S
    DECFSZ  T5,F
    BRA	    LAZO5
    RETURN
    
T1S:
    MOVLW   .4
    MOVWF   T4
LAZO4
    MOVLW   .250
    CALL    TXM
    DECFSZ  T4,F
    BRA	    LAZO4
    RETURN
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MILISEGUNDOS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    ;MOVLW   .250
TXM:
    MOVWF   T3
LAZO3
    CALL    T1M
    DECFSZ  T3,F
    BRA	    LAZO3
    RETURN

T1M:
    MOVLW   .4
    MOVWF   T2
LAZO2
    MOVLW   .250
    CALL    TXU
    DECFSZ  T2,F
    BRA	    LAZO2
    RETURN

    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MICROSEGUNDO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;MOVLW   .250
TXU:
    MOVWF   T1
LAZO1
    DECFSZ  T1,F
    BRA	    LAZO1
    RETURN
    
;voltimetro en base hex
CONVERHEX:
    MOVLW   .51	    ;ALMACENAMIENTO EN REGISTROS
    MULWF   DATOL
    MOVFF   PRODL,CO1
    MOVFF   PRODH,CO2
    MOVLW   .51
    MULWF   DATOH
    MOVF    PRODL,W
    ADDWF   CO2,F
    RETURN
    
CONVER:
    BSF	    ADCON0,1
SENSA1
    BTFSC   ADCON0,1
    BRA	    SENSA1
    MOVFF   ADRESL,DATOL
    MOVFF   ADRESH,DATOH
    RETURN
    
WRITE_EE:
    MOVLW   DIRE
    MOVWF   EEADR ; Lower bits of Data Memory Address to write
    MOVLW   VALOR
    MOVWF   EEDATA ; Data Memory Value to write
    MOVLW   0x55
    MOVWF   EECON2 ; Write 55h
    MOVLW   0xAA
    MOVWF   EECON2 ; Write 0AAh
    BSF	    EECON1, WR ; Set WR bit to begin write
SENSA2
    BTFSC   EECON1, WR
    BRA	    SENSA2
    BCF	    EECON1, WREN ; Disable writes on write complete (EEIF set)
    RETURN