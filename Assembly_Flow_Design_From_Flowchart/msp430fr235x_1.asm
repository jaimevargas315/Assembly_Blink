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
        mov.w   Var1,   R4
        add.w   Var2,   R4               ; R4 = sum
        jc      Carry
        jnc     NoCarry
Carry:
        mov.w   #0,     Fit
        jmp     done
NoCarry:
        mov.w   #1,     Fit
        jmp     done
done:
        jmp     main
        nop



;------------------------------------------------------------------------------
;           Data Allocation
;------------------------------------------------------------------------------
        .data                           ; go to data memory 22000
        .retain

Var1:   .space  2
Var2:   .space  2
Fit:    .space  2
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