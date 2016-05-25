//
//  Animation.m
//  SuperMap 3D Viewer
//
//  Created by zyd on 16/3/11.
//  Copyright © 2016年 zyd. All rights reserved.
//

#import "Animation.h"
#import "AdaptiveFit.h"

@implementation Animation

+ (void)displayHomeMenu:(UIView *)view animated:(BOOL)animated{
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                constraint.constant = [AdaptiveFit sizeFromIPone6P:440];
            } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                constraint.constant = 440;
            }
        }
    }
    if (!animated) {
        view.hidden = NO;
        return;
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         view.hidden = NO;
                         [view layoutIfNeeded];
                     }
                     completion:nil];
}

+ (void)applyHideAnimationToHomeMenu:(UIView *)view {
    view.hidden = YES;
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 85;
        }
    }
}

+ (void)applyCancelAnimationToToolMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = 70;
        } else if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 70;
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                         view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         view.hidden = YES;
                         view.alpha = 1.0;
                     }];
}

+ (void)applyShowAnimationToToolMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeWidth) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                constraint.constant = [AdaptiveFit sizeFromIPone6P:370];
            } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                constraint.constant = 390;
            }
        } else if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 120;
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         view.hidden = NO;
                         [view layoutIfNeeded];
                     }
                     completion:nil];
}

+ (void)applyAnimationToFavorites:(UIView *)favorites completion:(void(^)())completion {
    CGRect frame = favorites.frame;
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         favorites.frame = CGRectMake(CGRectGetMinX(frame) - CGRectGetWidth(frame) / 2, CGRectGetMinY(frame) - CGRectGetHeight(frame), 2*CGRectGetWidth(frame), 2*CGRectGetHeight(frame));
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0
                              usingSpringWithDamping:0.8
                               initialSpringVelocity:0.5
                                             options:UIViewAnimationOptionLayoutSubviews
                                          animations:^{
                                              favorites.frame = frame;
                                              if (completion) completion();
                                              favorites.hidden = YES;
                                          }
                                          completion:^(BOOL finished) {
                                              [favorites removeFromSuperview];
                                          }];
                     }];
}

+ (void)applyDisplayAnimationToSearchMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            [view removeConstraint:constraint];
            [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view.superview
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:100]];
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         view.hidden = NO;
                         [view layoutIfNeeded];
                     }
                     completion:nil];
}

+ (void)applyDismissAnimationToSearchMenu:(UIView *)view completion:(void(^)())completion {
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if (constraint.secondItem == view && constraint.secondAttribute == NSLayoutAttributeBottom) {
            [view.superview removeConstraint:constraint];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:60 + 40 + 10 + 50]];//   cell高度 + 底部button高度 + 搜索条和搜索结果菜单间距 + 搜索条高度
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                         view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         view.hidden = YES;
                         view.alpha = 1.0;
                         if (completion) completion();
                     }];
}

+ (void)applyShrinkAnimationToSearchMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if (constraint.secondItem == view && constraint.secondAttribute == NSLayoutAttributeBottom) {
            [view.superview removeConstraint:constraint];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:60 + 40 + 10 + 50]];//   cell高度 + 底部button高度 + 搜索条和搜索结果菜单间距 + 搜索条高度
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                     }
                     completion:nil];
}

+ (void)applyExtendAnimationToSearchMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            [view removeConstraint:constraint];
            [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view.superview
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:100]];
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                     }
                     completion:nil];
}

+ (void)applyDisplayAnimationToSearchHistoryMenu:(UIView *)view height:(CGFloat)height {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
        }
    }
}

+ (void)applyDisplayAnimationToRouteMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            [view removeConstraint:constraint];
            [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view.superview
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:100]];
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         view.hidden = NO;
                         [view layoutIfNeeded];
                     }
                     completion:nil];
}

+ (void)applyDismissAnimationToRouteMenu:(UIView *)view completion:(void (^)())completion{
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if (constraint.secondItem == view && constraint.secondAttribute == NSLayoutAttributeBottom) {
            [view.superview removeConstraint:constraint];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:60 + 40 + 10 + 100]];//   cell高度 + 底部button高度 + 路线条和历史路线菜单间距 + 路线条高度
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                         view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         view.hidden = YES;
                         view.alpha = 1.0;
                         if (completion) completion();
                     }];
}

+ (void)applyExtendAnimationToRouteMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            [view removeConstraint:constraint];
            [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view.superview
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:100]];
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                     }
                     completion:nil];
}

+ (void)applyShrinkAnimationToRouteMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if (constraint.secondItem == view && constraint.secondAttribute == NSLayoutAttributeBottom) {
            [view.superview removeConstraint:constraint];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:60 + 40 + 10 + 100]];//   cell高度 + 底部button高度 + 路线条和历史路线菜单间距 + 路线条高度
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                     }
                     completion:nil];
}

+ (void)applyFullScreenAnimationToView:(UIView *)view {
    [UIView animateWithDuration:0.3
                     animations:^{
                         view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         view.hidden = YES;
                     }];
}

+ (void)applyExitFullScreenAnimationToView:(UIView *)view {
    view.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

+ (void)applyExtendAnimationToAttributeMenu:(UIView *)view {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 200;
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                     }];
}

+ (void)applyShrinkAnimationToAttributeMenu:(UIView *)view
                            expendAnimation:(void(^)())animation
                                 completion:(void(^)())completion {
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 0;
        }
    }
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [view layoutIfNeeded];
                         if (animation) animation();
                     }
                     completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

@end
