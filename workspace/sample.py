from numba import cuda

# CUDAが利用可能かどうかを確認
is_cuda_available = cuda.is_available()

print(f"CUDA is available: {is_cuda_available}")

if is_cuda_available:
    # 利用可能なCUDAデバイスの数を表示
    num_devices = cuda.gpus.lst
    print(f"Number of CUDA devices available: {len(num_devices)}")
    for i in range(len(num_devices)):
        device = cuda.gpus[i]
        with device:
            print(f"CUDA Device {i}: {cuda.get_current_device().name}")
else:
    print("CUDA is not available. Check your installation and try again.")
