//
//  LayerViewController.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/4/12.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "LayerViewController.h"
#import "NavigationItem.h"
#import "Helper.h"
#import <SuperMap/SuperMap.h>
#import "LoaclDownloadQueue.h"
#import "UITableViewCell+RefreshData.h"
#import "Bridge.h"
#import "LayerSegmentedControl.h"
#import "LayerModel.h"
#import "TerrainLayerCell.h"

static NSString * const kLayer3DCell = @"Layer3DCell";
static NSString * const kTerrainLayerCell = @"TerrainLayerCell";

@interface LayerViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *layer3Ds;
@property (copy, nonatomic) NSArray *terrainLayers;
@property (copy, nonatomic) NSArray *items;
@property (copy, nonnull) NSString *identifier;

@end

@implementation LayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GetColor(241, 241, 241, 1.0);
    
    //  设置导航条属性
    [self.navigationItem setTitle:_currentTitle];
    [self.navigationItem setPopToPreviousViewController:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //  设置tableView数据源和代理
    [self setupTableView];
    
    //  Bridge事件
    [self bridgeEvent];
    
    //  获取本地或网络数据
    [self fetchData];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"Layer3DCell" bundle:nil] forCellReuseIdentifier:kLayer3DCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"TerrainLayerCell" bundle:nil] forCellReuseIdentifier:kTerrainLayerCell];
    self.identifier = kLayer3DCell;
}

- (void)fetchData {
    [LoaclDownloadQueue downloadLayer3DData:^(NSArray *items) {
        self.layer3Ds = items;
        self.items = self.layer3Ds;
        [self.tableView reloadData];
    } scene:_currentScene];
    [LoaclDownloadQueue downloadTerrainLayerData:^(NSArray *items) {
        self.terrainLayers = items;
    } scene:_currentScene];
}

- (void)bridgeEvent {
    [[Bridge sharedInstance] setLayerVisible:^(NSString *name, BOOL isOn) {
        Layer3D *layer = [_currentScene.layers getLayerWithName:name];
        if (layer) layer.visible = isOn;
        TerrainLayer *terrainLayer = [_currentScene.terrainLayers getLayerWithName:name];
        if (terrainLayer) terrainLayer.visible = isOn;
    }];//   <--设置图层可见或不可见
    [[Bridge sharedInstance] setLayerSelectable:^(NSString *name, BOOL selectable) {
        Layer3D *layer = [_currentScene.layers getLayerWithName:name];
        if (layer) {
            layer.selectable = selectable;
            if (!selectable) [layer.selection3D clear];//  设置图层不可选时把选择集清空
        }
    }];//   <--图层可选与否
}

- (IBAction)handleLayerSegmentedControlEvent:(LayerSegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.items = self.layer3Ds;
        self.identifier = kLayer3DCell;
    } else if (sender.selectedSegmentIndex == 1) {
        self.items = self.terrainLayers;
        self.identifier = kTerrainLayerCell;
    }
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    id data = self.items[indexPath.row];
    if (data) [cell refreshCell:data];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(30, 30, 30, 1.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LayerModel *model = (LayerModel *)self.items[indexPath.row];
    if (model.type == LayerModelTypeLayer3D) {
        Layer3D *layer3D = [self.currentScene.layers getLayerWithName:model.layerName];
        [self.currentScene ensureVisible:layer3D];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
