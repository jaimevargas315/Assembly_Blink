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
        mov.b   #0,     R4
main:
        mov.b   #-1,    R5
        tst.b   R5

        jn      Negative
        jmp     Positive
Negative:
        mov.b     #1,     R4
        jmp     main
Positive:
        mov.b     #2,     R4
        jmp main
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