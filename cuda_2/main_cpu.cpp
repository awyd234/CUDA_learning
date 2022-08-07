#include <iostream>
#include <cstdlib>
#include <sys/time.h>

using namespace std;

void vecMultiple(float** A, float** B, float** C, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            for (int k = 0; k < n; k++) {
                C[i][j] += A[i][k] + B[k][j];
            }
        }
    }
}

int main(int argc, char *argv[]) {

    int n = atoi(argv[1]);
    cout << n << endl;

    // host memery
    float **a = (float **)malloc(n * sizeof(float*));
    float **b = (float **)malloc(n * sizeof(float*));
    float **c = (float **)malloc(n * sizeof(float*));

    for (int i = 0; i < n; i++) {
        a[i] = (float *)malloc(n * sizeof(float));
        b[i] = (float *)malloc(n * sizeof(float));
        c[i] = (float *)malloc(n * sizeof(float));

        for (int j = 0; j < n; j++) {
            a[i][j] = rand() / double(RAND_MAX);
            b[i][j] = rand() / double(RAND_MAX);
        }
    }

    struct timeval t1, t2;

    gettimeofday(&t1, NULL);

    vecMultiple(a, b, c, n);

    gettimeofday(&t2, NULL);

    //for (int i = 0; i < 10; i++) 
    //    cout << vecA[i] << " " << vecB[i] << " " << vecC[i] << endl;
    double timeuse = (t2.tv_sec - t1.tv_sec) + (double)(t2.tv_usec - t1.tv_usec)/1000000.0;
    cout << timeuse << endl;

    free(a);
    free(b);
    free(c);
    return 0;
}
