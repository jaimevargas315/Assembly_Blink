#include "intrinsics.h"
#include "msp430fr2355.h"
#include <driverlib.h>

int main(void) {

  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  // setup ports
  P1DIR |= BIT0;  // confit P1.0 to an output (LED1)
  P1OUT &= ~BIT0; // clear P1.0 initially (LED1)

  P4DIR &= ~BIT1; // confit Pr.1 as input (SW1)
  P4REN |= BIT1;  // enable resistor
  P4OUT |= BIT1;  // set resistor to pull up
  P4IES |= BIT1;  // set sensitivity high-to-low

  PM5CTL0 &= ~LOCKLPM5; // turn of digital I/O

  // setup interrupt request
  P4IE |= BIT1;         // enable P4.1 IRQ
  __enable_interrupt(); // enable maskable IRQs
  P4IFG &= ~BIT1;       // clear P4.1 IRQ flag

  while (1) {
    // loop forever
  }

  return 0;
}

// Interrupt service routines
#pragma vector = PORT4_VECTOR
__interrupt void ISR_Port4_S1(void) {
  P1OUT ^= BIT0;  // toggle LED1
  P4IFG &= ~BIT1; // clear flag
}