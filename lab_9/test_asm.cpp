#include <stdio.h>
#include <time.h>
#include "math.h"

#define COUNT 1e7
#define PI 3.14
#define PI2 3.141596

void float_asm(float a, float b)
{
    float res;

    clock_t start = clock();
    for (size_t i = 0; i < COUNT; ++i)                            
        __asm__("fld %1\n"    // a -> ST(0)
                "fld %2\n"    // b -> ST(0)  
                "faddp\n"     // ST(1) = ST(0) + ST(1), верхний элемент выталкивается из регистрового стека                                  
                "fstp %0\n"   // res ← ST(0), верхний элемент выталкивается из регистрового стека                 
                : "=m"(res)                                        
                : "m"(a), "m"(b)                                            
                );
    clock_t time_sum = clock() - start;

    start = clock();
    for (size_t i = 0; i < COUNT; ++i)
        __asm__("fld %1\n"                                          
                "fld %2\n"                                      
                "fmulp\n"                     
                "fstp %0\n"                                        
                : "=m"(res)                                        
                : "m"(a), "m"(b)                                            
                );
    clock_t time_mul = clock() - start;

    printf("Sum: %zu ms     Mul: %zu ms\n", time_sum, time_mul);
}

void double_asm(double a, double b)
{
    double res;

    clock_t start = clock();
    for (size_t i = 0; i < COUNT; ++i)                            
        __asm__("fld %1\n"   
                "fld %2\n"       
                "faddp\n"                                         
                "fstp %0\n"                      
                : "=m"(res)                                        
                : "m"(a), "m"(b)                                            
                );
    clock_t time_sum = clock() - start;

    start = clock();
    for (size_t i = 0; i < COUNT; ++i)
        __asm__("fld %1\n"                                          
                "fld %2\n"                                      
                "fmulp\n"                     
                "fstp %0\n"                                        
                : "=m"(res)                                        
                : "m"(a), "m"(b)                                            
                );
    clock_t time_mul = clock() - start;

    printf("Sum: %zu ms     Mul: %zu ms\n", time_sum, time_mul);
}

void ld_asm(long double a, long double b)
{
    long double res;

    clock_t start = clock();
    for (size_t i = 0; i < COUNT; ++i)                            
        __asm__("fld %1\n"   
                "fld %2\n"       
                "faddp\n"                                         
                "fstp %0\n"                      
                : "=m"(res)                                        
                : "m"(a), "m"(b)                                            
                );
    clock_t time_sum = clock() - start;

    start = clock();
    for (size_t i = 0; i < COUNT; ++i)
        __asm__("fld %1\n"                                          
                "fld %2\n"                                      
                "fmulp\n"                     
                "fstp %0\n"                                        
                : "=m"(res)                                        
                : "m"(a), "m"(b)                                            
                );
    clock_t time_mul = clock() - start;

    printf("Sum: %zu ms     Mul: %zu ms\n", time_sum, time_mul);
}

void float80_asm(__float80 a, __float80 b)
{
    __float80 res;

    clock_t start = clock();
    for (size_t i = 0; i < COUNT; ++i)                            
        __asm__("fld %1\n"   
                "fld %2\n"       
                "faddp\n"                                         
                "fstp %0\n"                      
                : "=m"(res)                                        
                : "m"(a), "m"(b)                                            
                );
    clock_t time_sum = clock() - start;

    start = clock();
    for (size_t i = 0; i < COUNT; ++i)
        __asm__("fld %1\n"                                          
                "fld %2\n"                                      
                "fmulp\n"                     
                "fstp %0\n"                                        
                : "=m"(res)                                        
                : "m"(a), "m"(b)                                            
                );
    clock_t time_mul = clock() - start;

    printf("Sum: %zu ms     Mul: %zu ms\n", time_sum, time_mul);
}

double get_pi(void)
{
    double fpu_pi;

    __asm__("fldpi\n"
            "fstp %0\n"
            : "=m"(fpu_pi) 
            );

    return fpu_pi;
}

double get_half_pi(void)
{
    double fpu_pi;
	int del = 2;

    __asm__("fldpi\n"
		    "fild %1\n"
            "fdivp\n"
            "fstp %0\n"
            : "=m"(fpu_pi) 
			: "m"(del)
            );

    return fpu_pi;
}


int main()
{
    float a, b;
    double ad, bd;
    long double ald, bld;
	__float80 a80, b80;
    ad = ald = a = a80 = -3.42;
    bd = bld = b = b80 = 1010.1;
	
	printf("ASM TESTS:\n");
	
    printf("Float:          ");
    float_asm(a, b);
    printf("Double:         ");
    double_asm(ad, bd);
	printf("Long double:    ");
	ld_asm(ald, bld);
	printf("FLOAT80:        ");
	float80_asm(a80, b80);
	
	printf("\n");
	
	printf("SIN(PI)\n");
    printf("PI = 3.14              : %g\n", sin(PI));
    printf("PI = 3.141596          : %g\n", sin(PI2));
    double fpu_pi = get_pi();
    printf("FPUPI = %.14g: %g\n\n", fpu_pi, sin(fpu_pi));

    printf("SIN(PI / 2)\n");
    printf("PI = 3.14              : %g\n", sin(PI / 2));
    printf("PI = 3.141596          : %g\n", sin(PI2 / 2));
    printf("FPUPI = %.14g: %g\n", fpu_pi, sin(get_half_pi()));

    return 0;
}