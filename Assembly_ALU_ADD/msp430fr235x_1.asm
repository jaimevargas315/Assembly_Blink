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

main:
            mov.w   #371, R4
            mov.w   #465, R5
            add.w   R4, R5

            mov.w   #0FFFEh, R6
            add.w   #1h, R6

            mov.w   #0FFFFh, R7
            add.w   #1h, R7                 

            mov.b   #255, R8
            mov.b   #1, R9
            add.b   R8, R9

            mov.b   #-1, R10
            add.b   #1, R10

            mov.b   #127, R11
            add.b   #127, R11

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