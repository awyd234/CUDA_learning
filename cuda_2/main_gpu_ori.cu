#include <iostream>
#include <cstdlib>
#include <sys/time.h>
#include <cuda_runtime.h>

using namespace std;

__global__
void vecMultiplicationKernel(float* A_d, float* B_d, float* C_d, int n)
{
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x < n && y < n) {
        float sum = 0;
        for (int k = 0; k < n; k++) {
            sum += A_d[y * n + k] * B_d[k * n + x];
        }
        C_d[y * n + x] = sum;
    }
}

void visit_2d_array(float *data, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f ", data[i * n + j]);
        }
        printf("\n");
    }
    printf("\n");
}

void initial_matrix(float *data, int n) {
    for (int i = 0; i < n; i++) {
        data[i] = rand() / double(RAND_MAX);
    }
}

int main(int argc, char *argv[]) {

    int n = atoi(argv[1]);
    cout << n << endl;

    size_t size = n * n * sizeof(float);

    // host memery
    float *a = (float *)malloc(size);
    float *b = (float *)malloc(size);
    float *c = (float *)malloc(size);

    initial_matrix(a, n * n);
    initial_matrix(b, n * n);


    float *da = NULL;
    float *db = NULL;
    float *dc = NULL;

    cudaMalloc((void **)&da, size);
    cudaMalloc((void **)&db, size);
    cudaMalloc((void **)&dc, size);

    cudaMemcpy(da,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(db,b,size,cudaMemcpyHostToDevice);
    cudaMemcpy(dc,c,size,cudaMemcpyHostToDevice);

    struct timeval t1, t2;

    // int threadPerBlock = 256;
    // int blockPerGrid = (n + threadPerBlock - 1)/threadPerBlock;
    // printf("threadPerBlock: %d \nblockPerGrid: %d \n",threadPerBlock,blockPerGrid);

    int dimx = 5, dimy = 5;
    dim3 block(dimx, dimy);
    dim3 grid((n + block.x - 1) / block.x, (n + block.y - 1)/block.y);

    gettimeofday(&t1, NULL);

    vecMultiplicationKernel <<< block, grid >>> (da, db, dc, n);

    gettimeofday(&t2, NULL);

    cudaMemcpy(c,dc,size,cudaMemcpyDeviceToHost);

    //for (int i = 0; i < 10; i++) 
    //    cout << vecA[i] << " " << vecB[i] << " " << vecC[i] << endl;
    double timeuse = (t2.tv_sec - t1.tv_sec) + (double)(t2.tv_usec - t1.tv_usec)/1000000.0;
    cout << timeuse << endl;

    cudaFree(da);
    cudaFree(db);
    cudaFree(dc);

    // visit_2d_array(a, n);
    // visit_2d_array(b, n);
    // visit_2d_array(c, n);

    free(a);
    free(b);
    free(c);
    return 0;
}
