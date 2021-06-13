//
//  GHTabbarViewController.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMTabbarViewController.h"
#import "BLHomeViewController.h"
#import "BLSupplyViewController.h"
#import "BLRechargeViewController.h"
#import "BLMineViewController.h"
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
        UIColor * color = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:11.f], NSForegroundColorAttributeName : color} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:BL_BlueBackGroundColor} forState:UIControlStateSelected];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configNav{
    
    STNavigationController *homeNav = [[STNavigationController alloc] initWithRootViewController:[BLHomeViewController new]];
    UIImage * homeSelsetedImage = [[UIImage imageNamed:@"首页1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * homeNormalImage = [[UIImage imageNamed:@"首页2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem = [[UITabBarItem new] initWithTitle:@"首页" image:homeNormalImage selectedImage:homeSelsetedImage];
    
    STNavigationController *productNav = [[STNavigationController alloc] initWithRootViewController:[BLSupplyViewController new]];
    UIImage * studySelsetedImage = [[UIImage imageNamed:@"补给站2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * studuNormalImage = [[UIImage imageNamed:@"补给站1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    productNav.tabBarItem = [[UITabBarItem new] initWithTitle:@"补给站" image:studuNormalImage selectedImage:studySelsetedImage];
    
    
    STNavigationController *patenarNav = [[STNavigationController alloc] initWithRootViewController:[BLRechargeViewController new]];
    UIImage * rebSelsetedImage = [[UIImage imageNamed:@"充值"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * rebNormalImage = [[UIImage imageNamed:@"充值1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    patenarNav.tabBarItem = [[UITabBarItem new] initWithTitle:@"充值" image:rebNormalImage selectedImage:rebSelsetedImage];
    
    STNavigationController *mineNav = [[STNavigationController alloc] initWithRootViewController:[BLMineViewController new]];
    UIImage * mySelsetedImage = [[UIImage imageNamed:@"我的2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * myNormalImage = [[UIImage imageNamed:@"我的1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem = [[UITabBarItem new] initWithTitle:@"我的" image:myNormalImage selectedImage:mySelsetedImage];
    
    //self.viewControllers = @[homeNav,productNav,detailNav,rebeatNav,mineNav];
    self.viewControllers = @[homeNav,productNav,patenarNav,mineNav];
}


@end

