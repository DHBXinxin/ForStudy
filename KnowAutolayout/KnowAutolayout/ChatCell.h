//
//  ChatCell.h
//  KnowAutolayout
//
//  Created by DHSD on 2019/6/24.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) UILabel *userLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) ChatModel *model;

@end

NS_ASSUME_NONNULL_END
