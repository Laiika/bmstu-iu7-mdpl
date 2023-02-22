#include <stdio.h>
#include <time.h>

#define COUNT 1e7

void float_cpp(float a, float b)
{
    float res;

    clock_t start = clock();
    for (size_t i = 0; i < COUNT; ++i)
        res = a + b;
    clock_t time_sum = clock() - start;

    start = clock();
    for (size_t i = 0; i < COUNT; ++i)
        res = a * b;
    clock_t time_mul = clock() - start;

    printf("Sum: %zu ms     Mul: %zu ms\n", time_sum, time_mul);
}

void double_cpp(double a, double b)
{
    double res;

    clock_t start = clock();
    for (size_t i = 0; i < COUNT; ++i)
        res = a + b;
    clock_t time_sum = clock() - start;

    start = clock();
    for (size_t i = 0; i < COUNT; ++i)
        res = a * b;
    clock_t time_mul = clock() - start;

    printf("Sum: %zu ms     Mul: %zu ms\n", time_sum, time_mul);
}

#ifdef M
	void ld_cpp(long double a, long double b)
	{
		long double res;

		clock_t start = clock();
		for (size_t i = 0; i < COUNT; ++i)
			res = a + b;
		clock_t time_sum = clock() - start;

		start = clock();
		for (size_t i = 0; i < COUNT; ++i)
			res = a * b;
		clock_t time_mul = clock() - start;

		printf("Sum: %zu ms     Mul: %zu ms\n", time_sum, time_mul);
	}

	void float80_cpp(__float80 a, __float80 b)
	{
		__float80 res;

		clock_t start = clock();
		for (size_t i = 0; i < COUNT; ++i)
			res = a + b;
		clock_t time_sum = clock() - start;

		start = clock();
		for (size_t i = 0; i < COUNT; ++i)
			res = a * b;
		clock_t time_mul = clock() - start;

		printf("Sum: %zu ms     Mul: %zu ms\n", time_sum, time_mul);
	}
#endif


int main()
{
    float a, b;
    double ad, bd;
    ad = a = -3.42;
    bd = b = 1010.1;
	
	printf("CPP TESTS:\n");
	
	printf("Float:          ");
    float_cpp(a, b);
    printf("Double:         ");
    double_cpp(ad, bd);

	#ifdef M
		long double ald = -3.42, bld = 1010.1;
		printf("Long double:    ");
		ld_cpp(ald, bld);

		__float80 a80 = -3.42, b80 = 1010.1;
		printf("FLOAT80:        ");
		float80_cpp(a80, b80);
	#endif
	
	printf("\n");

    return 0;
}