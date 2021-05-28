//
//  STNavigationController.m
//  STTools
//
//  Created by stoneobs on 16/10/9.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STNavigationController.h"
@interface STNavigationController ()

@end

@implementation STNavigationController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{

    if (self = [super initWithRootViewController:rootViewController]) {
        self.interactivePopGestureRecognizer.delegate=(id)self;
        [self.navigationBar setBarTintColor:KL_BlueBackGroundColor];
        self.navigationBar.backgroundColor = KL_BlueBackGroundColor;
        self.navigationBar.translucent = YES;
        self.view.backgroundColor = [UIColor whiteColor];
        //title
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
      
    }
    return self;
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  

    if (self.childViewControllers.count > 0) {
        self.hidesBottomBarWhenPushed = YES;
        //设置返回键
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(back)  forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"icon_返回"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_返回"] forState:UIControlStateHighlighted];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        btn.frame = CGRectMake(0, 0, 44, 44);
        viewController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:btn];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
@end
