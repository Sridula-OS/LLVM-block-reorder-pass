#include <stdio.h>

__attribute__((noinline))
int analyze_array(const int *values, int count, int threshold) {
    int result = 0;

    for (int i = 0; i < count; i++) {
        int value = values[i];

        if (value > threshold) {
            if ((value & 1) == 0)
                result += value;
            else
                result += value / 2;
        } else if (value < 0) {
            result -= value;
        } else {
            result--;
        }
    }

    return result;
}

int main(void) {
    int values[] = {12, -3, 41, 28, 7, 64, -9, 18};

    printf("%d\n", analyze_array(values, 8, 20));
    return 0;
}
