//
//  GHForgotViewController.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMRegisterViewController.h"
#import "UITextField+STInputLimit.h"
#import "STSendButton.h"
#import "TMLoginViewController.h"
#define Defutlt_witdh (UIScreenWidth - 60)
//[UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1]
//#define textFieldbackColor [UIColor colorWithRed:77/255.0 green:96/255.0 blue:129/255.0 alpha:1]
#define textFieldbackColor [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1]
@interface TMRegisterViewController ()<STSendButtonDlegate>;
@property(nonatomic, strong) UITextField                     *accountTextFiled;
@property(nonatomic, strong) UITextField                     *pwdTextFiled;
@property(nonatomic, strong) UITextField                     *confimPwdTextFiled;
@property(nonatomic, strong) UITextField                     *codeTextFiled;
@property(nonatomic, strong) STSendButton                     *sendButton;
@end

@implementation TMRegisterViewController
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark --vc 生命周期
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"注册";
    [self configSubView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self st_hideNavagetionbarAnimated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [self st_showNavagationbarAnimated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
    }else if (notify.object == self.codeTextFiled){
        [self.accountTextFiled st_textInputLimitWithLength:6];
    }else if (notify.object == self.confimPwdTextFiled){
        [self.accountTextFiled st_textInputLimitWithLength:16];
    }
}
- (void)dealloc{
    [self.sendButton timerEnd];
    self.sendButton = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark --subView
- (void)configSubView{
//    UIImageView * backImageView = [[UIImageView alloc] initWithFrame:UIScreenFrame];
//    backImageView.image = [UIImage imageNamed:@"bg"];
//    [self.view addSubview:backImageView];
    self.view.backgroundColor = [UIColor whiteColor];
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
    accountView.st_top = titleImageView.bottom + 40;
    [self.view addSubview:accountView];
    
    UIView * codeView = [self configCodeTextFiled];
    codeView.st_top =  accountView.st_bottom + 20;
    [self.view addSubview:codeView];
    
    UIView * pwdView = [self configpwdTextFiled];
    pwdView.st_top = 20 + codeView.st_bottom;
    [self.view addSubview:pwdView];
    
    UIView * confimPwdView = [self configConfirmpwdTextFiled];
    confimPwdView.st_top = 20 + pwdView.st_bottom;
    [self.view addSubview:confimPwdView];
    
    __weak typeof(self) weakSelf =  self;
    STButton * loginButton = [[STButton alloc] initWithFrame:CGRectMake(30, confimPwdView.st_bottom + 30, Defutlt_witdh, 44)
                                                       title:@"注册"
                                                  titleColor:[UIColor whiteColor]
                                                   titleFont:18
                                                cornerRadius:22
                                             backgroundColor:KL_BlueBackGroundColor
                                             backgroundImage:nil
                                                       image:nil];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedRegisterButton];
    }];
    [self.view addSubview:loginButton];
}
- (UIView*)configAccountTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(30, 0, Defutlt_witdh , 44)];
    view.backgroundColor = textFieldbackColor;
    view.layer.cornerRadius = 22;
    view.clipsToBounds = YES;
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, view.st_width - 44, 44)];
    textFiled.placeholder = @"用户名/手机号";
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 15)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 15)];
    leftImageView.image = [UIImage imageNamed:@"icon01_user"];
    [leftView addSubview:leftImageView];
    textFiled.leftView = leftView;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:textFiled];
    self.accountTextFiled = textFiled;
    return view;
}
- (UIView*)configCodeTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(30, 0, UIScreenWidth - 60, 44)];
    view.backgroundColor = textFieldbackColor;
    view.layer.cornerRadius = 22;
    view.clipsToBounds = YES;
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, view.st_width - 44, 44)];
    textFiled.placeholder = @"请输入验证码";
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 15)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 15)];
    leftImageView.image = [UIImage imageNamed:@"icon01_验证码"];
    [leftView addSubview:leftImageView];
    textFiled.leftView = leftView;
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    //  textFiled.textColor = UIColorFromRGBA(0xB3B3B3);
    //倒计时
    self.sendButton = [[STSendButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30) andWithDuration:60];
    self.sendButton.backgroundColor = FlatRed;
    self.sendButton.layer.cornerRadius = 15;
    self.sendButton.clipsToBounds = YES;
    self.sendButton.delegate = self;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
    textFiled.rightView = self.sendButton;
    [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    textFiled.rightViewMode = UITextFieldViewModeAlways;
    [view addSubview:textFiled];
    self.codeTextFiled = textFiled;
    // textFiled.textColor = UIColorFromRGBA(0xB3B3B3);
    return view;
}
- (UIView*)configpwdTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(30, 0, UIScreenWidth - 60, 44)];
    view.backgroundColor = textFieldbackColor;
    view.layer.cornerRadius = 22;
    view.clipsToBounds = YES;
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, view.st_width - 44, 44)];
    textFiled.placeholder = @"请输入密码";
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 15)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 15)];
    leftImageView.image = [UIImage imageNamed:@"icon01_密码"];
    [leftView addSubview:leftImageView];
    textFiled.leftView = leftView;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFiled.keyboardType = UIKeyboardTypeASCIICapable;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    textFiled.secureTextEntry = YES;
    [view addSubview:textFiled];
    self.pwdTextFiled = textFiled;
    // textFiled.textColor = UIColorFromRGBA(0xB3B3B3);
    return view;
}
- (UIView*)configConfirmpwdTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(30, 0, UIScreenWidth - 60, 44)];
    view.backgroundColor = textFieldbackColor;
    view.layer.cornerRadius = 22;
    view.clipsToBounds = YES;
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, view.st_width - 44, 44)];
    textFiled.placeholder = @"请确认密码";
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 15)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 15)];
    leftImageView.image = [UIImage imageNamed:@"icon01_密码"];
    [leftView addSubview:leftImageView];
    textFiled.leftView = leftView;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFiled.keyboardType = UIKeyboardTypeASCIICapable;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    textFiled.secureTextEntry = YES;
    // textFiled.textColor = UIColorFromRGBA(0xB3B3B3);
    [view addSubview:textFiled];
    self.confimPwdTextFiled = textFiled;
    return view;
}
#pragma mark --STSendButtonDlegate
- (BOOL)STSendButtonWillClic:(UIButton *)button{
    if (self.accountTextFiled.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return NO;
    }
    return YES;
}
- (void)STSendButtonDidClic:(UIButton*)button isFirstClic:(BOOL)isFirstClic duration:(NSInteger)duration{
    

    if (isFirstClic) {
        [self sendcodeRequest];
    }
}

