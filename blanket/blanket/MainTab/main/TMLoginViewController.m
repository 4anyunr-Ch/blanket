//
//  GHLoginViewController.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMLoginViewController.h"
#import "UITextField+STInputLimit.h"
#import "TMForgotViewController.h"
#import "TMRegisterViewController.h"
#import "TMTabbarViewController.h"
#define textFiledBackgroundColor [UIColor colorWithRed:77/255.0 green:96/255.0 blue:129/255.0 alpha:1]
@interface TMLoginViewController ()
@property(nonatomic, strong) UITextField                     *accountTextFiled;
@property(nonatomic, strong) UITextField                     *pwdTextFiled;
@end

@implementation TMLoginViewController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark --vc 生命周期
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"登录";
    [self configSubView];
    [self addNotifacations];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark --Notifacation
- (void)addNotifacations{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
}
- (void)textFieldTextDidChangeNotification:(NSNotification*)notify{
    if (notify.object == self.pwdTextFiled) {
        [self.pwdTextFiled st_textInputLimitWithLength:16];
    }else if (notify.object == self.accountTextFiled){
        [self.accountTextFiled st_textInputLimitWithLength:11];
    }
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --subView
- (void)configSubView{

    
    UIView * accountView = [self configAccountTextFiled];
    accountView.st_top = 100;
    [self.view addSubview:accountView];
    
    UIView * pwdView = [self configpwdTextFiled];
    pwdView.st_top = accountView.st_bottom + 20;
    [self.view addSubview:pwdView];
    
    __weak typeof(self) weakSelf =  self;
    STButton * loginButton = [[STButton alloc] initWithFrame:CGRectMake(30, pwdView.st_bottom + 40, UIScreenWidth - 60, 50)
                                                       title:@"登录"
                                                  titleColor:[UIColor whiteColor]
                                                   titleFont:18
                                                cornerRadius:5
                                             backgroundColor:KL_BlueBackGroundColor
                                             backgroundImage:nil
                                                       image:nil];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedLoginButton];
    }];
    [self.view addSubview:loginButton];
    
    
