//
//  C++Main.cpp
//  ForRuntime
//
//  Created by DHSD on 2018/6/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#include <stdio.h>
#include <iostream>
using namespace std;
class Base
{
public:
    virtual void f(float x)
    {
        cout<<"Base::f(float)"<< x <<endl;
    }
    void g(float x)
    {
        cout<<"Base::g(float)"<< x <<endl;
    }
};
class Derived : public Base
{
public:
    virtual void f(float x)
    {
        cout<<"Derived::f(float)"<< x <<endl;
    }
    void g(int x)
    {
        cout<<"Derived::g(int)"<< x <<endl;
    }
};
int main(void)
{
    Derived d;
    Base *pb = &d;
    Derived *pd = &d;
    pb->f(3.14);
    pd->f(3.14);
    pb->g(3.14);
    pd->g(3.14);
    return 0;
}
//从输出可以看出f为其运行时刻类型的输出结果，g为编译时刻的输出结果、而区别只是f为虚函数、对于C++来说，虚函数完成了其动态多态的实现。
