#include <iostream>
#include <cuda_runtime.h>

__global__ void addKernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

int main()
{
    const int arraySize = 5;

    int a[arraySize] = {1,2,3,4,5};
    int b[arraySize] = {10,20,30,40,50};
    int c[arraySize];

    int *d_a;
    int *d_b;
    int *d_c;

    cudaMalloc((void**)&d_a, arraySize * sizeof(int));
    cudaMalloc((void**)&d_b, arraySize * sizeof(int));
    cudaMalloc((void**)&d_c, arraySize * sizeof(int));

    cudaMemcpy(d_a, a, arraySize*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, arraySize*sizeof(int), cudaMemcpyHostToDevice);

    addKernel<<<1, arraySize>>>(d_c, d_a, d_b);

    cudaMemcpy(c, d_c, arraySize*sizeof(int), cudaMemcpyDeviceToHost);

    for(int i=0;i<arraySize;i++)
        std::cout << c[i] << " ";

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}z