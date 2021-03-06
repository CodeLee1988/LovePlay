//
//  DiscussListHeaderView.m
//  LovePlay
//
//  Created by Yuns on 2017/2/3.
//  Copyright © 2017年 Yuns. All rights reserved.
//

#import "DiscussListHeaderView.h"
#import "DiscussImageModel.h"

@interface DiscussListHeaderView ()

@property (nonatomic, strong) UIImageView *imageNode;
@property (nonatomic, strong) UILabel *titleTextLabel;
@property (nonatomic, strong) UILabel *descriptionTextLabel;

@end

@implementation DiscussListHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubnodes];
        [self sd_autoLayoutSubViews];
    }
    return self;
}

- (void)addSubnodes
{
    UIImageView *imageNode = [[UIImageView alloc] init];
    imageNode.contentMode = UIViewContentModeScaleAspectFill;
    imageNode.clipsToBounds = YES;
    [self addSubview:imageNode];
    _imageNode = imageNode;
    
    UILabel *titleTextLabel = [[UILabel alloc] init];
    titleTextLabel.font = [UIFont systemFontOfSize:18];
    titleTextLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleTextLabel];
    _titleTextLabel = titleTextLabel;
    
    UILabel *descriptionTextLabel = [[UILabel alloc] init];
    descriptionTextLabel.font = [UIFont systemFontOfSize:12];
    descriptionTextLabel.textColor = [UIColor whiteColor];
    [self addSubview:descriptionTextLabel];
    _descriptionTextLabel = descriptionTextLabel;
}

- (void)setImageModel:(DiscussImageModel *)imageModel
{
    _imageModel = imageModel;
    _imageNode.imageURL = [NSURL URLWithString:imageModel.bannerUrl];
    _titleTextLabel.text = imageModel.modelName;
    _descriptionTextLabel.text = [NSString stringWithFormat:@"今日：%@",imageModel.todayPosts];
}

#pragma mark - layout
- (void)sd_autoLayoutSubViews
{
    _imageNode.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _descriptionTextLabel.sd_layout
    .leftSpaceToView(self, 10)
    .bottomSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .autoHeightRatio(0);
    [_descriptionTextLabel setMaxNumberOfLinesToShow:1];
    
    _titleTextLabel.sd_layout
    .leftEqualToView(_descriptionTextLabel)
    .bottomSpaceToView(_descriptionTextLabel, 5)
    .rightEqualToView(_descriptionTextLabel)
    .autoHeightRatio(0);
    [_titleTextLabel setMaxNumberOfLinesToShow:1];
}

@end
