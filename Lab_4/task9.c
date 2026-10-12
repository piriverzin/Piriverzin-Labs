#include <stdio.h>
int main(void) {
    int n;
    if (scanf("%d", &n) != 1) return 1;
    long long s = 0;
    for (int k = 1; k <= n; k++) {
        int r = k % 4;
        if (r == 1 || r == 2) s += k;
        else s -= k;
    }
    printf("%lld\n", s);
    return 0;
}
