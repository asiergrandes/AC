;==============================================================================================;
				;VARIABLES GLOBALES
	ESTADO EQU 0X20
	EVENTO EQU 0X21
	T_CONT1 EQU 0x22	;BYTE DONDE SE GUARDA EL CONTADOR[1] USADO EN EL TIMER
	T_CONT2 EQU 0x23	;BYTE DONDE SE GUARDA EL CONTADOR[2] USADO EN EL TIMER

	FLAG_PLACA EQU 0X26	;BYTE PARA ESPERAR 5 SEG PLACA
	FLAG_ALARMA EQU 0X27	;FLAG PARA ESTADO 2 Y 3
	FLAG_30 EQU 0X28	;BYTE PARA ESPERAR 30 SEG ALARMA
	FLAG_MOVER EQU 0X29	;BYTE PARA MOVER EL COCHE2
	FLAG_A EQU 0X30		;BYTE PARA GUARDAR A
	FLAG_AGUA EQU 0X31	;BYTE PARA SABER SI AGUA HA SIDO ACTIVADO
	FLAG_4S EQU 0X32	;BYTE PARA SABER CUANDO EMPEZAR EL DESPLAZAMIENTO DE 4S
	FLAG_SECADO EQU 0X33	;BYTE PARA SABER SI SECADO HA SIDO ACTIVADO
	FLAG_ADC EQU 0X34	;BYTE PARA SABER SI ADC
	FLAG_100MS EQU 0X35	;BYTE PARA SABER SI LO HA ACTIVADO
	FLAG_ADC2 EQU 0X36	;BYTE PARA SABER SI LO HEMOS ACTICVADO
	SEGUNDA_CONVERSION EQU 0X37	;BYTE PARA PONER LOS RODILLOS VERTICALES EN SU SITIO
	FLAG_RODILLOS EQU 0X38	;BYTE PARA LOS RODILLOS DEL PRINCIPIO
	FLAG_RODILLOS1 EQU 0X39	;BYTE PARA LOS RODILLOS DEL PRINCIPIO
	FLAG_MOVER2 EQU 0X40	;BYTE PARA MOVER EL COCHE2
	FLAG_MOVER3 EQU 0X41	;BYTE PARA MOVER EL COCHE3
	FLAG_MOVER4 EQU 0X42	;BYTE PARA MOVER EL COCHE4
	FLAG_4S3 EQU 0X43	;BYTE PARA MOVER EL PUENTE 4S
	HA_SALTADO EQU 0X44
	
	ADCON EQU 0xC5		;BYTE DE CONFIGURACION DE ADC
	ADCH EQU 0xC6		;BYTE DONDE SE GUARDA EL VALOR DE LECTURA DEL ADC
	PWMP EQU 0xFE		;BYTE DEL PRESCALER DEL PWM
	PWM0 EQU 0xFC		;BYTE DONDE SE GUARDA EL DUTY CICLE
	PWM1 EQU 0xFD		;BYTE DONDE SE GUARDA EL DUTY CICLE
	IEN0 EQU 0xA8		;BYTE DE CONFIGURACION DE LAS INTERRUPCIONES

				;PUERTOS
	SEM_VERDE EQU P0.0
	SEM_ROJO EQU P0.1
	S_PLAT EQU P0.2		;SENSOR DE PLACA
	FICHA_TIPO EQU P0.3	;TIPO DE LAVADO
	S_FICHA EQU P0.4	;SENSOR DE FICHA
	P_START EQU P0.5	;BOTON DE EMPEZAR
	AL_START EQU P0.6	;ALARMA POR FALTA DE FICHA O COMIENZO MANUAL
	BPOS_START EQU P0.7	;POSICION INICIAL DEL PUENTE DE LAVADO

	BMOV_FRONT EQU P1.0     ;MUEVE EL PUENTE DE LAVADO HACIA ADELANTE
	BMOV_BACK EQU P1.1      ;MUEVE EL PUENTE DE LAVADO HACIA ATR�S
	FC_RH_TOP EQU P1.2      ;SENSOR DE FIN DE CARRERA DEL RODILLO HORIZONTAL EN PARTE M�S ALTA
	RH_UPTO EQU P1.3        ;ACTUADOR PARA MOVER HACIA ARRIBA EL RODILLO HORIZONTAL
	RH_DOWNTO EQU P1.4      ;ACTUADOR PARA MOVER HACIA ABAJO EL RODILLO HORIZONTAL
	FC_RV_BORDE EQU P1.5    ;SENSOR DE FIN DE CARRERA DE LOS RODILLOS VERTICALES EN POSICI�N M�S EXTERIOR
	RV_OUTTO EQU P1.6       ;ACTUADOR PARA MOVER HACIA AFUERA LOS RODILLOS VERTICALES
	RV_INTO EQU P1.7        ;ACTUADOR PARA MOVER HACIA ADENTRO LOS RODILLOS VERTICALES

	EV_AGUA EQU P2.0        ;ACTIVA LA BOMBA DE AGUA DE LA M�QUINA DE LAVADO
	EV_JABON EQU P2.1       ;ACTIVA LA BOMBA DE AGUA JABONADA
	S_CAR EQU P2.3          ;SENSOR DE PRESENCIA
	FC_RV_CENTRO EQU P2.4   ;SENSOR DE FIN DE CARRERA DE RODILLOS VERTICALES EN POSICI�N INTERNA
	LED_LNOR EQU P2.5       ;LED ENCENDIDO PARA INDICAR 'LAVADO NORMAL'
	LED_LINT EQU P2.6       ;LED ENCENDIDO PARA INDICAR 'LAVADO INTENSO'


;============================================INICIO============================================;
ORG 0X0000
	LJMP LAVADERO		
ORG 0X007B
LAVADERO:
	ACALL INICIALIZAR
MAIN:			
	ACALL MAQ_ESTADOS
	AJMP 	MAIN

;=============================================INIT=============================================;
INICIALIZAR:
					;VALORES GLOBALES
	MOV ESTADO, #0
	MOV EVENTO, #0
	MOV T_CONT1, #0
	MOV T_CONT2, #0
	MOV FLAG_PLACA, #0
	MOV FLAG_ALARMA, #0
	MOV FLAG_30, #0
	MOV FLAG_AGUA, #0
	MOV FLAG_4S, #0
	MOV FLAG_SECADO, #0
	MOV FLAG_ADC, #0
	MOV FLAG_100MS, #0
	MOV FLAG_ADC2, #0
	MOV SEGUNDA_CONVERSION, #0
	MOV FLAG_MOVER, #0
	MOV FLAG_MOVER2, #0
	MOV FLAG_MOVER3, #0
	MOV FLAG_MOVER4, #0
	MOV FLAG_4S3, #0
	MOV HA_SALTADO, #0


	MOV PWMP, #23 ;ACTIVA EL PWMP CON EL DUTY-CYCLE CORRESPONDIENTE
	
	MOV P0, #0xBC
	MOV P1, #0x24	;CONFIGURAR PUERTOS DE ENTRADA Y PUERTOS DE SALIDA
	MOV P2, #0x18

	SETB SEM_VERDE ;ENCEDER EL SEMAFORO VERDE

      	RET
