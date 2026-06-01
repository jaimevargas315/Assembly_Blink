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
            mov.w   #1234h, R4              ; put 1234h into R4
            mov.w   #0FACEh, R5             ; put FACEh into R5

            mov.b   #99h, R6                ; put 99h into R6
            mov.b   #0EEh, R7               ; put EEh into R7

            mov.w   #371, R8                ; put 371 into R8
            mov.b   #10101010b, R9          ; put 55h into R9
            mov.b   #'B', R10               ; put 'B' into R10
            jmp     main

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