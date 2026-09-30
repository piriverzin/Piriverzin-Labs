#include <stdio.h>

int main(void) {
    unsigned long long n = 4825520901ULL;
    unsigned int sum = 0;
    while (n > 0) {
        sum += n % 10;
        n /= 10;
    }
    printf("%u\n", sum);
    return 0;
}
