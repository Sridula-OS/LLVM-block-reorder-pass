#include <stdio.h>

typedef struct TreeNode {
    int value;
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;

__attribute__((noinline))
int tree_score(const TreeNode *node) {
    if (node == NULL)
        return 0;

    int local;
    if (node->value >= 10)
        local = node->value;
    else
        local = -node->value;

    return local + tree_score(node->left) + tree_score(node->right);
}

int main(void) {
    TreeNode left_left = {3, NULL, NULL};
    TreeNode left = {12, &left_left, NULL};
    TreeNode right = {18, NULL, NULL};
    TreeNode root = {8, &left, &right};

    printf("%d\n", tree_score(&root));
    return 0;
}
