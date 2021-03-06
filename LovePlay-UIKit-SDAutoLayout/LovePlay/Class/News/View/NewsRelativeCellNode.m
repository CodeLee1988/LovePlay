//
//  NewsRelativeCellNode.m
//  LovePlay
//
//  Created by Yuns on 2017/2/4.
//  Copyright © 2017年 Yuns. All rights reserved.
//

#import "NewsRelativeCellNode.h"
#import "NewsDetailModel.h"

@interface NewsRelativeCellNode ()
//UI
@property (nonatomic, strong) UIImageView *imageNode;
@property (nonatomic, strong) UILabel *titleTextNode;
@property (nonatomic, strong) UILabel *timeInfoTextNode;
@property (nonatomic, strong) UIView *underLineNode;
//Data
@property (nonatomic, strong) NewsRelativeInfo *relativeInfo;
@end

@implementation NewsRelativeCellNode

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"NewsRelativeCellNode";
    NewsRelativeCellNode *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NewsRelativeCellNode alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubnodes];
        [self sd_autoLayoutSubViews];
    }
    return self;
}

- (void)addSubnodes
{
    UIImageView *imageNode = [[UIImageView alloc] init];
    [self.contentView addSubview:imageNode];
    _imageNode = imageNode;
    
    UILabel *titleTextNode = [[UILabel alloc] init];
    titleTextNode.font = [UIFont systemFontOfSize:16];
    titleTextNode.textColor = RGB(36, 36, 36);
    [self.contentView addSubview:titleTextNode];
    _titleTextNode = titleTextNode;
    
    UILabel *timeInfoTextNode = [[UILabel alloc] init];
    timeInfoTextNode.font = [UIFont systemFontOfSize:10];
    timeInfoTextNode.textColor = RGB(150, 150, 150);
    [self.contentView addSubview:timeInfoTextNode];
    _timeInfoTextNode = timeInfoTextNode;
    
    UIView *underLineNode = [[UIView alloc] init];
    underLineNode.backgroundColor = RGB(222, 222, 222);
    [self.contentView addSubview:underLineNode];
    _underLineNode = underLineNode;
    
}

- (void)setupRelativeInfo:(NewsRelativeInfo *)relativeInfo
{
    _relativeInfo = relativeInfo;
    _imageNode.imageURL = [NSURL URLWithString:_relativeInfo.imgsrc];
    _titleTextNode.text = _relativeInfo.title;
    _timeInfoTextNode.text = [NSString stringWithFormat:@"%@ %@",_relativeInfo.source, _relativeInfo.ptime];
}

#pragma mark - layout
- (void)sd_autoLayoutSubViews
{
    _imageNode.sd_layout
    .widthIs(80)
    .heightIs(80)
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10);
    
    _titleTextNode.sd_layout
    .topEqualToView(_imageNode)
    .leftSpaceToView(_imageNode, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    [_titleTextNode setMaxNumberOfLinesToShow:2];
    
    _timeInfoTextNode.sd_layout
    .leftSpaceToView(_imageNode, 10)
    .bottomEqualToView(_imageNode)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    [_timeInfoTextNode setMaxNumberOfLinesToShow:1];
    
    _underLineNode.sd_layout
    .heightIs(0.5)
    .topSpaceToView(_imageNode, 10)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    [self setupAutoHeightWithBottomView:_underLineNode bottomMargin:0];
}


@end
