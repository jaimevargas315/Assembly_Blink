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
        bis.b   #BIT0,     &P1DIR      ; set P1DIR(0) to OUTPUT
        bic.b   #LOCKLPM5, &PM5CTL0    ; enable Dig IO
main:
        bis.b   #BIT0,  &P1OUT         ; turn on LED1 (P1.0)
        bic.b   #BIT0,  &P1OUT         ; turn off LED1 (P1.0)


        jmp     main
        nop



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