int test3(int x) {
    int y = 1;

    if (x > 10) {
        y = x * 2;

        if (y > 30)
            y += 5;
        else
            y -= 5;

    } else {
        y = x - 3;
    }

    for (int i = 0; i < 5; i++) {
        if (y > i)
            y += i;
        else
            y -= i;
    }

    return y;
}
