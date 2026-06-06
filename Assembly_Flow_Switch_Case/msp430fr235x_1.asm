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

                mov.w   #0, R14
                mov.w   #0, R15
while:
switch:
                cmp.w   #0, R14
                jz      case0
                cmp.w   #1, R14
                jz      case1
                cmp.w   #2, R14
                jz      case2
                cmp.w   #3, R14
                jz      case3
                jmp     default

case0:          mov.w   #1, R15
                jmp     end_switch

case1:          mov.w   #2, R15
                jmp     end_switch

case2:          mov.w   #4, R15
                jmp     end_switch

case3:          mov.w   #8, R15
                jmp     end_switch
                
default:        mov.w   #0, R15

end_switch:

end_while:
                jmp     while
                nop



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