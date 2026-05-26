int test2(int x) {
    int sum = 0;

    for (int i = 0; i < 20; i++) {

        if (x > i) {
            sum += i;
        } else {
            sum -= i;
        }

        if (sum % 3 == 0) {
            sum += 2;
        } else {
            sum -= 2;
        }
    }

    return sum;
}
