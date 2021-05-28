//
//  GHTabbarViewController.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMTabbarViewController.h"

@interface TMTabbarViewController ()

@end

@implementation TMTabbarViewController
//
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configNav];
        self.tabBar.backgroundColor = [UIColor whiteColor];
        self.tabBar.barTintColor = [UIColor whiteColor];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:11.f], NSForegroundColorAttributeName : KL_secendTextColor} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:KL_BlueBackGroundColor} forState:UIControlStateSelected];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configNav{
    
    STNavigationController *homeNav = [[STNavigationController alloc] initWithRootViewController:[UIViewController new]];
    UIImage * homeSelsetedImage = [[UIImage imageNamed:@"icon_首页选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * homeNormalImage = [[UIImage imageNamed:@"icon_首页未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem = [[UITabBarItem new] initWithTitle:@"首页" image:homeNormalImage selectedImage:homeSelsetedImage];
    
    STNavigationController *productNav = [[STNavigationController alloc] initWithRootViewController:[UIViewController new]];
    UIImage * studySelsetedImage = [[UIImage imageNamed:@"icon_咨讯选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * studuNormalImage = [[UIImage imageNamed:@"icon_咨讯未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    productNav.tabBarItem = [[UITabBarItem new] initWithTitle:@"资讯" image:studuNormalImage selectedImage:studySelsetedImage];
    
    
    STNavigationController *patenarNav = [[STNavigationController alloc] initWithRootViewController:[UIViewController new]];
    UIImage * rebSelsetedImage = [[UIImage imageNamed:@"icon_购物车选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * rebNormalImage = [[UIImage imageNamed:@"icon_购物车未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    patenarNav.tabBarItem = [[UITabBarItem new] initWithTitle:@"购物车" image:rebNormalImage selectedImage:rebSelsetedImage];
    
    STNavigationController *mineNav = [[STNavigationController alloc] initWithRootViewController:[UIViewController new]];
    UIImage * mySelsetedImage = [[UIImage imageNamed:@"icon_我的选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * myNormalImage = [[UIImage imageNamed:@"icon_我的未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem = [[UITabBarItem new] initWithTitle:@"我的" image:myNormalImage selectedImage:mySelsetedImage];
    
    //self.viewControllers = @[homeNav,productNav,detailNav,rebeatNav,mineNav];
    self.viewControllers = @[homeNav,productNav,patenarNav,mineNav];
}


@end

