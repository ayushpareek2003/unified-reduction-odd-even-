# Unified Reduction

**Unified Reduction** is a CUDA-based function that performs a reduction sum on an array, optimized for both odd and even strides simultaneously. This implementation leverages several performance optimizations to improve the efficiency of parallel reduction algorithms.

## Key Optimizations:
- **Thread Coalescing**: Memory access is optimized by coalescing memory requests, ensuring threads access contiguous memory regions.
- **Shared Memory Usage**: Reduces global memory latency by utilizing shared memory for faster data access.
- **Thread Divergence Reduction**: Minimizes control flow divergence among threads, ensuring uniform execution within a warp.
- **Load Balancing**: Distributes workloads evenly across threads to maximize GPU resource utilization.
- **Branch Minimization**: Reduces branches to prevent costly warp divergence.
- **Memory Access Reduction**: Minimizes memory access operations using shared memory and optimized patterns.
- **Efficient Synchronization**: Reduces idle time with efficient thread synchronization.

## Requirements

To use this repository, you'll need:
- CUDA Toolkit (version 11.0 or higher)
- A compatible GPU

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ayushpareek2003/unified-reduction-odd-even-.git
   cd unified-reduction-odd-even-
   nvcc kernel_odd_even_stride.cu
