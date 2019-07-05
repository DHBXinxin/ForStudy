//
//  main.m
//  KindOfSort
//
//  Created by DHSD on 2019/6/28.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
//各种算法
//冒泡
void bubbleSort(int arr[], int len) {
    for (int i = 1; i < len; i++) {
        for (int j = 0; j < len - i; j++) {//len - i 最后的index已经排序好了
            if (arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
    for (int i = 0; i < len; i++) {
//        NSLog(@"%i",arr[i]);
        printf("%i",arr[i]);
    }
    printf("\n");
}//有可能到最后的几个数的时候已经不需要排序了、可以使用一个flag来看这个数组还用不用继续下去
void bubbleSort2(int arr[], int len) {

    BOOL flag = YES;
    int compareRange = len - 1;
    while (flag) {
        flag = NO;
        for (int j = 0; j < compareRange; j++) {
            if (arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
                flag = YES;
            }
        }

        compareRange--;
    }
    for (int i = 0; i < len; i++) {
        printf("%i",arr[i]);
    }
    printf("\n");
}
//插入排序
void insertSort(int arr[], int len) {
    int temp = 0;
    int j = 0;
    for (int i = 1; i < len; i++) {
        if (arr[i] < arr[i - 1]) {
            temp = arr[i];
            for (j = i -1; j >= 0 && temp < arr[j]; j--) {
                arr[j + 1] = arr[j];
            }
            arr[j + 1] = temp;
        }
    }
    for (int i = 0; i < len; i++) {
        printf("%i",arr[i]);
    }
    printf("\n");
}
void insertSort2(int arr[], int len) {
    int temp = -1;
    int sortedIndex = 0;
    for (int i = 1; i < len; i++) {
        temp = arr[i];
        sortedIndex = i - 1;
        while (sortedIndex >= 0 && arr[sortedIndex] > temp) {
            arr[sortedIndex + 1] = arr[sortedIndex];
            sortedIndex--;
        }
        arr[sortedIndex + 1] = temp;
    }
    for (int i = 0; i < len; i++) {
        printf("%i",arr[i]);
    }
    printf("\n");
}
//希尔排序-----感觉更麻烦了
void shellSort(int arr[], int len) {
    int step = len / 2;
    int temp = 0;
    int k = 0;
    while (step > 0) {
        for (int i = 0; i < step; i++) {
            for (int j = i + step; j < len; j += step) {
                if (arr[j] < arr[j - step]) {
                    temp = arr[j];
                    for (k = j - step; k >= 0 && temp < arr[k]; k -= step) {
                        arr[k + step] = arr[k];
                    }
                    arr[k + step] = temp;
                }
            }
        }
        step /= 2;
    }
    for (int i = 0; i < len; i++) {
        printf("%i",arr[i]);
    }
    printf("\n");
}
void shellSort2(int arr[], int len) {
    int temp = 0;
    int step = len / 2;
    int j = 0;
    while (step > 0) {
        for (int i = step; i < len; i++) {
            if (arr[i] < arr[i - step]) {
                temp = arr[i];
                j = i - step;
                while (j >= 0 && arr[j] > temp) {
                    arr[j + step] = arr[j];
                    j -= step;
                }
                arr[j + step] = temp;
            }
        }
        step /= 2;
    }
    for (int i = 0; i < len; i++) {
        printf("%i",arr[i]);
    }
    printf("\n");
}
void shellSort3(int arr[], int len) {
    int j = 0,temp = 0;
    for (int d = len / 2; d > 0; d /= 2) {
        for (int i = d; i < len; i++) {
            j = i - d;
            temp = arr[i];
            while (j >= 0 && arr[j] > temp) {
                arr[j + d] = arr[j];
                j -= d;
            }
            arr[j + d] = temp;
        }
    }
    for (int i = 0; i < len; i++) {
        printf("%i",arr[i]);
    }
    printf("\n");
}
//选择排序
void selectSort(int arr[], int len) {
    int temp = 0;
    int minIndex = -1;
    for (int i = 0; i < len; i++) {
        minIndex = i;
        for (int j = i; j < len - i; j++) {
            if (arr[minIndex] > arr[j + 1]) {
                minIndex = j + 1;
            }
        }
        temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
    }
    for (int i = 0; i < len; i++) {
        printf("%i",arr[i]);
    }
    printf("\n");
}
//堆排序
void adjust(int arr[], int k, int m) {
    int temp;
    int i = k;
    int j = 2 * k + 1;
    while (j <= m) {
        if (j < m && arr[j] < arr[j + 1]) {
            j++;
        }
        if (arr[i] > arr[j]) {
            break;
        } else {
            temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
            i = j;
            j = 2 * i + 1;
        }
    }
}
void heapSort(int arr[], int m) {
    int lastEleIndex = m - 1;
    int temp;
    for (int i = m/2 - 1; i >= 0; i--) {
        adjust(arr, i, lastEleIndex);
    }
    for (int i = 0; i < m; i++) {
        temp = arr[0];
        arr[0] = arr[lastEleIndex];
        arr[lastEleIndex] = temp;
        adjust(arr, 0, --lastEleIndex);
    }
    for (int i = 0; i < m; i++) {
        printf("%i",arr[i]);
    }
    printf("\n");
}
//归并排序
void Merge(int sourceArr[],int tempArr[], int startIndex, int midIndex, int endIndex)
{
    int i = startIndex, j=midIndex+1, k = startIndex;
    while(i!=midIndex+1 && j!=endIndex+1)
    {
        if(sourceArr[i] > sourceArr[j])
            tempArr[k++] = sourceArr[j++];
        else
            tempArr[k++] = sourceArr[i++];
    }
    while(i != midIndex+1)
        tempArr[k++] = sourceArr[i++];
    while(j != endIndex+1)
        tempArr[k++] = sourceArr[j++];
    for(i=startIndex; i<=endIndex; i++)
        sourceArr[i] = tempArr[i];
}

//内部使用递归
void MergeSort(int sourceArr[], int tempArr[], int startIndex, int endIndex)
{
    int midIndex;
    if(startIndex < endIndex)
    {
        midIndex = startIndex + (endIndex-startIndex) / 2;//避免溢出int
        MergeSort(sourceArr, tempArr, startIndex, midIndex);
        MergeSort(sourceArr, tempArr, midIndex+1, endIndex);
        Merge(sourceArr, tempArr, startIndex, midIndex, endIndex);
    }
}
int *getRandom() {
//    int r[10];
    static int r[10];
    int i;
    srand((unsigned)time(NULL));
    for (i = 0; i < 10; i++) {
        r[i] = rand();
        printf("r[%d]=%d\n",i, r[i]);
    }
    return r;//Address of stack memory associated with local variable 'r' returned需要为r添加一个static
}
//交换
void swap1(int a, int b) {
    a = a + b;
    b = a - b;
    a = a - b;
}
void swap2(int a, int b) {
    if (a != b) {
        a ^= b;
        b ^= a;
        a ^= b;
    }
}
//快速排序
void quickSort(int a[], int left, int right) {
    if (left >= right) {
        return;
    }
    int i = left;
    int j = right;
    int key = a[left];
    while (i < j) {
        while (i < j && key <= a[j]) {
            j--;
        }
        a[i] = a[j];
        while (i < j && key >= a[i]) {
            i++;
        }
        a[j] = a[i];
    }
    a[i] = key;
    quickSort(a, left, i - 1);
    quickSort(a, i + 1, right);
    
}

//常用的话、冒泡、选择、插入这三个就可以了、其他的看起来那么麻烦、能明白就可以了
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        int arr[] = {3, 1, 2, 5, 4, 8, 7, 9, 6};
//        bubbleSort(arr, 9);
//        bubbleSort2(arr, 9);
//        insertSort(arr, 9);
//        insertSort2(arr, 9);
//        shellSort(arr, 9);
//        shellSort2(arr, 9);
//        shellSort3(arr, 9);
//        selectSort(arr, 9);
//        heapSort(arr, 9);
//        int b[9] = {};
//        MergeSort(arr, b, 0, 8);
//        for (int i = 0; i < 9; i++) {
//            printf("%i",arr[i]);
//        }
//        printf("\n");
//        int *p;
//        int i;
//        p = getRandom();
//        for (i = 0; i < 10; i++) {
//            printf("------------%d",p[i]);
//            printf("\n");
//        }
//        int a[10] = {0,1};
//        printf("sizeof---%lu\n",sizeof(p) / sizeof(int));
//        printf("sizeof----%lu\n",sizeof(a) / sizeof(int));
//        quickSort(arr, 0, 8);
//        for (int i = 0; i < 9; i++) {
//            printf("%i",arr[i]);
//        }
//        printf("\n");
        
    }
    return 0;
}
