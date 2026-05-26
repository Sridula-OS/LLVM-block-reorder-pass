int test1(int x) {
    int y = 0;

    if (x > 50) {
        y = x * 2;
    } else {
        y = x - 10;
    }

    if (y % 2 == 0) {
        y = y + 5;
    } else {
        y = y - 5;
    }

    if (y > 100) {
        y = y / 2;
    } else {
        y = y * 3;
    }

    return y;
}
