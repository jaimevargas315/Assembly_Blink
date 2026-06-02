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
            mov.w   #Block1, R4             ; setup initial address pointer
            
            mov.w   @R4+, R5                
            mov.w   @R4+, R6
            mov.w   @R4+, R7

            mov.b   @R4+, R8
            mov.b   @R4+, R9
            mov.b   @R4+, R10

            jmp     main
            nop

;------------------------------------------------------------------------------
;           Memory Allocation
;------------------------------------------------------------------------------
            .data                           ; go to data memory @ 2000h
            .retain                         ; leave this in 

Block1:     .short  1122h, 3344h, 5566h, 7788h, 99AAh   ; create block of constants


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