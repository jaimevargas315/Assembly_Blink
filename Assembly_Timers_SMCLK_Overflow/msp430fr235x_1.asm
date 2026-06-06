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
;-- setup LED
            bis.b   #BIT0, &P1DIR           ; Set LED1 to output, P1.0
            bic.b   #BIT0, &P1OUT           ; clear LED1 initially
            bic.b   #LOCKLPM5, &PM5CTL0
;-- setup timer
            bis.w   #TBCLR, &TB0CTL         ; resets the timer B0
            bis.w   #TBSSEL__SMCLK, &TB0CTL ; choose SMCLK (1Mhz) as source
            bis.w   #MC__CONTINUOUS, &TB0CTL ; put timer into continuous mode

;-- setup IRQ
            bis.w   #TBIE, &TB0CTL           ; local enable for overflow IRQ
            nop
            eint
            nop                             ; global enable for maskable IRQs
            bic.w   #TBIFG, &TB0CTL         ; clear overflow flag
main:
        
            jmp main
            nop

;------------------------------------------------------------------------------
;           Interrupt Service Routines
;------------------------------------------------------------------------------
ISR_TB0_Overflow:
            xor.b   #BIT0, &P1OUT
            bic.w   #TBIFG, &TB0CTL          ; clear overflow flag
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

    .sect   ".int42"                        ; timer b0 Overflow Vector
    .short  ISR_TB0_Overflow