;---------------------------------------------

MAQ_ESTADOS:
 	MOV A, ESTADO
	RL A
	MOV DPTR, #LISTA_EST
 	JMP @A+DPTR

LISTA_EST:
 	AJMP ESPERA ; Nombre Estado 0
 	AJMP LISTO ; Nombre Estado 1
 	AJMP ESPERAR_FICHA ; Nombre Estado 2
 	AJMP ESPERAR_BOTON ; Nombre Estado 3
	AJMP ENJABONADO ; Nombre Estado 4
	AJMP TRASERA ; Nombre Estado 5
	AJMP AJUSTAR ; Nombre Estado 6
	AJMP FROTADO ; Nombre Estado 7
	AJMP DELANTERA; Nombre Estado 8
	AJMP ACLARADO ; Nombre Estado 9
	AJMP SECADO ; Nombre Estado 10
	AJMP ESTADO_FIN ; Nombre Estado 11

ESPERA :
 	ACALL MQ_EVEN_0
	RET
LISTO :
 	ACALL MQ_EVEN_1
 	RET
ESPERAR_FICHA :
 	ACALL MQ_EVEN_2
 	RET
ESPERAR_BOTON:
 	ACALL MQ_EVEN_3
 	RET
ENJABONADO:
	ACALL MQ_EVEN_4
 	RET
TRASERA:
 	ACALL MQ_EVEN_5
 	RET
AJUSTAR:
 	ACALL MQ_EVEN_6
 	RET
FROTADO:
 	ACALL MQ_EVEN_7
 	RET
DELANTERA:
 	ACALL MQ_EVEN_8
 	RET
ACLARADO:
 	ACALL MQ_EVEN_9
 	RET
SECADO:
 	ACALL MQ_EVEN_10
 	RET
ESTADO_FIN :
 	ACALL MQ_EVEN_11
 	RET
;-----------------------------------
MQ_EVEN_0:
	ACALL ME0_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_0
 	JMP @A+DPTR
LIST_EVEN_MQEV_0:
 	AJMP ME0_EV_0 ; Evento 0
	AJMP ME0_EV_1 ; SI DETECTA EL COCHE 

ME0_EV_0:
 	RET
ME0_EV_1:
	MOV ESTADO, #1
	ACALL ACCION1 ;EL COCHE ESTA PUESTO
 	RET
ME0_GEN_EV:
	JB S_PLAT, ME0_PLACA		;COMPROBAR SI SE HA PULSADO LA PLACA
	MOV EVENTO, #0		;SIEMPRE SE DA EL EVENTO 0 SI NO SE HA PULSADO LA PLACA
	RET
ME0_PLACA:
	MOV EVENTO, #1
	RET
;-----------------------------------
MQ_EVEN_1:
	ACALL ME1_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_1
 	JMP @A+DPTR
LIST_EVEN_MQEV_1:
 	AJMP ME1_EV_0 			;Evento 0
	AJMP ME1_EV_1 			;QUITAR EL COCHE
 	AJMP ME1_EV_2 			;PASAN 5 SEG Y SE AVANZA

ME1_EV_0:
 	RET
ME1_EV_1:
	MOV ESTADO, #0
	ACALL QUITAR_COCHE 		;HE QUITADO EL COCHE
 	RET
ME1_EV_2:
	ACALL PLACA_ESPERAR 		;ESPERAR 5S
	RET

ME1_GEN_EV:

	JB S_PLAT, ME1_PLACAIN		;SALTA SI ESTA EN PLACA
	JNB S_PLAT, ME1_PLACAOUT	;COMPROBAR SI SE HA DEJADO DE PULSAR LA PLACA

	MOV EVENTO, #0			;SIEMPRE SE DA EL EVENTO 0 SI NO SE HA PULSADO LA PLACA
	RET
ME1_PLACAOUT:
	MOV EVENTO, #01
	RET
ME1_PLACAIN:			
	MOV EVENTO, #02
	RET

;-----------------------------------

MQ_EVEN_2:
	ACALL ME2_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_2
 	JMP @A+DPTR
LIST_EVEN_MQEV_2:
 	AJMP ME2_EV_0 			;Evento 0
	AJMP ME2_EV_1 			;HA ENTRADO FICHA
 	AJMP ME2_EV_2 			;TIMER = 30S ALARMA
	AJMP ME2_EV_3 			;SE QUITA EL COCHE
ME2_EV_0:
 	RET
ME2_EV_1:
	ACALL METE_FICHA		;APAGA LA ALARMA SI HA SONADO Y METE FIHCA
 	MOV ESTADO, #3		
	RET
ME2_EV_2: 
	MOV FLAG_ALARMA, #1		;FLAG PARA EL TIMER DE 30S, EN EL ESTADO2 SALTA ALARMA A LOS 30S ENTONCES LO PONGO A UNO,
					;SI NO HICIESE FALTA SALTAR LA ALARMA PERO SI EL TIMER DE 30S LO PONGO A 0
	ACALL PREPARAR_ALARMA
 	RET
ME2_EV_3:
	ACALL APAGAR_ALARMA		;APAGA LA ALARMA SI HA SONADO SI QUITA EL COCHE
	MOV ESTADO, #0
	ACALL QUITAR_COCHE 		;HE QUITADO EL COCHE
 	RET

ME2_GEN_EV:
	JB S_FICHA, ME2_FICHA
	JNB S_PLAT, ME2_PLACAOUT	;COMPROBAR SI SE HA  DEJADO DE PULSAR LA PLACA
	JNB HA_SALTADO, ME2_ALARMA 	;PASAN 30 SEGS ME2_ALARMA
	MOV EVENTO, #0			;SIEMPRE SE DA EL EVENTO 0
	RET
ME2_FICHA:
	MOV EVENTO, #1
	RET
ME2_ALARMA:
	MOV EVENTO, #2
	RET
ME2_PLACAOUT:
	MOV EVENTO, #3
	RET
;-----------------------------------

MQ_EVEN_3:
	ACALL ME3_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_3
 	JMP @A+DPTR
LIST_EVEN_MQEV_3:
 	AJMP ME3_EV_0 			;Evento 0
	AJMP ME3_EV_1 			;LE DA AL BOTON
 	AJMP ME3_EV_2 			;PASAN 30S
	AJMP ME2_EV_3 			;SE QUITA EL COCHE

ME3_EV_0:
 	RET
ME3_EV_1:
	ACALL APAGAR_ALARMA		;APAGA LA ALARMA SI HA SONADO SI QUITA EL COCHE
	MOV ESTADO, #4
 	RET
