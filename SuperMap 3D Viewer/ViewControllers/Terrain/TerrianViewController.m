//
//  TerrianViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/17.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "TerrianViewController.h"
#import "TerrainCell.h"

static NSString * const kTerrainCell       = @"kTerrainCell";

@interface TerrianViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy, nonatomic) NSArray *items;

@end

@implementation TerrianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor darkGrayColor];
    self.view.frame = CGRectMake(0, 0, 300, 200);
    self.items = @[@"google.png"];
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self registerCell];
}

- (void)registerCell {
    [self.collectionView registerNib:[UINib nibWithNibName:@"TerrainCell" bundle:nil] forCellWithReuseIdentifier:kTerrainCell];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TerrainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTerrainCell forIndexPath:indexPath];
    id data = self.items[indexPath.item];
    if (data) [cell refreshCell:data];
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

@end
