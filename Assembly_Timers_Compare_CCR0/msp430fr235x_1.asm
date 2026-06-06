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
;-- setup LED
init:
        bis.b   #BIT0,  &P1DIR                ; SET P1.0 to output (LED1)
        bic.b   #BIT0,  &P1OUT                ; turn LED1 off initially
        bic.b   #LOCKLPM5, &PM5CTL0           ; enable gitital I/o
;-- setup timer B0
        bis.w   #TBCLR, &TB0CTL               ; Clear TB0
        bis.w   #TBSSEL__ACLK, &TB0CTL        ; choose ACLK
        bis.w   #MC__UP, &TB0CTL              ; put into up mode
;-- setup compare
        mov.w   #16384, &TB0CCR0              ; setup compare value
        bis.w   #CCIE, &TB0CCTL0              ; local enable for CCR0 in TB0
        nop
        eint                                  ; global enable
        nop
        bic.w   #CCIFG, &TB0CCTL0             ; clear capture compare interrupt flag

main:
        jmp main
        nop

;------------------------------------------------------------------------------
;           Interrupt Service Routines
;------------------------------------------------------------------------------
ISR_TB0_CCR0:
        xor.b   #BIT0, &P1OUT                  ; toggle LED1
        bic.w   #CCIFG, &TB0CCTL0              ; clear capture compare interrupt flag
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

    .sect   ".int43"                            ; init vector table for TB0 capture compare
    .short  ISR_TB0_CCR0