//    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(0, loginButton.st_bottom + 80, 80, 14)
//                                                     text:@"第三方登录"
//                                                textColor:[UIColor whiteColor]
//                                                     font:13
//                                              isSizetoFit:NO
//                                            textAlignment:NSTextAlignmentCenter];
//    titleLable.st_centerX = UIScreenWidth / 2;
//    [self.view addSubview:titleLable];
//    
//    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(52, loginButton.st_bottom + 80, titleLable.st_left - 52, 1)];
//    line1.st_centerY = titleLable.st_centerY;
//    line1.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:line1];
//    
//    
//    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(52, loginButton.st_bottom + 80, titleLable.st_left - 52, 1)];
//    line2.st_centerY = titleLable.st_centerY;
//    line2.st_right = registerButton.st_right;
//    line2.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:line2];
//    
//    STButton * weChatrButton = [[STButton alloc] initWithFrame:CGRectMake(0, line2.st_bottom + 40, 50, 50)
//                                                         title:nil
//                                                    titleColor:nil
//                                                     titleFont:0
//                                                  cornerRadius:25
//                                               backgroundColor:nil
//                                               backgroundImage:[UIImage imageNamed:@"weixin"]
//                                                         image:nil];
//    weChatrButton.st_centerX = UIScreenWidth / 2;
//    [weChatrButton setClicAction:^(UIButton *sender) {
//        [weakSelf onSelectedWeChatButton];
//    }];
//    [self.view addSubview:weChatrButton];
//    
//    STButton * qqButton = [[STButton alloc] initWithFrame:CGRectMake(0, line2.st_bottom + 40, 50, 50)
//                                                    title:nil
//                                               titleColor:nil
//                                                titleFont:0
//                                             cornerRadius:25
//                                          backgroundColor:nil
//                                          backgroundImage:[UIImage imageNamed:@"QQ"]
//                                                    image:nil];
//    qqButton.st_centerX = weChatrButton.st_left - 60;
//    [weChatrButton setClicAction:^(UIButton *sender) {
//        [weakSelf onSelectedQQButton];
//    }];
//    [self.view addSubview:qqButton];
//    
//    STButton * sinaButton = [[STButton alloc] initWithFrame:CGRectMake(0, line2.st_bottom + 40, 50, 50)
//                                                      title:nil
//                                                 titleColor:nil
//                                                  titleFont:0
//                                               cornerRadius:25
//                                            backgroundColor:nil
//                                            backgroundImage:[UIImage imageNamed:@"sina"]
//                                                      image:nil];
//    sinaButton.st_centerX = weChatrButton.st_right + 60;
//    [weChatrButton setClicAction:^(UIButton *sender) {
//        [weakSelf onSelectedQQButton];
//    }];
//    [self.view addSubview:sinaButton];
}
- (UIView*)configAccountTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth , 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 17, 26)];
    leftImageView.image = [UIImage imageNamed:@"手机"];
    leftImageView.centerY = view.height/2;
    [view addSubview:leftImageView];
    
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, view.st_width - 50 - 18, 44)];
    textFiled.placeholder = @"请输入你的手机号";
    textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textFiled.placeholder attributes:@{NSForegroundColorAttributeName:BL_BlueBackGroundColor}];
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:textFiled];
    self.accountTextFiled = textFiled;
    textFiled.rightViewMode = UITextFieldViewModeAlways;
    textFiled.height = 43;
    UIView  * line = [[UIView alloc] initWithFrame:CGRectMake(textFiled.left, textFiled.bottom, textFiled.width, 0.5)];
    line.backgroundColor = BL_BlueBackGroundColor;
    [view addSubview:line];
    return view;
}
- (UIView*)configpwdTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth , 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 20, 26)];
    leftImageView.image = [UIImage imageNamed:@"密码(1)"];
    leftImageView.centerY = view.height/2;
    [view addSubview:leftImageView];
    
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, view.st_width - 50 - 18, 44)];
    textFiled.placeholder = @"请输入密码";
    textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textFiled.placeholder attributes:@{NSForegroundColorAttributeName:BL_BlueBackGroundColor}];
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:textFiled];
    self.pwdTextFiled = textFiled;
    textFiled.rightViewMode = UITextFieldViewModeAlways;
    textFiled.height = 43;
    UIView  * line = [[UIView alloc] initWithFrame:CGRectMake(textFiled.left, textFiled.bottom, textFiled.width, 0.5)];
    line.backgroundColor = BL_BlueBackGroundColor;
    [view addSubview:line];
    return view;
}
#pragma mark --Action Method
- (void)onSelectedLoginButton{
    if (self.accountTextFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (self.accountTextFiled.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    if (self.pwdTextFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"登录中"];
    [self loginWithMobie:self.accountTextFiled.text pwssWord:self.pwdTextFiled.text];
}
- (void)onSelectedforgotButton{
    [self.navigationController pushViewController:[TMForgotViewController new] animated:YES];
}
- (void)onSelectedregisterButton{
    
    [self.navigationController pushViewController:[TMRegisterViewController new] animated:YES];
    //[self.navigationController.view st_showAnimationWithType:STAnimationTypekCATransitionFade];
}
- (void)onSelectedQQButton{
    
}
- (void)onSelectedWeChatButton{
    
}
- (void)onSelectedSinaButton{
    
}
#pragma mark --NetWork Method
- (void)loginWithMobie:(NSString *)mobile pwssWord:(NSString *)passWord{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    if (mobile.length) {
        [dic setObject:mobile forKey:@"mobile"];
    }else{
        NSLog(@"登录手机号为空");
        return;
    }
    if (passWord.length) {
        [dic setObject:passWord forKey:@"password"];
    }else{
        NSLog(@"登录密码为空");
        return;
    }
    
    [[STNetWrokManger defaultClient] requestWithPath:@"http://test.smqyp.com/Api/User/login"
                                              method:STHttpRequestTypePost
                                          parameters:dic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                                                 NSDictionary * dic = [responseObject valueForKey:@"data"];
                                                 if ([dic.allKeys containsObject:@"id"]) {
                                                     NSString * userId = dic[@"id"];
                                                     [[STUserManger defult] updateUserID:userId];
                                                 }
                                                 if ([dic.allKeys containsObject:@"token"]) {
                                                     NSString * token = dic[@"token"];
                                                     [[STUserManger defult] updateToken:token];
                                                 }
                                                 
                                                 [self.view endEditing:YES];
                                                 //更换rootViewControol
                                                 [UIApplication sharedApplication].keyWindow.rootViewController = [TMTabbarViewController new];
                                                 [[UIApplication sharedApplication].keyWindow st_showAnimationWithType:STAnimationTyperippleEffect duration:2];
                                                 
                                             } failure:^(NSString *stateCode, STError *error) {
                                                 [SVProgressHUD dismiss];
                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                             }];
}

@end

