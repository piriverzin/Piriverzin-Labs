#include <stdio.h>
int main(void) {
    int n;
    if (scanf("%d", &n) != 1) return 1;
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%d", n);
    for (int i = 0; i < len; i++) {
        putchar(buf[i]);
        putchar('0');
    }
    putchar('\n');
    return 0;
}
