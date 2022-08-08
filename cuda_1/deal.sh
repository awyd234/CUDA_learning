mkdir -p bin

#g++ -O3 -c cpu.cpp
#g++ -O3 -c main.cpp
#g++ -O3 -o VectorSum main.o  cpu.o
g++ -O3 main_cpu.cpp -o bin/VectorSumCPU

/usr/local/cuda/bin/nvcc main_gpu.cu -o bin/VectorSumGPU