ME3_EV_2:
	ACALL PREPARAR_ALARMA
 	RET
ME3_EV_3:
	ACALL APAGAR_ALARMA		;APAGA LA ALARMA SI HA SONADO SI QUITA EL COCHE
	MOV ESTADO, #0
	ACALL QUITAR_COCHE 		;HE QUITADO EL COCHE
 	RET
ME3_GEN_EV:
	JB P_START, ME3_BOTON 		;LE DA AL BOTON	
	JNB S_PLAT, ME3_PLACAOUT	;COMPROBAR SI SE HA DEJADO DE PULSAR LA PLACA
	AJMP ME3_ALARMA 		;PASAN 30 SEGS ME3_ALARMA 
	MOV EVENTO, #0			;SIEMPRE SE DA EL EVENTO 0
	RET
ME3_BOTON:
	MOV EVENTO, #1
	RET
ME3_ALARMA:
	MOV EVENTO, #2
	RET
ME3_PLACAOUT:
	MOV EVENTO, #3
	RET

;-----------------------------------

MQ_EVEN_4:
	ACALL ME4_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_4
 	JMP @A+DPTR
LIST_EVEN_MQEV_4:
 	AJMP ME4_EV_0 			; Evento 0 
	AJMP ME4_EV_1 			; SENSOR QUE DETECTA COCHE
	AJMP ME4_EV_2 			; DESPLAZA EL PUENTE 40 CM
	AJMP ME4_EV_3 			; MUEVE EL COCHE Y APAGA EV
ME4_EV_0:
 	RET
ME4_EV_1:
	AJMP ACTIVAR_EV
 	RET
ME4_EV_2:
	AJMP MOVER_4S
 	RET
ME4_EV_3:
	AJMP MOVER_COCHE
 	RET
ME4_GEN_EV:
	JB S_CAR, ME4_SENSOR 		;EL SENSOR DETECTA EL COCHE
	JB FLAG_4S, ME4_MOVER_4S	;DESPLAZAR PUENTE 4S
	JNB FLAG_MOVER, ME4_MOVER_COCHE	;MOVER EL COCHE
	MOV EVENTO, #0			;SIEMPRE SE DA EL EVENTO 0
	RET
ME4_SENSOR:
	MOV EVENTO, #1
	RET
ME4_MOVER_4S:
	MOV EVENTO, #2
	RET
ME4_MOVER_COCHE:
	MOV EVENTO, #3
	RET
;-----------------------------------

MQ_EVEN_5:
	ACALL ME5_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_5
 	JMP @A+DPTR
LIST_EVEN_MQEV_5:
 	AJMP ME5_EV_0 			 ;NO HACE NADA
	AJMP ME5_EV_1			 ;CUANDO ESTAN A 80 CM LOS RODILLOS VAN HACIA FUERA
	AJMP ME5_EV_2			 ;DETECTA CUANDO ESTAN EN SU POSICION INICIAL
	AJMP ME5_EV_3			 ;MUEVE LOS RODILLOS HACIA AL CENTRO

ME5_EV_0:
 	RET
ME5_EV_1:
	AJMP MOVER_RODILLOS_FUERA
 	RET
ME5_EV_2:
	AJMP RODILLOS_PRINCIPIO
 	RET
ME5_EV_3:
	AJMP MOVER_RODILLOS_DENTRO
 	RET
ME5_GEN_EV:
	JB FC_RV_BORDE, ME5_RODILLOS_PRINCIPIO	;LOS RODILLOS VUELVEN A SU POSICION INICAL 
	JB FC_RV_CENTRO, ME5_RODILLOS_FUERA	;LOS RODILLOS ESTAN A 80 CM EN EL CENTRO
	JNB FLAG_RODILLOS, ME5_RODILLOS_NADA	;MUEVE LOS RODILLOS HACIA EL CENTRO
	MOV EVENTO, #0
	RET
ME5_RODILLOS_FUERA:
	MOV EVENTO, #1
	RET
ME5_RODILLOS_PRINCIPIO:
	MOV EVENTO, #2
	RET
ME5_RODILLOS_NADA:
	MOV EVENTO, #3
	RET
;-----------------------------------
MQ_EVEN_6:
	ACALL ME6_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_6
 	JMP @A+DPTR
LIST_EVEN_MQEV_6:
 	AJMP ME6_EV_0 			;Evento 0
	AJMP ME6_EV_1 			;COLOCA LOS RODILLOS A 40 CM
	AJMP ME6_EV_2 			;MUEVE EL COCHE

ME6_EV_0:
 	RET
ME6_EV_1:
	AJMP MOVER_RODILLOS_6
 	RET
ME6_EV_2:
	AJMP MOVER_COCHE2
 	RET
ME6_GEN_EV:
	JNB FLAG_MOVER2, ME6_MOVER 	;MUEVE EL COCHE
	JB S_CAR, ME6_SENSOR 		;EL SENSOR DETECTA EL COCHE
	MOV EVENTO, #0			;SIEMPRE SE DA EL EVENTO 0
	RET
ME6_SENSOR:
	MOV EVENTO,#1
	RET
ME6_MOVER:
	MOV EVENTO,#2
	RET
;-----------------------------------
MQ_EVEN_7:
	ACALL ME7_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_7
 	JMP @A+DPTR
LIST_EVEN_MQEV_7:
 	AJMP ME7_EV_0 			; Evento 0
	AJMP ME7_EV_1 			; MUEVE LOS RODILLOS
	AJMP ME7_EV_2 			; PONE EL RODILLO HORIZONTAL EN SU POSICION

ME7_EV_0:
 	RET
ME7_EV_1:
	AJMP EMPEZAR_RODILLOS
 	RET
ME7_EV_2:
	AJMP DETENER_RODILLOS
 	RET
ME7_GEN_EV:
	JNB S_CAR, ME7_SUBIR_RH		;DEJA DE DETECTAR EL COCHE
	JNB FLAG_MOVER2, ME7_SENSOR	;MUEVE LOS RODILLOS Y LOS AJUSTA
	MOV EVENTO, #0			;SIEMPRE SE DA EL EVENTO 0
	RET
ME7_SENSOR:
	MOV EVENTO,#1
	RET
ME7_SUBIR_RH:
	MOV EVENTO, #2
	RET
;-----------------------------------
MQ_EVEN_8:
	ACALL ME8_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_8
 	JMP @A+DPTR
LIST_EVEN_MQEV_8:
 	AJMP ME8_EV_0 			; NO HACE NADA
	AJMP ME8_EV_1 			; CUANDO ESTAN A 80 CM LOS RODILLOS VAN HACIA FUERA
	AJMP ME8_EV_2 			; DETECTA CUANDO ESTAN EN SU POSICION INICIAL
	AJMP ME8_EV_3 			; MUEVE LOS RODILLOS HACIA AL CENTRO
	AJMP ME8_EV_4 			; MUEVE EL PUENTE 4S

ME8_EV_0:
 	RET
