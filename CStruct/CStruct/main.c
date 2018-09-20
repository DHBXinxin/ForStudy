//
//  main.c
//  CStruct
//
//  Created by DHSD on 2018/9/20.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#include <stdio.h>
#include <string.h>

//结构体了解一下

struct Books {
    char title[50];
    char author[50];
    char *subject;
    int book_id;
} book;

struct {
    int a;
    char b;
    double c;
} s1;
struct Simple {
    int a;
    char b;
    double c;
};
struct Simple t1, t2[20], *t3;

typedef struct {
    int a;
    char b;
    double c;
} Simple2;
Simple2 u1, u2[20], *u3;//u2是结构体数组、表示有20个结构体
//此结构体的声明包含了其他的结构体
struct COMPLEX
{
    char string[100];
    struct Simple a;
};
//此结构体的声明包含了指向自己类型的指针
struct NODE
{
    char string[100];
    struct NODE *next_node;
};
struct B;    //对结构体B进行不完整声明

//结构体A中包含指向结构体B的指针
struct A
{
    struct B *partner;
    //other members;
};
/* 函数声明 */
void printBook( struct Books book );
/* 函数声明 */
void printBook2( struct Books *book );

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    
//    struct Books b1;
//    struct Books b2;
//    b1.author = "author";
    struct Books Book1;        /* 声明 Book1，类型为 Books */
    struct Books Book2;        /* 声明 Book2，类型为 Books */
    
    /* Book1 详述 */
    strcpy( Book1.title, "C Programming");
    strcpy( Book1.author, "Nuha Ali");
    //strcpy( Book1.subject, "C Programming Tutorial");//运行到这儿会崩溃
    Book1.subject = "C Programming Tutorial";
    Book1.book_id = 6495407;
    
    /* Book2 详述 */
    strcpy( Book2.title, "Telecom Billing");
    strcpy( Book2.author, "Zara Ali");
//    strcpy( Book2.subject, "Telecom Billing Tutorial");//运行到这儿会崩溃
    Book2.subject = "Telecom Billing Tutorial";
    Book2.book_id = 6495700;
    
    /* 输出 Book1 信息 */
    printf( "Book 1 title : %s\n", Book1.title);
    printf( "Book 1 author : %s\n", Book1.author);
    printf( "Book 1 subject : %s\n", Book1.subject);
    printf( "Book 1 book_id : %d\n", Book1.book_id);
    
    /* 输出 Book2 信息 */
    printf( "Book 2 title : %s\n", Book2.title);
    printf( "Book 2 author : %s\n", Book2.author);
    printf( "Book 2 subject : %s\n", Book2.subject);
    printf( "Book 2 book_id : %d\n", Book2.book_id);
    printBook(Book1);
    printBook2(&Book2);
    
    struct Books *b1 = &Book1;
    //= {"title", "author", "subject", 22222};
    b1->book_id = 111;
//    b1->title = "";//报错 Array type 'char [50]' is not assignable
    b1->subject = "subjectb1";
    printBook(*b1);
    Book1.subject = "subject";
    printBook(Book1);
    printf("%p",b1[0]);
    char a1[4] = "abc";//分配一个char的数组（有四个元素），'a'放进str[0]，'b'放进str[1]，'c'放进str[2]，'\0'放进str[3]
//    a1 = "cdf";//报错 Array type 'char [4]' is not assignable
    //报错原因是给一个数组类型名赋值一个char*
    
    char *a2;//声明一个char型指针变量、可以随意改变指针指向的值
    a2 = "abc";
    a2 = "cdf";
    
    
    //结构体初始化
    struct Books i = {"", "", "", 3};//顺序赋值
    struct Books ii;
    ii.subject = "";
    ii.book_id = 3;//..
    
    struct Books iii = {//乱序赋值
        .title = "",
        .subject = "",
        .author = "",
        .book_id = 3333
    };
    
    return 0;
}
void printBook( struct Books book )
{
    printf( "Book title : %s\n", book.title);
    printf( "Book author : %s\n", book.author);
    printf( "Book subject : %s\n", book.subject);
    printf( "Book book_id : %d\n", book.book_id);
}
void printBook2( struct Books *book )
{
    printf( "Book title : %s\n", book->title);
    printf( "Book author : %s\n", book->author);
    printf( "Book subject : %s\n", book->subject);
    printf( "Book book_id : %d\n", book->book_id);
}
