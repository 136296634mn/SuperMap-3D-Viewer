//
//  AttributesViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/20.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "AttributesViewController.h"
#import "AttributeCell.h"
#import "UITableViewCell+RefreshData.h"
#import "AttributeModel.h"

@interface AttributesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *items;

@end

@implementation AttributesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 300, 200);
    
    [self initialize];
}

- (void)initialize {
    [self setupTableView];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    if ([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        [tableView setCellLayoutMarginsFollowReadableWidth:NO];
    }
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"AttributeCell" bundle:nil] forCellReuseIdentifier:@"AttributeCell"];
}

- (void)refreshData:(id)data {
    self.items = data;
    [self.tableView reloadData];
}

- (CGFloat)cellHeightWithIndexPath:(NSIndexPath *)indexPath {
    AttributeModel *model = self.items[indexPath.row];
    if (model) {
        NSString *key = [NSString stringWithFormat:@"%@", model.key];
        NSString *value = [NSString stringWithFormat:@"%@", model.value];
        NSString *standardString = @"A";//  用于获取一行的高度
        CGSize keySize = [key boundingRectWithSize:CGSizeMake(300 / 2, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}
                                           context:nil].size;
        CGSize valueSize = [value boundingRectWithSize:CGSizeMake(300 / 2, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}
                                               context:nil].size;
        CGSize standardSize = [standardString boundingRectWithSize:CGSizeMake(300 / 2, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}
                                                           context:nil].size;
        CGFloat blankHeight = 50 - standardSize.height;
        CGFloat maxHeight = keySize.height > valueSize.height ? keySize.height : valueSize.height;
        CGFloat totalHeight = maxHeight + blankHeight;
        if (totalHeight > 50) {
            return totalHeight;
        }
    }
    return 50;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttributeCell"];
    id data = self.items[indexPath.row];
    if (data) [cell refreshCell:data];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightWithIndexPath:indexPath];
}

@end