ME8_EV_1:
	AJMP MOVER_RODILLOS_FUERA
 	RET
ME8_EV_2:
	AJMP RODILLOS_PRINCIPIO2
 	RET
ME8_EV_3:
	AJMP MOVER_RODILLOS_DENTRO
 	RET
ME8_EV_4:
	AJMP MOVER_4S3
 	RET
ME8_GEN_EV:
	JNB FLAG_4S3, ME8_MOVER_COCHE3		;MUEVE EL PUENTE 4S
	JB FC_RV_BORDE, ME8_RODILLOS_PRINCIPIO	;DETECTA CUANDO ESTAN EN SU POS INICIAL
	JB FC_RV_CENTRO, ME8_RODILLOS_FUERA	;DETECTA CUANDO ESTAN A 80 CM
	JNB FLAG_RODILLOS1, ME8_RODILLOS_NADA	;MUEVE LOS DRODILLOS AL CENRTO
	MOV EVENTO, #0
	RET
ME8_RODILLOS_FUERA:
	MOV EVENTO, #1
	RET
ME8_RODILLOS_PRINCIPIO:
	MOV EVENTO, #2
	RET
ME8_RODILLOS_NADA:
	MOV EVENTO, #3
	RET
ME8_MOVER_COCHE3:
	MOV EVENTO, #4
	RET

;-----------------------------------
MQ_EVEN_9:
	ACALL ME9_GEN_EV
 	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_9
 	JMP @A+DPTR
LIST_EVEN_MQEV_9:
 	AJMP ME9_EV_0 			; Evento 0
	AJMP ME9_EV_1 			; SENSOR QUE DETECTA COCHE
	AJMP ME9_EV_2 			; DESPLAZA EL PUENTE 40 CM
	AJMP ME9_EV_3 			; MOVER COCHE2

ME9_EV_0:
 	RET
ME9_EV_1:
	AJMP ACTIVAR_EV2
 	RET
ME9_EV_2:
	AJMP MOVER_4S2
 	RET
ME9_EV_3:
	AJMP MOVER_COCHE3
	RET
ME9_GEN_EV:
	JB S_CAR, ME9_SENSOR 		;EL SENSOR DETECTA EL COCHE
	JB FLAG_4S, ME9_MOVER_4S	;DETECTA CUANDO TIENE QUE MOVER EL PUENTE 40 CM
	JNB FLAG_MOVER3, ME9_MOVER	;MUEVE EL COCHE
	MOV EVENTO, #0			;SIEMPRE SE DA EL EVENTO 0 Y MUEVE EL COCHE
	RET
ME9_SENSOR:
	MOV EVENTO, #1
	RET
ME9_MOVER_4S:
	MOV EVENTO, #2
	RET
ME9_MOVER:
	MOV EVENTO, #3
	RET
;-----------------------------------
MQ_EVEN_10:
	ACALL ME10_GEN_EV
	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_10
	JMP @A+DPTR

LIST_EVEN_MQEV_10:
	AJMP ME10_EV_0 			;NO HACE NADA
	AJMP ME10_EV_1 			;ACTIVAR LOS VENTILADORES PARA SECADO
	AJMP ME10_EV_2 			;HA LLEGADO AL FIN DE CARRERA
	AJMP ME10_EV_3 			;MOVER_COCHE3

ME10_EV_0:
	RET

ME10_EV_1:
	AJMP ACTIVAR_SECADO
	RET

ME10_EV_2:
	AJMP FIN_DE_CARRERA
	RET
ME10_EV_3:
	AJMP MOVER_COCHE4
	RET

ME10_GEN_EV:
	JB S_CAR, ME10_SENSOR 		;EL SENSOR DETECTA EL COCHE
	JB BPOS_START, ME10_START 	;DETECTA EL FIN DE CARRERA
	JNB FLAG_MOVER4, ME10_MOVER	;DETECTA CUANDO HAY QUE MOVER EL COCHE
	MOV EVENTO, #0			;SIEMPRE SE DA EL EVENTO 0
	RET
ME10_SENSOR:
	MOV EVENTO, #1
	RET
ME10_START:
	MOV EVENTO, #2
	RET
ME10_MOVER:
	MOV EVENTO, #3
	RET
;-----------------------------------
MQ_EVEN_11:
	ACALL ME11_GEN_EV
	MOV A, EVENTO
	RL A
	MOV DPTR, #LIST_EVEN_MQEV_11
	JMP @A+DPTR
LIST_EVEN_MQEV_11:
	AJMP ME11_EV_0 			;Evento 0
	AJMP ME11_EV_1 			;PONE EL SEMAFORO INTERMITENTE
	AJMP ME11_EV_2 			;SE QUITA EL COHE
ME11_EV_0:
	RET
ME11_EV_1:
	ACALL ACCION2
	RET
ME11_EV_2:
	SETB SEM_VERDE
	MOV ESTADO, #0
	RET
ME11_GEN_EV:
	JB BPOS_START, ME11_SEM_INTERMITENTE	;DETECTA CUANDO PONER EL SEMAFORO VERDE INTERMITENTE	
	JNB S_PLAT, ME11_PLACAOUT		;DETCETA CUANDO SE VA EL COCHE
	MOV EVENTO, #0				;SIEMPRE SE DA EL EVENTO 0
	RET
ME11_PLACAOUT:
	MOV EVENTO, #2
	RET
ME11_SEM_INTERMITENTE:
	MOV EVENTO, #1
	RET

;-----------------------------------
	

ACCION1:
	CLR SEM_VERDE
	SETB SEM_ROJO
	RET

;===================ESTADO_1===============================
QUITAR_COCHE:
	CLR SEM_ROJO
	SETB SEM_VERDE
	RET

PLACA_ESPERAR:
	JNB FLAG_PLACA, PRIMERA
	JNB S_PLAT, PLACA_OUT
	MOV A,T_CONT2
	JZ PASAN5S	
	RET
PRIMERA:
	ACALL ENCENDER_TIMER0
	MOV TH0, #01H		;HEMOS HECHO EL CALCULO DE CICLOS DE RELOJ PARA 1S USANDO LA FRECUENCIA DEL ENUNCIADO Y NOS DA QUE TENEMOS QUE INICIALIZAR EL TIMER0 EN 316
	MOV TL0, #3CH
	MOV T_CONT1, #15	;CADA 15 OVERFLOWS PASA 1S
	MOV T_CONT2, #5 
	SETB FLAG_PLACA
	JNB S_PLAT, PLACA_OUT
	RET
PLACA_OUT:
	LJMP ME1_PLACAOUT
	RET
PASAN5S:
	ACALL APAGAR_TIMER0
	MOV ESTADO, #2
	RET
;===================ESTADO_2 Y ESTADO_3===============================

PREPARAR_ALARMA:
	MOV A, ESTADO
	CJNE A, #4, ESTADO_ESTADO	
	RET

