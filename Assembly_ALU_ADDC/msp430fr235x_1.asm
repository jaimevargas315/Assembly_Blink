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
           mov.w    #Var1, R4
           mov.w    #Var2, R5
           mov.w    #Sum12, R6

           mov.w    0(R4), R7
           mov.w    0(R5), R8
           add.w    R7, R8                  ; add lower 16 bits 
           mov.w    R8, 0(R6)

           mov.w    2(R4), R7
           mov.w    2(R5), R8
           addc.w   R7, R8                  ; add upper 16 bits with carry
           mov.w    R8, 2(R6)

            jmp     main

;------------------------------------------------------------------------------
;           Memory Allocation
;-----------------------------------------------------------------------------

            .data                               ; go to data memory @ 2000
            .retain
                                                
Var1:       .long   0E371FFFFh
Var2:       .long   11112222h
Sum12:      .space  4 


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