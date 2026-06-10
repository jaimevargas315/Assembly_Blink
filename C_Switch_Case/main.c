#include <driverlib.h>

int main(void) {

  // Stop watchdog timer
  WDT_A_hold(WDT_A_BASE);

  int i = 0;
  int it_is_ONE = 0;
  int it_is_TWO = 0;

  while (1) {
    for (i = 0; i < 5; i++) {
      switch (i) {
      case 1:
        it_is_ONE = 1;
        it_is_TWO = 0;
        break;
      case 2:
        it_is_TWO = 1;
        it_is_ONE = 0;
        break;
      default:
        it_is_ONE = 0;
        it_is_TWO = 0;
        break;
      }
    }
  }

  return 0;
}
