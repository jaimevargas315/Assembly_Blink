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
        bis.b   #BIT0,  &P1DIR                ; SET P1.0 TO OUTPUT
        bic.b   #BIT0,  &P1OUT                ; turn LED1 off
        bic.b   #LOCKLPM5, &PM5CTL0           ; enable gitital I/o
;-- setup timer B0
        bis.w   #TBCLR, &TB0CTL               ; Clear TB0
        bis.w   #TBSSEL__ACLK, &TB0CTL        ; choose ACLK
        bis.w   #MC__CONTINUOUS, &TB0CTL      ; put into continuous mode

;-- setup overflow IRQ
        bis.w   #TBIE, &TB0CTL                ; local enable for TB0 overflow
        nop                                   
        eint                                  ; enable global for maskables
        nop
        bic.w   #TBIFG, &TB0CTL               ; clear flag for first use

main:
        jmp main
        nop

;------------------------------------------------------------------------------
;           Interrupt Service Routines
;------------------------------------------------------------------------------
ISR_TB0_Overflow:
        xor.b   #BIT0, &P1OUT                  ; toggle LED1
        bic.w   #TBIFG, &TB0CTL                ; clear flag for first use
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

    .sect   ".int42"                            ; init vector table for TB0 overflow
    .short  ISR_TB0_Overflow