#include "intrinsics.h"
#include "msp430fr2355.h"
#include <driverlib.h>

int main(void) {
  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  // setup ports
  P1DIR |= BIT0;        // set P1.0 to an output
  P1OUT &= ~BIT0;       // clear LED1 initially
  PM5CTL0 &= ~LOCKLPM5; // turn on GPIO

  // setup timer
  TB0CTL |= TBCLR;          // reset timer
  TB0CTL |= TBSSEL__SMCLK;  // clock = SMCLK (1MHz)
  TB0CTL |= MC__CONTINUOUS; // mode = continuous
  TB0CTL |= ID__4;          // divide by 4 fo get 250kHz

  // setup TB0 interrupt request
  TB0CTL |= TBIE;       // local enable for Tb0 overflow
  __enable_interrupt(); // enable maskable IRQs
  TB0CTL &= ~TBIFG;     // clear IRQ flag

  while (1) {
    // loop forever
  }

  return 0;
}
// interrupt service routines
#pragma vector = TIMER0_B1_VECTOR
__interrupt void ISR_TB0_Overflow(void) {
  P1OUT ^= BIT0;    // toggle LED1
  TB0CTL &= ~TBIFG; // clear interrupt request flag
}