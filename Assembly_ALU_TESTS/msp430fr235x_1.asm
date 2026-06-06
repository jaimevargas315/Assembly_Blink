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
            mov.b   #00010000b, R4          ; is bit 7 a 1? 
            bit.b   #10000000b, R4          ; is bit 4 a 1?
            bit.b   #00010000b, R4          ; if yes then Z=0 , 00000000
                                            ; if no then Z=1  , 00010000

            mov.b   #99, R5                 ; compare two values
            cmp.b   #99, R5                 ; if match, Z=1
            cmp.b   #77, R5                 ; if not, Z=0


            mov.b   #-99, R6                ; show flags
            tst.b   R6                      
            
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