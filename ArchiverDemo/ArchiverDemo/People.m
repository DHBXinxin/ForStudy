//
//  People.m
//  ArchiverDemo
//
//  Created by 李欣欣 on 2021/4/28.
//

#import "People.h"

@interface People ()<NSSecureCoding>

@end
@implementation People

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.age forKey:@"age"];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.age = [coder decodeIntegerForKey:@"age"];
    }
    return self;
}
+ (BOOL)supportsSecureCoding {
    return YES;
}
@end
