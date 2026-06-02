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
            mov.b   #25,    R8
            clrc
            rla.b   R8                      ; multiply by rotating left
            rla.b   R8
            rla.b   R8
            rla.b   R8

            mov.b   #224,   R9          
            clrc
            rrc.b   R9                      ; divide by rotating right
            clrc
            rrc.b   R9
            clrc
            rrc.b   R9
            clrc
            rrc.b   R9
            clrc
            rrc.b   R9
            clrc
            rrc.b   R9
            clrc
            rrc.b   R9
            clrc
            rrc.b   R9
            clrc
            rrc.b   R9

            jmp     main                    
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