SALTADO:
	RET

ESTADO_ESTADO:
	ACALL ESTADO_ALARMA
	MOV C, FLAG_30
	JNC PRIMERA1
	RET

ESTADO_ALARMA:
	JNB AL_START, NO_SONADO
	JB AL_START, SONADO
	
NO_SONADO:
	MOV FLAG_ALARMA, #1	;FLAG PARA EL TIMER DE 30S, EN EL ESTADO2 SALTA ALARMA A LOS 30S ENTONCES LO PONGO A UNO, 
				;SI NO HICIESE FALTA SALTAR LA ALARMA PERO SI EL TIMER DE 30S LO PONGO A 0
	RET
SONADO:
	MOV FLAG_ALARMA, #0	;FLAG PARA EL TIMER DE 30S, EN EL ESTADO2 SALTA ALARMA A LOS 30S ENTONCES LO PONGO A UNO, 
				;SI NO HICIESE FALTA SALTAR LA ALARMA PERO SI EL TIMER DE 30S LO PONGO A 0
	RET

PRIMERA1:
	ACALL ENCENDER_TIMER1
	MOV TH1, #01H		;HEMOS HECHO EL CALCULO DE CICLOS DE RELOJ PARA 1S USANDO LA FRECUENCIA DEL ENUNCIADO Y NOS DA QUE TENEMOS QUE INICIALIZAR EL TIMER0 EN 316
	MOV TL1, #3CH
	MOV T_CONT1, #15	;CADA 15 OVERFLOWS PASA 1S
	MOV T_CONT2, #30
	SETB FLAG_30
	SETB HA_SALTADO
	RET 

PASAN30S:
	ACALL APAGAR_ALARMA	;APAGA LA ALARMA SI HA SONADO SI QUITA EL COCHE
	MOV ESTADO, #4
	RET

METE_FICHA:
	ACALL APAGAR_ALARMA
	MOV C, FICHA_TIPO	;MIRA TIPO_FICHA
	JNC LAVADO_NORMAL	;SI 0 LAVADO NORMAL
	AJMP LAVADO_INTENSO	;SI 1 LAVADO INTENSO
	RET
APAGAR_ALARMA:
	CLR AL_START
	RET

LAVADO_NORMAL:
	SETB LED_LNOR
	RET
LAVADO_INTENSO:
	SETB LED_LINT
	RET

;===================ESTADO_4==============================

MOVER_COCHE:
	SETB FLAG_MOVER
	JNB FLAG_AGUA, PRIMERA_ACTIVACION
	CLR BMOV_FRONT
	CLR EV_AGUA
	CLR EV_JABON
	SETB FLAG_4S
	RET

PRIMERA_ACTIVACION:
	SETB BMOV_FRONT
	RET

ACTIVAR_EV:
	CLR FLAG_MOVER
	SETB EV_AGUA
	SETB EV_JABON
	SETB FLAG_AGUA
	RET 

MOVER_4S:
	JNB BMOV_FRONT, PRIMERA_4S
	RET



PRIMERA_4S:
	ACALL ENCENDER_TIMER0
	MOV TH0, #01H		;HEMOS HECHO EL CALCULO DE CICLOS DE RELOJ PARA 1S USANDO LA FRECUENCIA DEL ENUNCIADO Y NOS DA QUE TENEMOS QUE INICIALIZAR EL TIMER0 EN 316
	MOV TL0, #3CH
	MOV T_CONT1, #15	;CADA 15 OVERFLOWS PASA 1S
	MOV T_CONT2, #4 
	SETB BMOV_FRONT
	RET


PASAN_4S:
	ACALL APAGAR_TIMER0
	CLR BMOV_FRONT
	CLR FLAG_4S
	CLR FLAG_AGUA
	MOV ESTADO, #5
	RET
;===================ESTADO_5===============================


MOVER_RODILLOS_DENTRO:
	MOV R1, ESTADO          ; Carga el valor de ESTADO en R1
    	CJNE R1, #5, C1     	; Compara con el valor 1, si no es igual salta a C1
    	SETB FLAG_RODILLOS
	JNB FICHA_TIPO, PWM0_NORMAL_FLAG
	JB FICHA_TIPO, PWM0_INTENSO_FLAG 
 	RET

C1: 
	SETB FLAG_RODILLOS1
	JNB FICHA_TIPO, PWM0_NORMAL_FLAG
	JB FICHA_TIPO, PWM0_INTENSO_FLAG 
 	RET

PWM0_NORMAL_FLAG:
	AJMP PWM0_NORMAL
	RET

PWM0_INTENSO_FLAG:
	AJMP PWM0_INTENSO
	RET

MOVIMIENTO_DENTRO:
	ACALL ENCENDER_PWMP
	SETB RV_INTO
	RET



MOVER_RODILLOS_FUERA:
	CLR RV_INTO
	SETB RV_OUTTO
 	RET


RODILLOS_PRINCIPIO:
	CLR FC_RV_CENTRO
	MOV ESTADO, #6
	RET
;===================ESTADO_6===============================
MOVER_COCHE2:
	SETB FLAG_MOVER2
	SETB BMOV_BACK
	RET
	

MOVER_RODILLOS_6:
	JB SEGUNDA_CONVERSION, PONER_RODILLOS_VE
	CLR BMOV_BACK
	ACALL TIMER_100MS
	ACALL ENCENDER_ADC
	SETB RH_DOWNTO
	RET

PONER_RODILLOS_VE:
	ACALL TIMER_100MS
	ACALL ENCENDER_ADC
	SETB RV_INTO
	RET

TIMER_100MS:
	JNB FLAG_100MS, PRIMERA_100MS
	RET

PRIMERA_100MS:
	ACALL ENCENDER_TIMER0
	MOV TH0, #01H		;HEMOS HECHO EL CALCULO DE CICLOS DE RELOJ PARA 1S USANDO LA FRECUENCIA DEL ENUNCIADO Y NOS DA QUE TENEMOS QUE INICIALIZAR EL TIMER0 EN 316
	MOV TL0, #3CH
	MOV T_CONT1, #2		;CADA 2 OVERFLOWS PASA 100MS
	SETB FLAG_100MS
	RET
PASAN_100MS:
	MOV T_CONT1, #2		;CADA 2 OVERFLOWS PASA 100MS
	MOV FLAG_ADC, ADCON
	ANL FLAG_ADC, #0X10
	MOV R3, FLAG_ADC
	CJNE R3, #0, RESULTADO_ADCI
	RET


RESULTADO_ADCI:
	ANL ADCON, #0XEF ;CLR ADCI PARA Q PUEDA VOLVER A CONVERTIR
	MOV R2, ADCH
	CJNE R2, #0x66, NO_40
	JB SEGUNDA_CONVERSION, RESULTADO_ADCI2
	CLR RH_DOWNTO
	SETB SEGUNDA_CONVERSION
	CLR FLAG_100MS
	CLR FLAG_ADC2
	RET

