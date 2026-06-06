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
        bis.b   #BIT0,  &P1DIR          ; set P1.0 to OUTPUT (LED1)
        bic.b   #BIT0,  &P1OUT          ; set initial value of LED1 = OFF  

        bic.b   #BIT1,  &P4DIR          ; setput p4.1 as input (S1)
        bis.b   #BIT1,  &P4REN          ; enable pullup/down resistor on p4.1
        bis.b   #BIT1,  &P4OUT          ; set resistor as pullup

        bic.b   #LOCKLPM5, &PM5CTL0     ; enable Digital IO

main:

poll_S1:
        bit.b   #BIT1,  &P4IN           ; test P4.1
        jnz     poll_S1                 ; stay in polling loop

toggle_LED1:
        xor.b   #BIT0,  &P1OUT          ; toggle LED1
;-----------------------------------------------------
        mov.w   #0FFFFh, R4
delay:                                  ; for HMI
        dec.w   R4
        jnz     delay
;----------------------------------------------------
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