- (void)STSendButtonDidCountdown:(UIButton*)button duration:(NSInteger)duration{
    [self.sendButton setTitle:[NSString stringWithFormat:@"%ld秒",duration] forState:UIControlStateNormal];
}
- (void)STSendButtonTimeEnded:(UIButton*)button{
    [self.sendButton timerEnd];
    [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}
#pragma mark --Action Method
- (void)onSelectedRegisterButton{
    if (self.accountTextFiled.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    if (self.codeTextFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (self.pwdTextFiled.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (![self.pwdTextFiled.text isEqualToString:self.confimPwdTextFiled.text] ) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不同"];
        return;
    }
    [self sendRegisterRequest];
}
#pragma mark --NetWork Method
- (void)sendcodeRequest{

    NSMutableDictionary * dic = [NSMutableDictionary new];
    if (self.accountTextFiled.text.length) {
        [dic setObject:self.accountTextFiled.text forKey:@"mobile"];
    }
    [SVProgressHUD showWithStatus:@"正在发送"];
    [[STNetWrokManger defaultClient] requestWithPath:@"http://test.smqyp.com/Api/User/sendSms"
                                              method:STHttpRequestTypePost
                                          parameters:dic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 [SVProgressHUD showSuccessWithStatus:@"验证码已成功发送"];
                                                 [self.sendButton timerBegin];
                                            
                                                 
                                             } failure:^(NSString *stateCode, STError *error) {
                                                 [SVProgressHUD dismiss];
                                                 [self.sendButton timerEnd];
                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                             }];
}
- (void)sendRegisterRequest{
    [SVProgressHUD showWithStatus:@"正在注册"];
    NSMutableDictionary * dic = [NSMutableDictionary new];
    if (self.accountTextFiled.text.length) {
        [dic setObject:self.accountTextFiled.text forKey:@"mobile"];
    }
    if (self.codeTextFiled.text.length) {
        [dic setObject:self.codeTextFiled.text forKey:@"code"];
    }
    if (self.pwdTextFiled.text.length) {
        [dic setObject:self.pwdTextFiled.text forKey:@"password"];
    }
    if (self.confimPwdTextFiled.text.length) {
        [dic setObject:self.confimPwdTextFiled.text forKey:@"confirmpwd"];
    }
    if (dic.allKeys.count != 4) {
        NSLog(@"注册参数错误");
        return;
    }
    [[STNetWrokManger defaultClient] requestWithPath:@"http://test.smqyp.com/Api/User/register"
                                              method:STHttpRequestTypePost
                                          parameters:dic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 [SVProgressHUD showWithStatus:@"注册成功，正在为您自动登录"];
                                                 TMLoginViewController * loginvc =(TMLoginViewController*) self.navigationController.childViewControllers.firstObject;
                                                 [loginvc  loginWithMobie:self.accountTextFiled.text pwssWord:self.pwdTextFiled.text];
   
                                             } failure:^(NSString *stateCode, STError *error) {
                                                 [SVProgressHUD dismiss];
                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                             }];
}

@end

