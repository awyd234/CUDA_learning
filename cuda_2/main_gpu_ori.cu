#include <iostream>
#include <cstdlib>
#include <sys/time.h>
#include <cuda_runtime.h>

using namespace std;

__global__
void vecMultipleKernel(float* A_d, float* B_d, float* C_d, int n)
{
    int i = threadIdx.x + blockDim.x * blockIdx.x;
    if (i < n) C_d[i] = A_d[i] + B_d[i];
}

int main(int argc, char *argv[]) {

    int n = atoi(argv[1]);
    cout << n << endl;

    size_t size = n * sizeof(float);

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


    float *da = NULL;
    float *db = NULL;
    float *dc = NULL;

    cudaMalloc((void **)&da, size * size);
    cudaMalloc((void **)&db, size * size);
    cudaMalloc((void **)&dc, size * size);

    cudaMemcpy(da,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(db,b,size,cudaMemcpyHostToDevice);
    cudaMemcpy(dc,c,size,cudaMemcpyHostToDevice);

    struct timeval t1, t2;

    int threadPerBlock = 256;
    int blockPerGrid = (n + threadPerBlock - 1)/threadPerBlock;
    printf("threadPerBlock: %d \nblockPerGrid: %d \n",threadPerBlock,blockPerGrid);

    gettimeofday(&t1, NULL);

    vecMultipleKernel <<< blockPerGrid, threadPerBlock >>> (da, db, dc, n);

    gettimeofday(&t2, NULL);

    cudaMemcpy(c,dc,size,cudaMemcpyDeviceToHost);

    //for (int i = 0; i < 10; i++) 
    //    cout << vecA[i] << " " << vecB[i] << " " << vecC[i] << endl;
    double timeuse = (t2.tv_sec - t1.tv_sec) + (double)(t2.tv_usec - t1.tv_usec)/1000000.0;
    cout << timeuse << endl;

    cudaFree(da);
    cudaFree(db);
    cudaFree(dc);

    free(a);
    free(b);
    free(c);
    return 0;
}
