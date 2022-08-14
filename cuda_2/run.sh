mkdir -p bin

#g++ -O3 -c cpu.cpp
#g++ -O3 -c main.cpp
#g++ -O3 -o VectorSum main.o  cpu.o
# g++ -O3 main_cpu.cpp -o bin/VectorMultiplicationCPU

# /usr/local/cuda/bin/nvcc main_gpu_ori.cu -o bin/VectorMultiplicationGPUOri


/usr/local/cuda/bin/nvcc matrixMultiple.cu -lcublas -lcudart -o bin/matrixMultiple

