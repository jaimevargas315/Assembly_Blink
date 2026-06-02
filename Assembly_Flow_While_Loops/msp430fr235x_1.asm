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

while1:                                     ; while var == 3
        cmp.w   #3, Var1                    ; Var1 - 3 = ?
        jnz     end_while1

        mov.w   #1, Var2
        jmp     while1
end_while1:

while2:
        mov.w   #2, Var2
        jmp     while2
        nop
end_while2:
;------------------------------------------------------------------------------
;           Memory Allocation
;------------------------------------------------------------------------------
        .data
        .retain
Var1:   .short  3
Var2:    .space  2

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