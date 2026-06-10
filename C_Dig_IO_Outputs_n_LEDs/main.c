#include "msp430fr2355.h"
#include <driverlib.h>

int main(void) {

  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  // setup ports
  P1DIR |= BIT0;        // config P1.0 (LED1) as output
  P1OUT &= ~BIT0;       // turn LED1 off
  PM5CTL0 &= ~LOCKLPM5; // Turn on GPIO System

  int i = 0;
  while (1) {
    P1OUT ^= BIT0; // toggle LED1
    for (i = 0; i < 0xFFFF; i++) {
      // do nothing
    }
  }

  return 0;
}
