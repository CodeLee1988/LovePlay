//
//  NewsDetailSectionCommentFooterView.m
//  LovePlay
//
//  Created by weiying on 2017/2/7.
//  Copyright © 2017年 Yuns. All rights reserved.
//

#import "NewsDetailSectionCommentFooterView.h"

@interface NewsDetailSectionCommentFooterView ()
//UI
@property (nonatomic, strong) UILabel *titleTextLabel;
//Data
@property (nonatomic, copy) commentFooterTouchBlock touchBlock;
@end

@implementation NewsDetailSectionCommentFooterView

+ (instancetype)sectionFooterWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"sectionFooter";
    NewsDetailSectionCommentFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (footer == nil) {
        footer = [[NewsDetailSectionCommentFooterView alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubnodes];
    }
    return self;
}

- (void)addSubnodes
{
    UILabel *titleTextlabel = [[UILabel alloc] init];
    titleTextlabel.textColor = RGB(218, 85, 107);
    titleTextlabel.font = [UIFont systemFontOfSize:14];
    titleTextlabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleTextlabel];
    _titleTextLabel = titleTextlabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;

    _titleTextLabel.text = title;
}

- (void)commentFooterViewTouchBlock:(commentFooterTouchBlock)touchBlock
{
    _touchBlock = touchBlock;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchBlock) {
        _touchBlock();
    }
}

#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleTextLabel.frame = self.bounds;
}

@end
