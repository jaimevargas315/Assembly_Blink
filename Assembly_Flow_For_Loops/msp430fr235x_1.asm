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
for1:
        mov.w   R4, Var1
        inc     R4
        cmp.w   #4, R4
        jnz     for1
end_for1:

        mov.w  #10, R4
for2:

        mov.w   R4, Var1
        decd    R4
        tst.w   R4
        jge     for2
        
end_for2:

        jmp     main
        nop


;------------------------------------------------------------------------------
;           Data Allocation
;------------------------------------------------------------------------------
        .data                                   ; go to data mem @ 2000
        .retain
Var1:   .space  2

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