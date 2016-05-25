//
//  FavoritesCell.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/18.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "FavoritesCell.h"
#import "FavoritesSettingViewController.h"
#import "Bridge.h"
#import "Supermap.h"
#import <SuperMap/SuperMap.h>
#import "FavoritesSettingModel.h"
#import "SMFeature3D.h"

@interface FavoritesCell ()

@property (weak, nonatomic) IBOutlet UIButton *home;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *flyAroundButton;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *checkImage;

@end

@implementation FavoritesCell

- (void)awakeFromNib {
    // Initialization code
    self.image = [UIImage imageNamed:@"favorits@2x.png"];
    self.checkImage = [UIImage imageNamed:@"favorits_checkbox@2x.png"];
    self.backgroundColor = [UIColor clearColor];
    [self.home setImage:[UIImage imageNamed:@"icon_主菜单.png"] forState:UIControlStateNormal];
    [self.home setImage:[UIImage imageNamed:@"icon_主菜单－按下.png"] forState:UIControlStateHighlighted];
    [self.favoriteButton setImage:self.checkImage forState:UIControlStateNormal];
    [self.flyAroundButton setImage:[UIImage imageNamed:@"icon_绕点飞行.png"] forState:UIControlStateNormal];
    [self.flyAroundButton setImage:[UIImage imageNamed:@"icon_绕点飞行－按下.png"] forState:UIControlStateHighlighted];
}

- (IBAction)handleHomeButtonEvent:(id)sender {
    [Bridge sharedInstance].handleHomeButtonEvent();
}

- (IBAction)handleFavoriteButtonEvent:(id)sender {
    UIImage *currentImage = [self.favoriteButton imageForState:UIControlStateNormal];
    if ([currentImage isEqual:self.checkImage]) {
        //  跳转到收藏设置页面
        [self pushToFavoritesSettingViewController];
    } else if ([currentImage isEqual:self.image]) {
        //  取消收藏
        [self cancelFavor];
    }
}

- (IBAction)handleFlyAroundButtonEvent:(id)sender {
    GeoPlacemark *placeMark = (GeoPlacemark *)[Supermap sharedInstance].smFeature3D.feature3D.geometry3D;
    GeoPoint3D *geoPoint3D = (GeoPoint3D *)placeMark.geometry;
    [Bridge sharedInstance].flyAroundPoint(geoPoint3D, 2);
}

//  跳转到收藏设置页面
- (void)pushToFavoritesSettingViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FavoritesSettingViewController *favoritesSettingVC = (FavoritesSettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FavoritesSettingViewController"];
    favoritesSettingVC.currentTitle = @"属性设置";
    favoritesSettingVC.model = [self model];
    favoritesSettingVC.deliverModel = ^(FavoritesSettingModel *model, NSIndexPath *indexPath){
        [self.favoriteButton setImage:self.image forState:UIControlStateNormal];
        [Supermap sharedInstance].smFeature3D.favorable = YES;
        [self resetFeature3DWithModel:model];
    };
    [Bridge sharedInstance].pushToNewViewController(favoritesSettingVC);
}

//  取消收藏
- (void)cancelFavor {
    [Supermap sharedInstance].smFeature3D.favorable = NO;
    [self.favoriteButton setImage:self.checkImage forState:UIControlStateNormal];
}

- (FavoritesSettingModel *)model {
    Feature3D *feature3D = [Supermap sharedInstance].smFeature3D.feature3D;
    GeoPlacemark *placemark = (GeoPlacemark *)feature3D.geometry3D;
    GeoPoint3D *geoPoint3D = (GeoPoint3D *)placemark.geometry;
    GeoStyle3D *style3D = placemark.style3D;
    NSString *name = feature3D.name;
    NSString *message = feature3D.description;
    NSString *iconName = [style3D.markerFile lastPathComponent];
    BOOL visible = feature3D.visible;
    
    if (message == nil || [message isEqualToString:@""]) {
        message = [NSString stringWithFormat:@"(%lf, %lf)", geoPoint3D.x, geoPoint3D.y];
    }
    NSDictionary *dic = @{@"name" : name,
                          @"iconName" : iconName,
                          @"message" : message,
                          @"visible" : [NSNumber numberWithBool:visible]};
    FavoritesSettingModel *model = [FavoritesSettingModel modelWithDic:dic];
    return model;
}

- (void)resetFeature3DWithModel:(FavoritesSettingModel *)model {
    Feature3D *feature3D = [Supermap sharedInstance].smFeature3D.feature3D;
    feature3D.name = model.name;
    feature3D.description = model.message;
    feature3D.visible = model.visible;
    GeoPlacemark *placemark = (GeoPlacemark *)feature3D.geometry3D;
    GeoStyle3D *style3D = placemark.style3D;
    NSString *supermapBundle = [[NSBundle mainBundle] pathForResource:@"SuperMap" ofType:@"bundle"];
    NSString *commonPath = [supermapBundle stringByAppendingPathComponent:@"Contents/Resources/Resource"];
    style3D.markerFile = [commonPath stringByAppendingPathComponent:model.iconName];
    [feature3D updateData];
//    [Bridge sharedInstance].updateKMLLayer();
}

- (void)refreshCell {
    [self.favoriteButton setImage:self.checkImage forState:UIControlStateNormal];
}

@end
