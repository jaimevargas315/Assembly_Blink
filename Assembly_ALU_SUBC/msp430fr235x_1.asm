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
            mov.w   #Consts,    R5
            
            mov.b   @R5,        R6
            inc     R5
            mov.b   @R5,        R7
            inc     R5
            mov.w   @R5,        R8
            incd    R5
            mov.w   @R5,        R9
                        

            jmp     main


;------------------------------------------------------------------------------
;           Memory Allocation
;------------------------------------------------------------------------------
            .data                   ; go to memory @ 2000h
            .retain
Consts:     .short      1234h
            .short      5678h
            .short      9ABCh

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