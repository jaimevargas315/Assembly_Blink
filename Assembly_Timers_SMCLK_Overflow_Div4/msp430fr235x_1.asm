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
init:
;-- setup LEDs
            bis.b   #BIT0, &P1DIR           ; Set LED1 to output, P1.0
            bis.b   #BIT6, &P6DIR           ; Set LED6 to output, P6.6
            bic.b   #BIT0, &P1OUT           ; clear LED1 initially
            bis.b   #BIT6, &P6OUT           ; set LED2
            bic.b   #LOCKLPM5, &PM5CTL0     ; turn on digital I/O
;-- setup timer
            bis.w   #TBCLR, &TB0CTL         ; resets the timer B0
            bis.w   #TBSSEL__SMCLK, &TB0CTL ; choose SMCLK (1Mhz) as source
            bis.w   #ID__4, &TB0CTL         ; div4 in first divider stage
            bis.w   #MC__CONTINUOUS, &TB0CTL ; put timer into continuous mode

;-- setup interrupt request
            bis.w   #TBIE, &TB0CTL           ; local enable for overflow IRQ
            nop
            eint
            nop                             ; global enable for maskable IRQs
            bic.w   #TBIFG, &TB0CTL         ; clear overflow flag
main:
        
            jmp main
            nop

;------------------------------------------------------------------------------
;           Interrupt Service Routines
;------------------------------------------------------------------------------
ISR_TB0_Overflow:
            xor.b   #BIT0, &P1OUT            ; toggle LED1
            xor.b   #BIT6, P6OUT             ; toggle LED6
            bic.w   #TBIFG, &TB0CTL          ; clear overflow flag
            reti
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

    .sect   ".int42"                        ; timer b0 Overflow Vector
    .short  ISR_TB0_Overflow