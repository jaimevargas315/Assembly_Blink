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
            bis.b   #BIT0,  &P1DIR          ; set p1.0 to output (LED1)
            bic.b   #BIT0,  &P1OUT          ; clear LED1 initially
            bic.b   #LOCKLPM5, &PM5CTL0     ; turn on digital I/O
;-- setup timer
            bis.w   #TBCLR, &TB0CTL         ; clears timer
            bis.w   #TBSSEL__ACLK, &TB0CTL  ; select ACLK as source
            bis.w   #MC__CONTINUOUS, &TB0CTL ; continuous mode
            bis.w   #CNTL_1, TB0CTL         ; puts timer into 12-bit mode
;-- setup IRQ
            bis.w   #TBIE, TB0CTL           ; local enable for timer overflow
            nop
            bis.w   #GIE, SR                ; global enable for maskables
            nop
            bic.w   #TBIFG, TB0CTL          ;clear flag
main:
            jmp main
            nop
;------------------------------------------------------------------------------
; Interrupt service routines
;------------------------------------------------------------------------------
ISR_TB0_Overflow
            xor.b   #BIT0, &P1OUT           ; toggle LED1
            bic.w   #TBIFG, TB0CTL          ; clear flag
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

    .sect   ".int42"                        ; Timer B0 overflow vector
    .short  ISR_TB0_Overflow
