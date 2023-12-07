PROCESSOR 10LF322
#include<xc.inc> ;Includes macros defined by PIC-as

;Definitions
CLOCK_16    EQU 0x70
R_BLUE	    EQU 0x40
BLUE	    EQU 0	;Blue color value    
R_RED	    EQU 0x41
RED	    EQU	255	;Red color value
R_GREEN	    EQU 0x42
GREEN	    EQU	0	;Green color value
COUNTER_B   EQU 0x43
COUNTER_R   EQU 0x44
COUNTER_G   EQU 0x45 
    
;Configurating word
CONFIG WDTE = OFF   ;WATCHDOG OFF
CONFIG CP = OFF	    ;CODE PROTECTION OFF
CONFIG MCLRE = OFF  ;RESET PIN OFF
CONFIG BOREN = OFF  ;BROWN-OUT OFF
CONFIG LPBOR = OFF  ;LOW-POWER BROWN-OUT RESET OFF
CONFIG PWRTE = OFF  ;POWER-UP TIMER OFF
CONFIG WRT = OFF    ;FLASH MEMORY SELF-WRITE OFF
CONFIG FOSC = INTOSC ;INTERNAL CLOCK SOURCE
    
RESET_VECTOR:
    PSECT resetOrigin, class=CODE, delta=2
    
CLOCK_SOURCE_CONFIG:
    MOVLW CLOCK_16  ;INTERNAL CLOCK FREQUENCY = 16 MHz 
    MOVWF OSCCON
    
GPIO_SETUP:
    MOVLW ~(1 << PORTA_RA0_POSITION)
    MOVWF TRISA ;RA0 pin = OUTPUT
    
MAIN:
    MOVLW 8
    MOVWF COUNTER_B
    MOVWF COUNTER_R
    MOVWF COUNTER_G
    MOVLW BLUE
    MOVWF R_BLUE
    MOVLW RED
    MOVWF R_RED
    MOVLW GREEN
    MOVWF R_GREEN

BLUE_OUT:  
    BCF PORTA, PORTA_RA0_POSITION ;Send a 0 (resets the stream)
    BSF PORTA, PORTA_RA0_POSITION ;Send a 1 (starts the stream)
    BTFSS R_BLUE, 0 ;Checks the bit to send 
    BCF PORTA, PORTA_RA0_POSITION ;If 0 sends a 0
    RRF R_BLUE, F ;Rotate the register to the right
    DECFSZ COUNTER_B, F ;Decrement the counter for R_BLUE
    GOTO BLUE_OUT ;If it is not 0 send the next bit
    GOTO RED_OUT ; Else go to next stream 
    

RED_OUT:
    BCF PORTA, PORTA_RA0_POSITION ;Send a 0 (resets the stream)
    BSF PORTA, PORTA_RA0_POSITION ;Send a 1 (starts the stream)
    BTFSS R_RED, 0 ;Checks the bit to send 
    BCF PORTA, PORTA_RA0_POSITION ;If 0 sends a 0
    RRF R_RED, F ;Rotate the register to the right
    DECFSZ COUNTER_R, F ;Decrement the counter for R_BLUE
    GOTO RED_OUT ;If it is not 0 send the next bit
    GOTO GREEN_OUT ; Else go to next stream 

GREEN_OUT:
    BCF PORTA, PORTA_RA0_POSITION ;Send a 0 (resets the stream)
    BSF PORTA, PORTA_RA0_POSITION ;Send a 1 (starts the stream)
    BTFSS R_GREEN, 0 ;Checks the bit to send 
    BCF PORTA, PORTA_RA0_POSITION ;If 0 sends a 0
    RRF R_GREEN, F ;Rotate the register to the right
    DECFSZ COUNTER_G, F ;Decrement the counter for R_GREEN
    GOTO GREEN_OUT ;If it is not 0 send the next bit
            
END ;Turns ON a LED