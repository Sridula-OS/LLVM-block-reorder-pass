#include <stdio.h>

typedef struct Node {
    int value;
    struct Node *next;
} Node;

__attribute__((noinline))
int process_list(const Node *head) {
    int total = 0;

    while (head != NULL) {
        if (head->value >= 0) {
            if ((head->value & 1) == 0)
                total += head->value;
            else
                total += 1;
        } else {
            total -= head->value;
        }

        head = head->next;
    }

    return total;
}

int main(void) {
    Node fifth = {10, NULL};
    Node fourth = {-4, &fifth};
    Node third = {7, &fourth};
    Node second = {8, &third};
    Node first = {3, &second};

    printf("%d\n", process_list(&first));
    return 0;
}
