//
//  DiscussDetailPostCell.h
//  LovePlay
//
//  Created by weiying on 2017/2/7.
//  Copyright © 2017年 Yuns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscuzPost;
@interface DiscussDetailPostCell : ASCellNode

#pragma mark - interface
- (instancetype)initWithPost:(DiscuzPost *)post floor:(NSInteger)floor;

@end
