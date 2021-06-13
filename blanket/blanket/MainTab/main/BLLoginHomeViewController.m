//
//  BLLoginHomeViewController.m
//  blanket
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "BLLoginHomeViewController.h"
#import "TMLoginViewController.h"
#import "TMForgotViewController.h"
#import "TMRegisterViewController.h"
@interface BLLoginHomeViewController ()

@end

@implementation BLLoginHomeViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark --vc 生命周期
- (void)viewDidLoad{
    [super viewDidLoad];
    [self configSubView];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self st_hideNavagetionbarAnimated:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self st_showNavagationbarAnimated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark --subView
- (void)configSubView{
    UIImageView * backImageView = [[UIImageView alloc] initWithFrame:UIScreenFrame];
    backImageView.image = [UIImage imageNamed:@"登录背景"];
    [self.view addSubview:backImageView];
    
    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 170, 100, 100)];
    iconImageView.image = [UIImage imageNamed:@"logo"];
    iconImageView.centerX = UIScreenWidth / 2;
    [self.view addSubview:iconImageView];
    
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(0, iconImageView.bottom + 20, UIScreenWidth, 36)
                                                     text:@"铺盖科技"
                                                textColor:[UIColor whiteColor]
                                                     font:26
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLable];
    
    __weak typeof(self) weakSelf =  self;
    STButton * loginButton = [[STButton alloc] initWithFrame:CGRectMake(30, titleLable.st_bottom + 40, UIScreenWidth - 60, 44)
                                                       title:@"登录"
                                                  titleColor:[UIColor whiteColor]
                                                   titleFont:18
                                                cornerRadius:5
                                             backgroundColor:nil
                                             backgroundImage:[UIImage imageNamed:@"登录框"]
                                                       image:nil];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedLoginButton];
    }];
    [self.view addSubview:loginButton];
    

    
    STButton * registerButton = [[STButton alloc] initWithFrame:CGRectMake(30, loginButton.st_bottom + 20, UIScreenWidth - 60, 44)
                                                          title:@"注册"
                                                     titleColor:[UIColor whiteColor]
                                                      titleFont:18
                                                   cornerRadius:5
                                                backgroundColor:nil
                                                backgroundImage:[UIImage imageNamed:@"登录框"]
                                                          image:nil];
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [registerButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedregisterButton];
    }];
     [self.view addSubview:registerButton];
    
    STButton * forgotButton = [[STButton alloc] initWithFrame:CGRectMake(30 + 22, registerButton.st_bottom + 5, 100, 44)
                                                        title:@"忘记密码?"
                                                   titleColor:BL_BlueBackGroundColor
                                                    titleFont:13
                                                 cornerRadius:0
                                              backgroundColor:[UIColor clearColor]
                                              backgroundImage:nil
                                                        image:nil];
    forgotButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgotButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedforgotButton];
    }];
    forgotButton.right = registerButton.right;
    [self.view addSubview:forgotButton];
    
}
#pragma mark --Action Method
- (void)onSelectedLoginButton{

  [self.navigationController pushViewController:[TMLoginViewController new] animated:YES];
}
- (void)onSelectedforgotButton{
    [self.navigationController pushViewController:[TMForgotViewController new] animated:YES];
}
- (void)onSelectedregisterButton{
    
  [self.navigationController pushViewController:[TMRegisterViewController new] animated:YES];
}
@end
