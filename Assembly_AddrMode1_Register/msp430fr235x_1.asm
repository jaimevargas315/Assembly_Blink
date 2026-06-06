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
            mov.w   PC, R4                  
            mov.w   R4, R5
            mov.w   R5, R6
            
            mov.b   PC, R7                  ; copy LSB of PC into R7
            mov.b   R7, R8                  ; copy LSB of R7 into R8
            mov.b   R8, R9                  ; copy LSB of R8 into R9

            mov.w   SP, R10
            mov.w   R10, R11
            mov.w   R11, R12

            mov.b   SP, R13
            mov.b   R13, R14
            mov.b   R14, R15

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