#include <stdio.h>

typedef struct {
    int marks;
    int active;
    int attendance;
} Student;

__attribute__((noinline))
int process_students(const Student *students, int count) {
    int score = 0;

    for (int i = 0; i < count; i++) {
        if (!students[i].active)
            continue;

        if (students[i].attendance < 75) {
            score -= 10;
        } else if (students[i].marks >= 50) {
            score += students[i].marks;
        } else {
            score -= students[i].marks / 2;
        }
    }

    return score;
}

int main(void) {
    Student students[] = {
        {82, 1, 91},
        {44, 1, 88},
        {67, 0, 95},
        {73, 1, 62},
        {59, 1, 79},
    };

    printf("%d\n", process_students(students, 5));
    return 0;
}