RESULTADO_ADCI2:
	CLR RV_INTO
	CLR FLAG_MOVER2
	CLR SEGUNDA_CONVERSION
	CLR FLAG_100MS
	MOV ESTADO, #07
	LJMP MAQ_ESTADOS
	RET

NO_40:
	ORL ADCON, #0x08	;VUELVE A INICIAR LA CONVERSION
	SETB TR0
	RET
;===================ESTADO_7===============================
EMPEZAR_RODILLOS:
	SETB BMOV_BACK
	MOV FLAG_ADC, ADCON
	ANL FLAG_ADC, #0X10
	MOV R3, FLAG_ADC
	CJNE R3, #0, PRIMERA_CONVERSION
	ACALL ENCENDER_ADC 	;ENCENDER EL ADC UNA SOLA VEZ
	ACALL TIMER_100MS  	;ESPERAR 100ms
	RET

PRIMERA_CONVERSION:
	JB SEGUNDA_CONVERSION, SEGUNDA_CONVERSION2
	MOV R5, ADCH        	;LEER VALOR DEL ADC
	SETB SEGUNDA_CONVERSION
	CLR FLAG_ADC2
	ANL ADCON, #0XEF 	;CLR ADCI PARA Q PUEDA VOLVER A CONVERTIR
	ACALL ENCENDER_ADC 	;ENCENDER EL ADC UNA SOLA VEZ
	RET

SEGUNDA_CONVERSION2:
	MOV R6, ADCH        	;LEER VALOR DEL ADC
	ANL ADCON, #0XEF 	;CLR ADCI PARA Q PUEDA VOLVER A CONVERTIR
	RET

MOVIMIENTO_RH:
	MOV A, #108       	;CARGAR L�MITE SUPERIOR
	SUBB A, R5
	JNC MIRAR_ABAJO    	;SI ES POSITIVO, EST� DENTRO DEL L�MITE SUPERIOR
	ACALL MOVER_ABAJO    	;MOVER HACIA ABAJO SI NO CUMPLE CONDICI�N
	RET                 	;REGRESAR DESPU�S DE MOVER

MIRAR_ABAJO:
	MOV A, R5         	;CARGAR L�MITE INFERIOR
	SUBB A, #96
	JC MOVER_ARRIBA     	;SI ES NEGATIVO, EST� FUERA DEL L�MITE INFERIOR
	RET                 	;REGRESAR SI NO HAY MOVIMIENTO NECESARIO

MOVER_ARRIBA:
	SETB RH_UPTO        	;MOVER HACIA ARRIBA
	CLR RH_DOWNTO
	RET                 	;REGRESAR DESPU�S DE MOVER

MOVER_ABAJO:
	SETB RH_DOWNTO      	;MOVER HACIA ABAJO
	CLR RH_UPTO
	RET                 	;REGRESAR DESPU�S DE MOVER

MOVIMIENTO_RV:
	MOV A, #108        	;CARGAR L�MITE SUPERIOR
	SUBB A, R6
	JNC MIRAR_DENTRO   	;SI ES POSITIVO, EST� DENTRO DEL L�MITE SUPERIOR
	ACALL MOVER_DENTRO 	;MOVER HACIA ADENTRO SI NO CUMPLE CONDICI�N
	RET                	;REGRESAR DESPU�S DE MOVER

MIRAR_DENTRO:
	MOV A, ADCH         	;CARGAR VALOR
	SUBB A, #96		;RESTARLE AL ADCH EL LIMITE INFERIOR
	JC MOVER_FUERA      	;SI ES NEGATIVO, EST� FUERA DEL L�MITE INFERIOR
	RET                 	;REGRESAR SI NO HAY MOVIMIENTO NECESARIO

MOVER_FUERA:
	SETB RV_OUTTO       	;MOVER HACIA AFUERA
	CLR RV_INTO
	RET                 	;REGRESAR DESPU�S DE MOVER

MOVER_DENTRO:
	SETB RV_INTO       	;MOVER HACIA ADENTRO
	CLR RV_OUTTO
	RET                 	;REGRESAR DESPU�S DE MOVER

PASAN_100MS_F:
	CLR SEGUNDA_CONVERSION
	MOV T_CONT1, #2		;CADA 2 OVERFLOWS PASA 100MS
	SETB TR0
	ACALL MOVIMIENTO_RH  	;REALIZAR EL CONTROL HORIZONTAL
	ACALL MOVIMIENTO_RV 	;REALIZAR EL CONTROL VERTICAL
	RET

FIN_FROTADO:
	ANL ADCON, #0XEF
	ACALL APAGAR_ADC
	CLR FLAG_100MS
	CLR FLAG_ADC2
	SETB FLAG_MOVER2
	ACALL APAGAR_TIMER0
	RET

DETENER_RODILLOS:
	CLR BMOV_BACK
	CLR RV_OUTTO
	CLR RV_INTO
	CLR RH_UPTO
	CLR RH_DOWNTO
	ACALL FIN_FROTADO
	ACALL SUBIR_RH_FIN
	RET

SUBIR_RH_FIN:
	SETB RH_UPTO
	JNB FC_RH_TOP, SUBIR_RH_FIN ;SUBIMOS EL RODILLO HASTA SU POS INICIAL MARCADA POR FC_RH_TOP
	CLR RH_UPTO
	MOV ESTADO, #8
	RET
	

;===================ESTADO_8===============================
RODILLOS_PRINCIPIO2:
	CLR FC_RV_CENTRO
	MOV ESTADO, #9
	RET

MOVER_4S3:
	JNB BMOV_BACK, PRIMERA_4S3
	RET



PRIMERA_4S3:
	ACALL ENCENDER_TIMER0
	MOV TH0, #01H		;HEMOS HECHO EL CALCULO DE CICLOS DE RELOJ PARA 1S USANDO LA FRECUENCIA DEL ENUNCIADO Y NOS DA QUE TENEMOS QUE INICIALIZAR EL TIMER0 EN 316
	MOV TL0, #3CH
	MOV T_CONT1, #15	;CADA 15 OVERFLOWS PASA 1S
	MOV T_CONT2, #4 
	SETB BMOV_BACK
	RET


PASAN_4S3:
	ACALL APAGAR_TIMER0
	CLR BMOV_BACK
	SETB FLAG_4S3
	RET

;===================ESTADO_9===============================

MOVER_COCHE3:
	SETB FLAG_MOVER3
	JNB FLAG_AGUA, PRIMERA_ACTIVACION2
	CLR BMOV_FRONT
	CLR EV_AGUA
	SETB FLAG_4S
	RET

PRIMERA_ACTIVACION2:
	SETB BMOV_FRONT
	RET

ACTIVAR_EV2:
	CLR FLAG_MOVER3
	SETB EV_AGUA
	SETB FLAG_AGUA
	RET 

