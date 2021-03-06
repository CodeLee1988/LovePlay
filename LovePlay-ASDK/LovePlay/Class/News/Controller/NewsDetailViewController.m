//
//  NewsDetailViewController.m
//  LovePlay
//
//  Created by Yuns on 2017/1/29.
//  Copyright © 2017年 Yuns. All rights reserved.
//

#import "NewsDetailViewController.h"
//M
#import "NewsDetailModel.h"
//V
#import "NewsDetailWebCellNode.h"
#import "NewsRelativeCellNode.h"
#import "NewsCommentCellNode.h"
#import "NewsDetailSectionTitleHeaderView.h"
#import "NewsDetailSectionCommentFooterView.h"
//C
#import "NewsCommentViewController.h"
#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()<ASTableDelegate, ASTableDataSource>
//UI
@property (nonatomic, strong) ASTableNode *tableNode;
//Data
@property (nonatomic, strong) NewsDetailModel *detailModel;
@end

@implementation NewsDetailViewController

#pragma mark - life cycle
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.node.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(245, 245, 245);
    [self loadData];
}

#pragma mark - init
- (instancetype)init
{
    self = [super initWithNode:[ASDisplayNode new]];
    if (self) {
        [self addTableNode];
    }
    return self;
}

- (void)addTableNode
{
    [self.node addSubnode:self.tableNode];
}

- (void)loadData
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",  NewsDetailURL, _newsID];
    NSDictionary *params = @{@"tieVersion":@"v2",@"platform":@"ios",@"width":@(kScreenWidth*2),@"height":@(kScreenHeight*2),@"decimal":@"75"};
    [[HttpRequest sharedInstance] GET:urlString parameters:params success:^(id response) {
        NSLog(@"list-succ : %@", response);
        NewsDetailModel *detailModel = [NewsDetailModel modelWithJSON:response[@"info"]];
        _detailModel = detailModel;
        [_tableNode reloadData];
    } failure:^(NSError *error) {
        NSLog(@"list-fail : %@", error);
    }];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 3;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return _detailModel.tie.commentIds.count;
            break;
        case 2:
            return _detailModel.article.relative_sys.count;
            break;
        default:
            return 0;
            break;
    }
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASCellNode * (^cellNodeBlock)() = ^ASCellNode * (){
        switch (indexPath.section) {
            case 0:
            {
                NewsDetailWebCellNode *cellNode = [[NewsDetailWebCellNode alloc] initWithHtmlBoby:_detailModel.article.body];
                return cellNode;
            }
                break;
            case 1:
            {
                NSArray *floors = _detailModel.tie.commentIds[indexPath.row];
                NewsCommentCellNode *cellNode = [[NewsCommentCellNode alloc] initWithcommentItems:_detailModel.tie.comments commmentIds:floors];
                return cellNode;
            }
                break;
            case 2:
            {
                NewsRelativeInfo *relativeInfo = _detailModel.article.relative_sys[indexPath.row];
                NewsRelativeCellNode *cellNode = [[NewsRelativeCellNode alloc] initWithRelativeInfo:relativeInfo];
                return cellNode;
            }
                break;
            default:
                return nil;
                break;
        }
    };
    return cellNodeBlock;
}

#pragma mark - tableView delegate
- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        NewsRelativeInfo *relativeInfo = _detailModel.article.relative_sys[indexPath.row];
        NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc] init];
        detailViewController.newsID = relativeInfo.docID;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark + header and footer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NewsDetailSectionTitleHeaderView *headerView = [NewsDetailSectionTitleHeaderView sectionHeaderWithTableView:tableView];
    switch (section) {
        case 1:
        {
            if (_detailModel.tie.comments.count > 0) {
                headerView.title = @"热门跟帖";
            }else{
                return nil;
            }
        }
            break;
        case 2:
        {
            if (_detailModel.article.relative_sys.count > 0) {
                headerView.title = @"猜你喜欢";
            }else{
                return nil;
            }
        }
            break;
        default:
            return nil;
            break;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NewsDetailSectionCommentFooterView *footerView = [NewsDetailSectionCommentFooterView sectionFooterWithTableView:tableView];
    if (1 == section) {
        if (_detailModel.tie.comments.count > 0) {
            footerView.title = @"查看更多跟帖";
            [footerView commentFooterViewTouchBlock:^{
                NewsCommentViewController *commentViewController = [[NewsCommentViewController alloc] init];
                commentViewController.newsID = _newsID;
                [self.navigationController pushViewController:commentViewController animated:YES];
            }];
            return footerView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
        {
            if (_detailModel.tie.comments.count > 0) {
               return 30;
            }
        }
            break;
        case 2:
        {
            if (_detailModel.article.relative_sys.count > 0) {
                return 30;
            }
        }
            break;
        default:
            return CGFLOAT_MIN;
            break;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (1 == section) {
        if (_detailModel.tie.comments.count > 0) {
            return 40;
        }
    }
    return CGFLOAT_MIN;
}

#pragma mark - setter / getter
- (ASTableNode *)tableNode
{
    if (!_tableNode) {
        ASTableNode *tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
        tableNode.backgroundColor = [UIColor whiteColor];
        tableNode.delegate = self;
        tableNode.dataSource = self;
        tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableNode = tableNode;
    }
    return _tableNode;
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
