//
//  TMNavgationViewController.m
//  blanket
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMNavgationViewController.h"

@interface TMNavgationViewController ()

@end

@implementation TMNavgationViewController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    
    if (self = [super initWithRootViewController:rootViewController]) {
        self.interactivePopGestureRecognizer.delegate = (id)self;
        [self.navigationBar setBarTintColor:BL_BlueBackGroundColor];
        self.navigationBar.backgroundColor = BL_BlueBackGroundColor;
        self.navigationBar.translucent = YES;
        self.view.backgroundColor = [UIColor whiteColor];
        //title
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
