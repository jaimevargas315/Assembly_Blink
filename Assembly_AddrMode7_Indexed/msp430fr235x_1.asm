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
            mov.w   #Block1, R4             ; initialize R4 to point to 2000h

            mov.w   0(R4), 8(R4)            ; copy contents at 2000h to 2008h
            mov.w   2(R4), 10(R4)           ; copy contents at 2002h to 200Ah
            mov.w   4(R4), 12(R4)           ; copy contents at 2004h to 200Ch
            mov.w   6(R4), 14(R4)           ; copy contents at 2006h to 200Eh

            jmp     main

;------------------------------------------------------------------------------
;           Memory Allocation
;------------------------------------------------------------------------------
            .data                           ; go to data memory @ 2000h
            .retain                         ; leave this in 

Block1:     .short  0AAAAh, 0BBBBh, 0CCCCh, 0DDDDh   ; create block of constants
Block2:     .space  8


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