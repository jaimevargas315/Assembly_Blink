#include <driverlib.h>

int main(void) {

  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  int a = 2;
  int b = 3;
  int c = 4;
  int d = 5;

  while (1) {
    b = a + b;
    d = c - d;
    b = b + 1;
    b++;
    d = d - 1;
    d--;
  }

  return 0;
}
