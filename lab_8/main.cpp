#include <stdio.h>

extern "C"
{
    void mystrcpy(char* dst, char* src, int size);
}

int mystrlen(char* mystr)
{
    int count = 0;

    __asm {
        mov ecx, -1;
        mov edi, mystr;
        xor al, al;        // код символа, с которым идёт сравнение, в al
        repne scasb;           // поиск по строке пока не найден символ из al и ecx не 0
        neg ecx;
        sub ecx, 2;      // получение реального размера
        mov count, ecx;         // перенос результата в count
    }

    return count;
}


int main() {
    // len = 0
    char s[10] = "\0";
    int l = mystrlen(s);
    printf("strlen(%s) = %d\n", s, l);
    // len = 5
    char s2[10] = "abcde";
    l = mystrlen(s2);
    printf("strlen(%s) = %d\n", s2, l);

    // dst > src и dst - src < len
    mystrcpy(s2 + 2, s2, l);
    printf("%s\n", s2);
    printf("%s\n", s2 + 2);
    // dst < src
    char s3[10] = "zxyrte";
    mystrcpy(s3, s3 + 3, 3);
    printf("%s\n", s3);
    printf("%s\n", s3 + 3);
    // dst - src > size
    char s4[10] = "zxyrte";
    mystrcpy(s4 + 3, s4, 2);
    printf("%s\n", s4);
    printf("%s\n", s4 + 3);

    return 0;
}