MOVER_4S2:
	JNB BMOV_FRONT, PRIMERA_4S2
	RET



PRIMERA_4S2:
	ACALL ENCENDER_TIMER0
	MOV TH0, #01H		;HEMOS HECHO EL CALCULO DE CICLOS DE RELOJ PARA 1S USANDO LA FRECUENCIA DEL ENUNCIADO Y NOS DA QUE TENEMOS QUE INICIALIZAR EL TIMER0 EN 316
	MOV TL0, #3CH
	MOV T_CONT1, #15	;CADA 15 OVERFLOWS PASA 1S
	MOV T_CONT2, #4 
	SETB BMOV_FRONT
	RET


PASAN_4S2:
	ACALL APAGAR_TIMER0
	CLR BMOV_FRONT
	CLR FLAG_4S
	MOV ESTADO, #10
	RET

;===================ESTADO_10===============================
MOVER_COCHE4:
	SETB FLAG_MOVER4
	JNB FLAG_SECADO, PRIMERA_ACTIVACION3
	SETB BMOV_BACK
	ACALL APAGAR_PWM
	RET

PRIMERA_ACTIVACION3:
	SETB BMOV_BACK
	RET

ACTIVAR_SECADO:
	CLR FLAG_MOVER4
	JNB FICHA_TIPO, PWM1_NORMAL
	JB FICHA_TIPO, PWM1_INTENSO
	RET 

FIN_DE_CARRERA:
	CLR BMOV_BACK
	MOV ESTADO, #11
	RET
;===================ESTADO_11===============================
ACCION2:
	ACALL ENCENDER_TIMER0
	CLR BPOS_START
	CLR SEM_ROJO
	SETB SEM_VERDE
	MOV TH0, #01H		;HEMOS HECHO EL CALCULO DE CICLOS DE RELOJ PARA 1S USANDO LA FRECUENCIA DEL ENUNCIADO Y NOS DA QUE TENEMOS QUE INICIALIZAR EL TIMER0 EN 316
	MOV TL0, #3CH
	MOV T_CONT1, #15	;CADA 15 OVERFLOWS PASA 1S
	RET
;=============================================PWM============================================;

ENCENDER_PWMP:			;ENCIENDE EL PWM
	MOV PWMP, #4d
	RET
APAGAR_PWM:			;APAGA EL PWM
	MOV PWMP, #0
	MOV PWM0, #255
	MOV PWM1, #255
	RET
PWM0_NORMAL:			;VALOR DE POTENCIA RODILLOS NORMAL 50%
	MOV PWM0, #128
	ACALL MOVIMIENTO_DENTRO
	RET
PWM0_INTENSO:			;VALOR DE POTENCIA RODILLOS INTENSO 100%
	MOV PWM0, #255
	ACALL MOVIMIENTO_DENTRO
	RET
PWM1_NORMAL:			;VALOR DE POTENCIA DE LOS VENTILADORES NORMAL 50%
	MOV PWM1, #128
	ACALL ENCENDER_PWMP
	SETB FLAG_SECADO
	RET
PWM1_INTENSO:			;VALOR DE POTENCIA DE LOS VENTILADORES INTENSO 85%
	MOV PWM1, #38
	ACALL ENCENDER_PWMP
	SETB FLAG_SECADO
	RET

;=============================================ADC============================================;
ENCENDER_ADC:
	JNB SEGUNDA_CONVERSION, ADC_H
	JB SEGUNDA_CONVERSION, ADC_V
	RET

ADC_H:
	JNB FLAG_ADC2, PRIMERA_ADC1
	ANL ADCON, #0xD8		;SELECCION PUERTO 5.0 RODILLO HORIZONTAL
	ORL ADCON, #0x08		;INICIAR CONVERSION
	RET

PRIMERA_ADC1:
	ANL ADCON, #0xD8		;SELECCION PUERTO 5.0 RODILLO HORIZONTAL
	ORL ADCON, #0x08		;INICIAR CONVERSION
	SETB FLAG_ADC2
	RET
ADC_V:
	JNB FLAG_ADC2, PRIMERA_ADC2
	ANL ADCON, #0xD9		;SELECCION PUERTO 5.1 RODILLO HORIZONTAL
	ORL ADCON, #0x08		;INICIAR CONVERSION
	RET

PRIMERA_ADC2:
	ORL ADCON, #0x11		;SELECCION PUERTO 5.1 RODILLO HORIZONTAL
	ORL ADCON, #0x08		;INICIAR CONVERSION
	SETB FLAG_ADC2
	RET

APAGAR_ADC:			;APAGA EL ADC Y DESCACTIVA INTERRUPCIONES
	ANL IEN0, #00000000b
	RET


;=============================================TIMER============================================;
ENCENDER_TIMER0:		; Rutina para encender el temporizador
	MOV TMOD, #00000001B
    	ORL IEN0, #10000010b 	; Habilita interrupciones globales y del Timer 0
    	CLR T_CONT1          	; Reinicia contadores si los est�s usando
    	CLR T_CONT2
    	SETB TR0             	; Inicia el Timer 0
    	RET

APAGAR_TIMER0:			;APAGA EL TIMER
	ANL IEN0, #00000000b
        CLR TR0
	RET

ENCENDER_TIMER1:          	; Rutina para encender el temporizador
	MOV TMOD, #00010000B 	;PONER TIMER 1 EN MODO 1
    	ORL IEN0, #10001000b 	; Habilita interrupciones globales y del Timer 1
    	CLR T_CONT1          	; Reinicia contadores si los est�s usando
    	CLR T_CONT2
    	SETB TR1             	; Inicia el Timer 1
    	RET

APAGAR_TIMER1:			;APAGA EL TIMER
	ANL IEN0, #00000000b
        CLR TR1
	CLR FLAG_30
	RET
MANEJAR_INTERRUPCIONES:
    	MOV R1, ESTADO          ; Carga el valor de ESTADO en R1
    	CJNE R1, #1, CHECK1     ; Compara con el valor 1, si no es igual salta a CHECK1
    	AJMP PLACA              ; Si es igual a 1, salta a la rutina PLACA

CHECK1:
    	CJNE R1, #4, CHECK2     ; Compara con el valor 4, si no es igual salta a CHECK2
    	AJMP DESPLAZAMIENTO     ; Si es igual a 4, salta a la rutina DESPLAZAMIENTO

CHECK2:
	CJNE R1, #6, CHECK3     ; Compara con el valor 4, si no es igual salta a CHECK2
    	AJMP CONVERSION	     	; Si es igual a 4, salta a la rutina DESPLAZAMIENTO

CHECK3:
    	CJNE R1, #9, CHECK4     ; Compara con el valor 9, si no es igual salta a CHECK3
    	AJMP DESPLAZAMIENTO2    ; Si es igual a 9, salta a la rutina DESPLAZAMIENTO2

CHECK4:
	CJNE R1, #7, CHECK5
    	AJMP FROTADO_INT
    	RETI
