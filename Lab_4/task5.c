#include <stdio.h>
int main(void) {
    int n;
    if (scanf("%d", &n) != 1) return 1;
    int count = 0;
    for (int k = 1; k <= n; k++) {
        if (k % 11 != 0 && k % 5 != 0) count++;
    }
    printf("%d\n", count);
    return 0;
}
