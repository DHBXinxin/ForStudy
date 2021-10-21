//
//  main.m
//  ArchiverDemo
//
//  Created by 李欣欣 on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import "People.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        //13之后新的归档解档方法
        People *peo = [[People alloc]init];
        peo.name = @"li";
        peo.age = 11;
        NSString *path = NSHomeDirectory();
        path = [NSString stringWithFormat:@"%@/people",path];
        NSError *error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:peo requiringSecureCoding:YES error:&error];
        [data writeToFile:path atomically:YES];
        NSData *undata = [NSData dataWithContentsOfFile:path];
        People *unpeo = [NSKeyedUnarchiver unarchivedObjectOfClass:[People class] fromData:undata error:&error];
        NSLog(@"%@",unpeo.name);
    }
    return 0;
}
