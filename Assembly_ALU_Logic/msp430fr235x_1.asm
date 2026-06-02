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
            mov.b   #10101010b, R4
            inv.b   R4
            
            mov.b   #11110000b, R5          
            and.b   #00111111b, R5          ; clear bits 6 and 7

            mov.b   #00010000b, R6          ; is b7 a 1 or a 0?
            and.b   #10000000b, R6          

            mov.b   #00010000b, R7          ; is b4 a 1 or 0?
            and.b   #00010000b, R7 

            mov.b   #11000001b, R8
            or.b    #00011111b, R8          ; set bits 4:0

            mov.b   #01010101b, R9
            xor.b   #11110000b, R9          ; toggle
            xor.b   #00001111b, R9          ; toggle

            jmp     main
            nop


;------------------------------------------------------------------------------
;           Memory Allocation
;------------------------------------------------------------------------------


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