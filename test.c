#include <stdio.h>

int foo(int x) {
    int y = 0;

    // First branch
    if (x > 10) {
        y = x * 2;
    } else {
        y = x - 2;
    }

    // Second branch
    if (y > 20) {
        y += 5;
    } else {
        y -= 5;
    }

    // Loop (very important for branch probability)
    for (int i = 0; i < 5; i++) {
        if (y % 2 == 0) {
            y += i;
        } else {
            y -= i;
        }
    }

    // Final branch
    if (y > 50) {
        return y;
    } else {
        return -y;
    }
}

int main() {
    printf("%d\n", foo(15));
    return 0;
}
