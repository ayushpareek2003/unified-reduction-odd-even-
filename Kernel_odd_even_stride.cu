#include "cuda_runtime.h"
#include <stdio.h>
#include <iostream>
#include <stdio.h>

__global__ void reduction_sum_normal(float* values,float* sum, int len){
    // printf("at thread %d \n",threadIdx.x);
    int l=2*threadIdx.x;

    for(int st=1;st<len;st*=2){

        if(threadIdx.x % st==0 && l+st<len){
            printf("sorted %d and %d \n",l,l+st);
            values[l]+=values[l+st];
            
        }

        __syncthreads();

        
    }

    if(threadIdx.x==0){
        *sum=values[0];
    }
}


#define blockidm 37

__global__ void reduction_sum_shared(float* values,float* sum, int len){

    __shared__ float blockmem[blockidm];
    int i=threadIdx.x;
    if(blockidm+i<len){

        
        printf(" first go sorted %d and %d \n",i,i+blockidm);
        blockmem[i]=values[i]+values[i+blockidm];
        if(threadIdx.x==0 && blockidm!=1 && blockidm*2!=len){
            blockmem[0]+=values[blockidm-1];
        }

        int stride=blockidm/2;
        __syncthreads();
        while(stride>=1){

            

            if(threadIdx.x<stride){

                blockmem[i]=blockmem[i]+blockmem[i+stride];
                                printf(" sorted %d and %d  at ith stridde %d  updated value %f \n",i,i+stride,stride,blockmem[i]);
            }
            if(threadIdx.x==0 && stride!=1 &&(stride)%2!=0){

                
                blockmem[0]=blockmem[0]+blockmem[stride-1];
                printf("falted index adding %d to 0  value at %f \n",stride-1,blockmem[0]);
            }
            __syncthreads();
            stride=stride/2;

        }

        if(threadIdx.x==0){
            *sum=blockmem[0];
        }
    }
}


int main(){
    int a;
    std::cin>>a;

    float* memory;

    memory=(float*)malloc(a*sizeof(float));

    for(int i=0;i<a;i++){
        memory[i]=6785;
    }

    // std::cout<<memory[4]<<std::endl;

    float* dev;
    cudaMalloc((void**)&dev,a*sizeof(float));
    cudaMemcpy(dev,memory,a*sizeof(float),cudaMemcpyHostToDevice);
    float* sum;

    cudaMalloc((void**)&sum,sizeof(float));


    // reduction_sum_normal<<<(1),(a/2)+1>>>(dev,sum,a);

    reduction_sum_shared<<<(1),(a/2)+1>>>(dev,sum,a);


    float* ans=(float*)malloc(sizeof(float));
    cudaMemcpy(ans,sum,sizeof(float),cudaMemcpyDeviceToHost);
    std::cout<<"answer is :"<<*ans;
    return 0;



}

