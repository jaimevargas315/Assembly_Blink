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
            mov.w   #2000h, R4              ; put 2000h into R4 to act as pointer
            mov.w   @R4, R5                 ; put contents of address held in R4 into R5

            mov.w   #Const2, R6             ; put 2002h into R6 to act as a pointer
            mov.w   @R6, R7                 ; put contents of address held in R6 into R7

            jmp     main
            nop
            

;------------------------------------------------------------------------------
;           Memory Allocation
;------------------------------------------------------------------------------
            .data                           ; go to data memory @ 2000h
            .retain                         ; leave this in 

Const1:     .short  0DEADh                  ; setup constant DEADh @ 2000h
Const2:     .short  0BEEFh                  ; setup constant BEEFh @ 2002h

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