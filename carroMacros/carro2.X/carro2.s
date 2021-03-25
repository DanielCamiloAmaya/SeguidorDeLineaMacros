;*****************************************************************************
;                                                                             *
;   __      __  _____ __________________________ _____________________        *
;  /  \    /  \/  _  \\______   \_   _____/  _  \\______   \_   _____/        *
;  \   \/\/   /  /_\  \|       _/|    __)/  /_\  \|       _/|    __)_         *
;   \        /    |    \    |   \|     \/    |    \    |   \|        \        *
;    \__/\  /\____|__  /____|_  /\___  /\____|__  /____|_  /_______  /        *
;         \/         \/       \/     \/         \/       \/        \/         *
;                                                                             *
;******************************************************************************
;   Description                                                               *
;                                                                             *
;									      *
;******************************************************************************
;                                                                             *
;    Filename: carro2                                                     *
;    Designed by: Daniel Camilo Amaya  2420191010                             *
;		  0scar Rojas Caicedo  2420191009	 		      *	       *
;    Date:  20.03.21                                                          *
;******************************************************************************
;                                                                             *
;    FDEVICE:         P16F877A                                                *
;                                                                             *
;******************************************************************************
PROCESSOR 16F877A

#include <xc.inc>

; CONFIGURATION WORD PG 144 datasheet

CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0   
max:
DS 1 ;reserve 1 byte for max

tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2

resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS

#define S_CEN PORTC,1  
#define S_DER PORTC,2  
#define S_IZQ PORTC,0      
#define	LED_ROJO PORTD,1
#define	LED_DER PORTD,2
#define	LED_IZQ PORTD,3
#define	MDA PORTD,6  
#define	MDB PORTD,7 
#define	MIA PORTD,4
#define	MIB PORTD,5  
    
    STOP:
BCF MDA
BCF MIA
BCF MDB
BCF MIB
BSF LED_ROJO
BCF LED_DER
BCF LED_IZQ
GOTO MAIN
    
    AVANZA:
BSF MDA
BSF MIA
BCF MDB
BCF MIB
BCF LED_ROJO
BCF LED_DER
BCF LED_IZQ
GOTO MAIN
    
    DERECHA:
BCF MDA
BSF MIA
BCF MDB
BCF MIB
BCF LED_ROJO
BSF LED_DER
BCF LED_IZQ
GOTO MAIN
    
    IZQUIERDA:
BSF MDA
BCF MIA
BCF MDB
BCF MIB
BCF LED_ROJO
BCF LED_DER
BSF LED_IZQ
GOTO MAIN
    
    INISYS:

BCF STATUS, 6
BSF STATUS, 5 ; se trabaja en el banco 1

    BSF		TRISC, 0 ;PORT (C0) S1 ENTRADA
    BSF		TRISC, 1 ;PORT (C1) S2 ENTRADA
    BSF		TRISC, 2 ;PORT (C2) S3 ENTRADA
    
    BCF		TRISD, 1 ;PORT (D0) DYR SALIDA
    BCF		TRISD, 2 ;PORT (D1) LR SALIDA
    BCF		TRISD, 3 ;PORT (D2) LL SALIDA
    BCF		TRISD, 4 ;PORT (D3) MI1 SALIDA
    BCF		TRISD, 5 ;PORT (D5) MI2 SALIDA
    BCF		TRISD, 6 ;PORT (D5) MD1 SALIDA
    BCF		TRISD, 7 ;PORT (D5) MD2 SALIDA

   
BCF STATUS,5 ;BK0

 MAIN: 

    BTFSS S_IZQ 
    GOTO opcion1
    GOTO opcion2

    opcion1:
    BTFSS S_DER
    GOTO opcion3
    GOTO opcion4
    
    opcion2:
    BTFSS S_DER
    GOTO opcion5
    GOTO opcion6
    
    opcion3:
    BTFSS S_CEN
    CALL STOP
    CALL DERECHA
    
    opcion4:
    BTFSS S_CEN
    CALL AVANZA
    CALL DERECHA
    
    opcion5:
    BTFSS S_CEN
    CALL IZQUIERDA
    CALL MAIN
    
    opcion6:
    BTFSS S_CEN
    CALL IZQUIERDA
    CALL STOP
    
    END