#include "msp430fr2355.h"
#include <driverlib.h>

int main(void) {

  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  int e = 0b1111111111111110;
  int f = 0x0001;

  while (1) {
    e = ~e;        // invert all bits in e, 0000000000001111
    e = e | BIT7;  // set bit 7 in e        0000000010001111
    e = e & ~BIT0; // clear bit 0 in e      0000000010001110
    e = e ^ BIT4;  // toggle bit 4          0000000010011111

    e |= BIT6;  // set bit 6             0000000011011111
    e &= !BIT1; // clear bit 1           0000000011011101
    e ^= BIT3;  // toggle bit 3          0000000011010101

    f = f << 1; // bit rotation
    f = f << 2;
    f = f >> 1;
  }

  return 0;
}
