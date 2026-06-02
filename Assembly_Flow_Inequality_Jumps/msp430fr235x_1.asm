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
        mov.b   #-101,   R5
        cmp.b   #99,     R5                  ; compare 1 and R5

        jge     ItIsGreaterOrEqual           ; jump if greater than 
        jl      ItIsLessThan                 ; jump if less than 
ItIsGreaterOrEqual:
        mov.b   #1,     R4
        jmp     main
        nop
ItIsLessThan:
        mov.b   #2,     R4
        nop
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