CHECK5:
	CJNE R1, #8, CHECK6
    	AJMP DESPLAZAMIENTO3
    	RETI
CHECK6:
	AJMP SEM_INTERMITENTE   ; Si no coincide con los valores anteriores, salta a SEM_INTERMITENTE
    	RETI

SEM_INTERMITENTE:		;FUNCION DEL TIMER SEMAFORO INTERMITENTE
	PUSH PSW
	PUSH ACC
	
	CLR TR0
	MOV TH0, #01H
	MOV TL0, #3CH
	DJNZ T_CONT1, SIGUE0
	CPL SEM_VERDE		;HA PASADO 1000ms!
	MOV T_CONT1, #15
	JNB S_PLAT, FIN_TIMER0
	SETB TR0 		;VOLVEMOS A PONER EN MARCHA EL TIMER0
	POP ACC             	;Restaura el acumulador (A)
	POP PSW
	RETI

FIN_TIMER0:
	ACALL APAGAR_TIMER0
   	POP ACC             	;Restaura el acumulador (A)
	POP PSW
	RETI
	
PLACA:
	PUSH PSW
	PUSH ACC
	
	CLR TR0
	MOV TH0, #01H
	MOV TL0, #3CH
	DJNZ T_CONT1, SIGUE0	;HA PASADO 1s! SI T_CONT1 ES 0
	MOV T_CONT1, #15	;CARGAMOS OTRA VEZ 15 OVERFLOWS
	JNB S_PLAT, FIN_PLACA
	DJNZ T_CONT2, SIGUE0 	;HAN PASADO 5 SEGS		
	JNB S_PLAT, FIN_PLACA

	POP ACC
	POP PSW
	RETI

FIN_PLACA:
	ACALL APAGAR_TIMER0
	POP ACC
	POP PSW
	LJMP ME1_PLACAOUT
	RETI
	
SIGUE0:
	SETB TR0
	POP ACC
	POP PSW
	RETI
DESPLAZAMIENTO: 		;SUBRUTINA PARA LA ATENCION A LA INTERRUPCION DE DESPLAZAR EL COCHE 40 CM
	PUSH PSW
	PUSH ACC
	
	CLR TR0
	MOV TH0, #01H
	MOV TL0, #3CH
	DJNZ T_CONT1, SIGUE0	;HA PASADO 1s! SI T_CONT1 ES 0
	MOV T_CONT1, #15	;CARGAMOS OTRA VEZ 15 OVERFLOWS
	DJNZ T_CONT2, SIGUE0 	;HAN PASADO 4 SEGS
	ACALL PASAN_4S
	
	POP ACC
	POP PSW
	RETI
DESPLAZAMIENTO2: 		;SUBRUTINA PARA LA ATENCION A LA INTERRUPCION DE DESPLAZAR EL COCHE 40 CM
	PUSH PSW
	PUSH ACC
	
	CLR TR0
	MOV TH0, #01H
	MOV TL0, #3CH
	DJNZ T_CONT1, SIGUE0	;HA PASADO 1s! SI T_CONT1 ES 0
	MOV T_CONT1, #15	;CARGAMOS OTRA VEZ 15 OVERFLOWS
	DJNZ T_CONT2, SIGUE0 	;HAN PASADO 4 SEGS
	ACALL PASAN_4S2

	POP ACC
	POP PSW
	RETI
DESPLAZAMIENTO3: 		;SUBRUTINA PARA LA ATENCION A LA INTERRUPCION DE DESPLAZAR EL COCHE 40 CM
	PUSH PSW
	PUSH ACC
	
	CLR TR0
	MOV TH0, #01H
	MOV TL0, #3CH
	DJNZ T_CONT1, SIGUE0	;HA PASADO 1s! SI T_CONT1 ES 0
	MOV T_CONT1, #15	;CARGAMOS OTRA VEZ 15 OVERFLOWS
	DJNZ T_CONT2, SIGUE0 	;HAN PASADO 4 SEGS
	ACALL PASAN_4S3

	POP ACC
	POP PSW
	RETI

CONVERSION:
	PUSH PSW
	PUSH ACC
	
	CLR TR0
	MOV TH0, #01H
	MOV TL0, #3CH
	DJNZ T_CONT1, SIGUE0	;HA PASADO 100MS! SI T_CONT1 ES 0
	ACALL PASAN_100MS

	POP ACC
	POP PSW
	RETI


FROTADO_INT:
	PUSH PSW
	PUSH ACC
	
	CLR TR0
	MOV TH0, #01H
	MOV TL0, #3CH
	DJNZ T_CONT1, SIGUE0	;HA PASADO 100MS! SI T_CONT1 ES 0
	ACALL PASAN_100MS_F

	POP ACC
	POP PSW
	RETI
		

ALARMA:
	PUSH PSW
    	PUSH ACC            	;Guarda el acumulador (A)

	CLR TR1
	MOV TH1, #01H
	MOV TL1, #3CH
	DJNZ T_CONT1, SIGUE1	;HA PASADO 1s! SI T_CONT1 ES 0
	MOV T_CONT1, #15	;CARGAMOS OTRA VEZ 15 OVERFLOWS
	DJNZ T_CONT2, SIGUE1 	;HAN PASADO 30 SEGS
	AJMP ACTIVAR_ALARMA

SIGUE1:
	SETB TR1
   	POP ACC             	;Restaura el acumulador (A)
	POP PSW
	MOV A, FLAG_A
	RETI

FIN_ALARMA:
	ACALL APAGAR_TIMER1
	POP ACC
	POP PSW
	MOV A, FLAG_A
	RETI

ACTIVAR_ALARMA:
	SETB AL_START
	ACALL APAGAR_TIMER1
	POP ACC	
	POP PSW
	MOV A, FLAG_A
	RETI

NO_ALARMA:
	PUSH PSW
	PUSH ACC

	CLR TR1
	MOV TH1, #01H
	MOV TL1, #3CH
	DJNZ T_CONT1, SIGUE1	;HA PASADO 1s! SI T_CONT1 ES 0
	MOV T_CONT1, #15	;CARGAMOS OTRA VEZ 15 OVERFLOWS
	DJNZ T_CONT2, SIGUE1 	;HAN PASADO 30 SEGS
	ACALL PASAN30S
	
	ACALL APAGAR_TIMER1
	POP ACC
	POP PSW
	MOV A, FLAG_A
	RETI

;=========================================INTERRUPCIONES=======================================;
ORG 0x0B
INTERRUPCION_TIMER0:
	AJMP MANEJAR_INTERRUPCIONES
	RETI
 

ORG 0x1B
INTERRUPCION_TIMER1:
	MOV FLAG_A,A
	MOV A, FLAG_ALARMA
	JZ FLAG2
	AJMP ALARMA
	RETI

FLAG2:
	AJMP NO_ALARMA
	RETI
;==============================================END=============================================;
END

