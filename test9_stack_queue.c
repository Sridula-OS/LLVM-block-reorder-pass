#include <stdio.h>

typedef struct {
    int data[8];
    int top;
} Stack;

typedef struct {
    int data[8];
    int front;
    int rear;
} Queue;

__attribute__((noinline))
int exercise_stack_queue(const int *values, int count) {
    Stack stack = {{0}, -1};
    Queue queue = {{0}, 0, 0};
    int total = 0;

    for (int i = 0; i < count; i++) {
        if ((values[i] & 1) == 0) {
            if (stack.top < 7)
                stack.data[++stack.top] = values[i];
        } else {
            if (queue.rear < 8)
                queue.data[queue.rear++] = values[i];
        }
    }

    while (stack.top >= 0) {
        int value = stack.data[stack.top--];
        if (value > 10)
            total += value;
        else
            total -= value;
    }

    while (queue.front < queue.rear) {
        int value = queue.data[queue.front++];
        if (value > 10)
            total += value * 2;
        else
            total += value;
    }

    return total;
}

int main(void) {
    int values[] = {4, 15, 8, 3, 22, 11, 6, 19};

    printf("%d\n", exercise_stack_queue(values, 8));
    return 0;
}
