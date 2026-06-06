;******************************************************************************
            .cdecls C,LIST,"msp430.h"  ; Include device header file
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.

            .text                           ; Assemble to Flash memory
            .retain                         ; Ensure current section gets linked
            .retainrefs

RESET       mov.w   #__STACK_END,SP         ; Initialize stack pointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT

;------------------------------------------------------------------------------
;           Main loop here
;------------------------------------------------------------------------------
init:
        bis.b   #BIT0, &P1DIR               ; sets P1.0 to output (LED1)
        bic.b   #BIT0, &P1OUT               ; clear LED1 initially

        bic.b   #BIT1, &P4DIR               ; set P4.1  to input (S1)
        bis.b   #BIT1, &P4REN               ; enable pull up/down resistor
        bis.b   #BIT1, &P4OUT               ; make the resistor a pull up
        bis.b   #BIT1, &P4IES               ; sensitivity is high-to-low

        bic.b   #LOCKLPM5,  &PM5CTL0        ; enable digital I/O
        
        bic.b   #BIT1, &P4IFG               ; clear port 4 interrupt flag register
        bis.b   #BIT1, &P4IE                ; local enable for p4.1
        eint                                ; enable global maskable interrupts 
        nop

main:

        jmp     main

;------------------------------------------------------------------------------
;           Interrupt Service Routines
;------------------------------------------------------------------------------
ISR_S1:
        xor.b   #BIT0, &P1OUT               ; toggle LED1
        bic.b   #BIT1, P4IFG                ; clear port 4 interrupt flag register
        reti
;------------------------------------------------------------------------------
;           Stack pointer Definition
;------------------------------------------------------------------------------
    .global __STACK_END
    .sect   .stack

;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
    .sect   ".reset"
    .short  RESET

    .sect   ".int22"                         ; port 4 vector address
    .short  ISR_S1