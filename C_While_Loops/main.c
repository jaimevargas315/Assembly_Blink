#include <driverlib.h>

int main(void) {

  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  int count = 0;
  while (1) {
    count = count + 1;
  }

  return 0;
}
