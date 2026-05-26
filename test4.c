int unpredictable(int x, int y) {

    int result = 0;

    for (int i = 0; i < 100; i++) {

        if ((x * y + i) % 2)
            result += i;
        else
            result -= i;
    }

    return result;
}
