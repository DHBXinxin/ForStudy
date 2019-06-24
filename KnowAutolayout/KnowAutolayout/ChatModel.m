//
//  ChatModel.m
//  KnowAutolayout
//
//  Created by DHSD on 2019/6/24.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[@"title"];
        _content = dictionary[@"content"];
        _username = dictionary[@"username"];
        _time = dictionary[@"time"];
        _imageName = dictionary[@"imageName"];
    }
    return self;
}

@end
