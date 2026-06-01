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
            mov.b  #00000001, R4
            clrc                            ; C=0                          
            rla.b   R4
            rla.b   R4
            rla.b   R4
            rla.b   R4
            rla.b   R4
            rla.b   R4
            rla.b   R4
            rla.b   R4
            rla.b   R4

            mov.b  #10000000, R5
            clrc                            ; C=0                          
            rra.b   R5
            rra.b   R5
            rra.b   R5
            rra.b   R5
            rra.b   R5
            rra.b   R5
            rra.b   R5
            rra.b   R5
            rra.b   R5
            jmp     main                    



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