#include <driverlib.h>

int main(void) {

  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  int i = 0;
  int it_is_TWO = 0;

  while (1) {
    for (i = 0; i < 5; i++) {
      if (i == 2) {
        it_is_TWO = 1;
      } else {
        it_is_TWO = 0;
      }
    }
  }

  return 0;
}
