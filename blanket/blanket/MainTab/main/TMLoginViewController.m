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
    [self configSubView];
    [self addNotifacations];
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
//    [UIColor colorWithRed:81.0/255.0 green:136/255.0 blue:210/255.0 alpha:1];
//     [UIColor colorWithRed:77/255.0 green:96/255.0 blue:129/255.0 alpha:1];
    UIImageView * backImageView = [[UIImageView alloc] initWithFrame:UIScreenFrame];
    backImageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:backImageView];
    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 107)];
    iconImageView.image = [UIImage imageNamed:@"logo"];
    iconImageView.st_centerX = UIScreenWidth /2;
    iconImageView.st_top = 40;
    [self.view addSubview:iconImageView];
    
    UIImageView * titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 113, 26)];
    titleImageView.image = [UIImage imageNamed:@"昆仑部落"];
    titleImageView.st_centerX = UIScreenWidth /2;
    titleImageView.st_top = iconImageView.bottom + 22;
    [self.view addSubview:titleImageView];
    
    UIView * accountView = [self configAccountTextFiled];
    accountView.st_top = titleImageView.st_bottom + 50;
    [self.view addSubview:accountView];
    
    UIView * pwdView = [self configpwdTextFiled];
    pwdView.st_top = accountView.st_bottom + 20;
    [self.view addSubview:pwdView];
    
    __weak typeof(self) weakSelf =  self;
    STButton * loginButton = [[STButton alloc] initWithFrame:CGRectMake(30, pwdView.st_bottom + 40, UIScreenWidth - 60, 44)
                                                       title:@"登录"
                                                  titleColor:[UIColor whiteColor]
                                                   titleFont:18
                                                cornerRadius:22
                                             backgroundColor:KL_BlueBackGroundColor
                                             backgroundImage:nil
                                                       image:nil];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedLoginButton];
    }];
    [self.view addSubview:loginButton];
    
    STButton * forgotButton = [[STButton alloc] initWithFrame:CGRectMake(30 + 22, loginButton.st_bottom + 20, 100, 44)
                                                        title:@"忘记密码?"
                                                   titleColor:[UIColor whiteColor]
                                                    titleFont:13
                                                 cornerRadius:0
                                              backgroundColor:[UIColor clearColor]
                                              backgroundImage:nil
                                                        image:nil];
    forgotButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgotButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedforgotButton];
    }];
    [self.view addSubview:forgotButton];
    
    STButton * registerButton = [[STButton alloc] initWithFrame:CGRectMake(30, loginButton.st_bottom + 20, 100, 44)
                                                          title:@"立即注册"
                                                     titleColor:[UIColor whiteColor]
                                                      titleFont:13
                                                   cornerRadius:0
                                                backgroundColor:[UIColor clearColor]
                                                backgroundImage:nil
                                                          image:nil];
    registerButton.st_right = loginButton.st_right - 22;
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedregisterButton];
    }];
    [self.view addSubview:registerButton];
    
    //copyRight
    STLabel * commpanyLable = [[STLabel alloc] initWithFrame:CGRectMake(15, 0, UIScreenWidth - 30 , 13)
                                                        text:@"四川昆仑电子商务有限公司"
                                                   textColor:[UIColor whiteColor]
                                                        font:12
                                                 isSizetoFit:NO
                                               textAlignment:NSTextAlignmentCenter];
    commpanyLable.st_centerX = UIScreenWidth / 2;
    [self.view addSubview:commpanyLable];
    STLabel * copyLable = [[STLabel alloc] initWithFrame:CGRectMake(15, 0, UIScreenWidth - 30, 13)
                                                    text:@"Sichuan kunlun electronic business limited"
                                               textColor:[UIColor whiteColor]
                                                    font:12
                                             isSizetoFit:NO
                                           textAlignment:NSTextAlignmentCenter];
    copyLable.st_centerX = UIScreenWidth / 2;
    copyLable.st_bottom = UIScreenHeight - 20 ;
    commpanyLable.st_bottom = copyLable.st_top - 5;
    [self.view addSubview:copyLable];
    
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
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(30, 0, UIScreenWidth - 60, 44)];
    view.backgroundColor = textFiledBackgroundColor;
    view.layer.cornerRadius = 22;
    view.clipsToBounds = YES;
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, view.st_width - 44, 44)];
    textFiled.placeholder = @"用户名/手机号";
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,25, 44)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 14, 18)];
    leftImageView.centerY = leftView.height / 2;
    leftImageView.image = [UIImage imageNamed:@"icon01_user"];
    [leftView addSubview:leftImageView];
    textFiled.leftView = leftView;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFiled.textColor = [UIColor whiteColor];
    textFiled.backgroundColor =  textFiledBackgroundColor;
    [view addSubview:textFiled];
    self.accountTextFiled = textFiled;
    return view;
}
- (UIView*)configpwdTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(30, 0, UIScreenWidth - 60, 44)];
    view.backgroundColor = textFiledBackgroundColor;
    view.layer.cornerRadius = 22;
    view.clipsToBounds = YES;
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, view.st_width - 44, 44)];
    textFiled.placeholder = @"密码";
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 44)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 12, 15)];
    leftImageView.image = [UIImage imageNamed:@"icon01_密码"];
    leftImageView.centerY = leftView.height / 2;
    [leftView addSubview:leftImageView];
    textFiled.leftView = leftView;
    textFiled.textColor = [UIColor whiteColor];
    textFiled.backgroundColor = textFiledBackgroundColor;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFiled.keyboardType = UIKeyboardTypeASCIICapable;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:textFiled];
    textFiled.secureTextEntry = YES;
    self.pwdTextFiled = textFiled;
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

