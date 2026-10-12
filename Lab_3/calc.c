#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr, "Usage: %s a b c\n", argv[0]);
        return 1;
    }
    int a = atoi(argv[1]);
    int b = atoi(argv[2]);
    int c = atoi(argv[3]);
    if (b == 0) {
        fprintf(stderr, "Error: division by zero\n");
        return 2;
    }
    int result = ((c - b) - b) / b;
    printf("%d\n", result);
    return 0;
}
