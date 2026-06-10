#include "msp430fr2355.h"
#include <driverlib.h>

int main(void) {

  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  // setup ports
  P1DIR |= BIT0;  // config P1.0 (LED1) as output
  P1OUT &= ~BIT0; // clear LED1

  P4DIR &= ~BIT1; // set P4.1 to an input (SW1)
  P4REN |= BIT1;  // enables resistor
  P4OUT |= BIT1;  // sets resistor to pull up

  PM5CTL0 &= ~LOCKLPM5; // turn on digital IO
  int i;
  int SW1;
  while (1) {
    SW1 = P4IN;  // read port 4
    SW1 &= BIT1; // clear all bits except bit 1 (SW1)
    if (SW1 == 0) {
      P1OUT ^= BIT0; // turn on LED1
    }
    for (i = 0; i < 20000; i++) {
      // delay for HMI
    }
  }
  return 0;
}
