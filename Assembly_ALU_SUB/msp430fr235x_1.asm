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
            
            mov.w   #0, R4
            inc     R4
            inc     R4
            incd    R4
            incd    R4

            dec     R4
            dec     R4
            decd    R4
            decd    R4
            

            jmp     main


;------------------------------------------------------------------------------
;           Memory Allocation
;------------------------------------------------------------------------------
            .data
            .retain
Var1:       .long   0E4651FFFh
Var2:       .long   11112222h

Diff12:     .space  4

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