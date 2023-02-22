#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define COUNT 1e7

float c_prod(float *a, float *b, size_t n)
{
    float res = 0;

    for (size_t i = 0; i < n; ++i)
        res += a[i] * b[i];

    return res;
}

// скалярное произведение считается по четвёркам
float asm_prod(float (*a)[4], float (*b)[4], size_t n)
{
    float tmp, res = 0;

    for (size_t i = 0; i < n / 4; i++)
    {
        __asm__(
            "movups xmm0, %1\n\t"     // a1, a2, a3, a4 -> xmm0
            "movups xmm1, %2\n\t"     // b1, b2, b3, b4 -> xmm1
            "mulps xmm0, xmm1\n\t"    // a1 * b1, a2 * b2, a3 * b3, a4 * b4 -> xmm0
            "haddps xmm0, xmm0\n\t"   // a1b1 + a2b2, a3b3 + a4b4, a1b1 + a2b2, a3b3 + a4b4 -> xmm0
            "haddps xmm0, xmm0\n\t"   // a1b1 + a2b2 + a3b3 + a4b4, a1b1 + a2b2 + a3b3 + a4b4, a1b1 + a2b2 + a3b3 + a4b4, a1b1 + a2b2 + a3b3 + a4b4
            "movss %0, xmm0\n\t"      // a1b1 + a2b2 + a3b3 + a4b4 (младшие 32 бита xmm0) -> tmp
            : "=m"(tmp)
            : "m"(a[i]), "m"(b[i])
            : "xmm0", "xmm1"
            );
        
        res += tmp;
    }

    return res;
}

void fill_array(float *arr, size_t n)
{
	for (size_t i = 0; i < n; i++)
		arr[i] = (float)rand() / 2;
}


int main(void)
{
    size_t n = 20;
    float a[20];
    float b[20];
	
	fill_array(a, n);
	fill_array(b, n);

    printf("SCALAR PROD OF VECTORS:\n");
	
	clock_t start = clock();
    for (size_t i = 0; i < COUNT; i++)
        c_prod(a, b, n);
    
    clock_t time_c = clock() - start;
    printf("C TIME:   %lu ms\n", time_c);
	
	
	float mas1[5][4];
	for (size_t i = 0; i < 5; i++)
		for (size_t j = 0; j < 4; j++)
			mas1[i][j] = a[i * 4 + j];
		
	float mas2[5][4];
	for (size_t i = 0; i < 5; i++)
		for (size_t j = 0; j < 4; j++)
			mas2[i][j] = b[i * 4 + j];

    start = clock();
    for (size_t i = 0; i < COUNT; i++)
        asm_prod(mas1, mas2, n);
    
    clock_t time_asm = clock() - start;
    printf("ASM TIME: %lu ms\n", time_asm);

    return 0;
}