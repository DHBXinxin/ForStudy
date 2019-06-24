//
//  ChatCell.m
//  KnowAutolayout
//
//  Created by DHSD on 2019/6/24.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}
- (void)initCell {
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleLabel(>=30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    self.titleLabel.numberOfLines = 0;
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_contentLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentLabel(>=30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)]];
    
    self.imgView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imgView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imgView(>=30@300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgView)]];//最小30最大300、不要他太大
    
    self.userLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.userLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.userLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_userLabel(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_userLabel(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userLabel)]];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.userLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_timeLabel(80)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeLabel(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0]];//设置下边距、需要设置好内部控件与cell的下边界才能准确计算cell的大小
    //这一句很重要、一定要有、无论跟哪个控件设置边距、一定要有下边距
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.userLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.userLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
}
- (void)setModel:(ChatModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.imgView.image = model.imageName.length > 0 ? [UIImage imageNamed:model.imageName] : nil;
    self.userLabel.text = model.username;
    self.timeLabel.text = model.time;
}

@end
