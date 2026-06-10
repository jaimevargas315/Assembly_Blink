;******************************************************************************
            .cdecls C,LIST,"msp430.h"       ; Include device header file
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
; setup ports
        bis.b   #BIT0, &P1DIR                ; set p1.0 to output (LED1)
        bic.b   #BIT0, &P1OUT                ; set LED1 initially off

        bic.b   #BIT1, P4DIR                 ; SET P4.1 TO INPUT (SW1)
        bis.b   #BIT1, P4REN                 ; enable resistor
        bis.b   #BIT1, P4OUT                 ; set to pull up
        bis.b   #BIT1, &P4IES                ; IRQ sense to high to low

        bic.b   #LOCKLPM5, &PM5CTL0          ; turn on digital I/O

; setup interrupt requests for SW1
        bis.b   #BIT1, &P4IE                 ; local enable for SW1
        nop
        eint                                 ; enable global interrupts
        nop
        bic.b   #BIT1, &P4IFG                ; CLEAR FLAG
; setup timer
        bis.w   #TBCLR, &TB0CTL              ; clear timer
        bis.w   #TBSSEL__ACLK, &TB0CTL       ; choose ACLK
        bis.w   #ID__8, &TB0CTL              ; div-by-4 in 1st stage
        bis.w   #MC__CONTINUOUS, &TB0CTL     ; continuous mode 
; setup capture
        bis.w   #CAP, &TB0CCTL0              ; puts in capture mode
        bis.w   #CM__BOTH, &TB0CCTL0         ; both edge sensitivity
        bis.w   #CCIS__GND, &TB0CCTL0        ; input signal = GND
; init R4
        mov.w   #0, R4                       
main:
        jmp main
        nop

;------------------------------------------------------------------------------
;           Interrupt Service Routines
;------------------------------------------------------------------------------
ISR_S1:
        xor.b   #BIT0, P1OUT                 ; toggle LED
        xor.w   #CCIS0, &TB0CCTL0            ; cause capture
        mov.w   &TB0CCR0, R4                 ; store off value
        bic.b   #BIT1, &P4IFG                ; clear flag
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

    .sect       ".int22"                     ; p4 vector
    .short ISR_S1
