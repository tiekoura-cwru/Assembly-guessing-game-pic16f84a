; LAB2_guessing_game.asm
; Tiekoura Ouattara

; Cycles output bits RB5-0 according to the required Pin Assignments
; Reads G1 input from RA0
; Reads G2 input from RA1
; Reads G3 input from RA2
; Reads G4 input from RA3
	
; There is a delay of approximately 1.0 seconds from one state to the next
; This delay is created using a 32*256 double loop
; The loop delay is approx 32 * 256 * 3 CPU cycles 
; Using an oscillator frequeny of 100 kHz, a CPU cycle is 40 usec
; Therefore, the loop delay is about 986.52 msec 
 
; CPU configuration
; (16F84 with RC osc, watchdog timer off, power-up timer on)

	processor 16f84A
	include <p16F84A.inc>
	__config _RC_OSC & _WDT_OFF & _PWRTE_ON

; some handy macro definitions

IFCLR macro fr,bit,label
	btfsc fr,bit ; if (! fr.bit) then execute code following macro
	goto label ; else goto label
	  endm


MOVLF macro lit,fr
	movlw lit
	movwf fr
	  endm

MOVFF macro from,to
	movf from,W
	movwf to
  	  endm

; file register variables

nextS equ 0x0C 	; next state (output)
octr equ 0x0D	; outer-loop counter for delays
ictr equ 0x0E	; inner-loop counter for delays

; state definitions for Port B

L1 equ B'00000001' ; state S1
L2 equ B'00000010' ; state S2
L3 equ B'00000100' ; state S3
L4 equ B'00001000' ; state S4
ERR equ B'00010000' ; SERR
WIN equ B'00100000' ; Win

; input bits on Port A

G1 equ 0
G2 equ 1
G3 equ 2
G4 equ 3

; beginning of program code

	org 0x00	; reset at address 0
reset:	goto	init	; skip reserved program addresses	

	org	0x08 	; beginning of user code
init:	
; set up RB5-0 as outputs
	bsf	STATUS,RP0	; switch to bank 1 memory (not necessary in PIC18)
	MOVLF B'11000000',TRISB	; RB7-6 are not being used so I leave them as inputs, RB5-0 are outputs 
	bcf	STATUS,RP0	; return to bank 0 memory (not necessary in PIC18)

; initialize state variables
	MOVLF	L1,nextS ; nextS = S1
	MOVFF	nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current 
	call delay
	goto State1

State1:	; here begins the main program loop
	; test inputs, and compute next state
    IFCLR PORTA, G2, SERR ;   if (!G2) execute code following this line
    IFCLR PORTA, G3, SERR ;   else if (!G3) execute code following this line
    IFCLR PORTA, G4, SERR ;   else if (!G4) execute code following this line
    IFCLR PORTA, G1, WON ;   else if (!G1) execute code following this line
    MOVLF L2, nextS ;               nextS = L2;	
    MOVFF nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current
    call delay
    goto State2
    
State2:
    IFCLR PORTA, G1, SERR ;   if (!G1)
    IFCLR PORTA, G3, SERR ;   else if (!G3)
    IFCLR PORTA, G4, SERR ;   else if (!G4)
    IFCLR PORTA, G2, WON ;   else if (!G2) 
    MOVLF L3, nextS ;               nextS = L3;	
    MOVFF nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current
    call delay
    goto State3  
    
State3:
    IFCLR PORTA, G1, SERR ;   if (!G1)
    IFCLR PORTA, G2, SERR ;   else if (!G2)
    IFCLR PORTA, G4, SERR ;   else if (!G4)
    IFCLR PORTA, G3, WON ;   else if (!G3)
    MOVLF L4, nextS ;               nextS = L4;	
    MOVFF nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current
    call delay
    goto State4  
    
State4:
    IFCLR PORTA, G1, SERR ;   if (!G1)
    IFCLR PORTA, G2, SERR ;   else if (!G2)
    IFCLR PORTA, G3, SERR ;   else if (!G4)
    IFCLR PORTA, G4, WON ;   else if (!G4)
    MOVLF L1, nextS ;               nextS = L1;
    MOVFF nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current
    call delay
    goto State1 

WON:
    MOVLF WIN, nextS ;            nextS = WIN(SOK);
    MOVFF nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current
    call delay
    IFCLR PORTA, G1, WON ;   if (!G1)
    IFCLR PORTA, G2, WON ;   else if (!G2)
    IFCLR PORTA, G3, WON ;   else if (!G3)
    IFCLR PORTA, G4, WON ;   else if (!G4)
    MOVLF L1, nextS ;               nextS = L1;	
    MOVFF nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current
    call delay; delay so that the user can see
    goto State1
    
SERR:
    MOVLF ERR, nextS ;               nextS = ERR;
    MOVFF nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current
    call delay
    IFCLR PORTA, G1, SERR ;   if (!G1)
    IFCLR PORTA, G2, SERR ;   else if (!G2)
    IFCLR PORTA, G3, SERR ;   else if (!G3)
    IFCLR PORTA, G4, SERR ;   else if (!G4)
    MOVLF L1, nextS ;               nextS = L1;	
    MOVFF nextS,PORTB ; PORTB = nextS, i.e. PORTB is the current
    call delay      ; delay
    goto State1
		
delay: ; create a delay of about 0.5 seconds
	MOVLF	d'32',octr ; initialize outer loop counter to 32
d1:	clrf	ictr	; initialize inner loop counter to 256
d2: decfsz	ictr,F	; if (--ictr != 0) loop to d2
	goto 	d2		 	
	decfsz	octr,F	; if (--octr != 0) loop to d1 
	goto	d1 
return

	end		; end of program code		










