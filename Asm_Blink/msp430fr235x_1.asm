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
            nop                             ; STABILIZATION 1: Gives debugger a structural frame breath

;------------------------------------------------------------------------------
;           Main loop here
;------------------------------------------------------------------------------

init:
            bic.w   #LOCKLPM5, &PM5CTL0     ; Disable the GPIO power-on HighZ
            
            bis.b   #01h,   &P1DIR          ; Setting the P1.0 as an output (P1.0 = LED1)
            mov.b   #00h,   &P1OUT          ; Initialize P1.0 to a known low state
main:
            xor.b   #01h,   &P1OUT          ; toggle P1.0 (LED1)

            mov.w   #0FFFFh, R4             ; puts big number in R4
delay:      
            dec.w   R4                      ; decrement R4
            jnz     delay                   ; repeat until R4 = 0
            
            nop                             ; STABILIZATION 2: Breaks up the loop pipeline back-to-back branch
            jmp     main                    ; repeat main loop forever

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