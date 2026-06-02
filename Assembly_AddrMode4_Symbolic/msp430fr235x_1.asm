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
            mov.w   Const1, R4              ; copy contents of Const1 into R4
            mov.w   R4, Var1                

            mov.w   Const2, R5
            mov.w   R5, Var2
            
            jmp     main
            nop

;------------------------------------------------------------------------------
;           Memory Allocation
;------------------------------------------------------------------------------
            .data                           ; go to data memory
            .retain                         ; leave this in 

Const1:     .short  1234h                   ; setup constant 1234h @ 2000h
Const2:     .short  0CAFEh                  ; setup constant 0CAFEh @ 2002h

Var1:       .space  2                       ; reserve 2 bytes @ 2004h
Var2:       .space  2                       ; reserve 2 bytes @ 2006h

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