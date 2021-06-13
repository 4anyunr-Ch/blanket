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

    self.view.backgroundColor = [UIColor whiteColor];

    UIView * accountView = [self configAccountTextFiled];
    accountView.st_top = 100;
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
    STButton * loginButton = [[STButton alloc] initWithFrame:CGRectMake(30, confimPwdView.st_bottom + 30, Defutlt_witdh, 50)
                                                       title:@"立即注册"
                                                  titleColor:[UIColor whiteColor]
                                                   titleFont:18
                                                cornerRadius:5
                                             backgroundColor:KL_BlueBackGroundColor
                                             backgroundImage:nil
                                                       image:nil];
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedRegisterButton];
    }];
    [self.view addSubview:loginButton];
    
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(0, loginButton.bottom + 30, UIScreenWidth, 45)
                                                     text:@"点击立即注册，即表示您同意并愿意遵守\n用户协议和隐私政策"
                                                textColor:BL_firstTextColor
                                                     font:15
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentCenter];
    titleLable.numberOfLines = 0;
    titleLable.attributedText = [titleLable.text st_convertAttributeStringWithKeyWords:@[@"用户协议",@"隐私政策"]
                                                                            attributes:@[@{NSForegroundColorAttributeName:BL_BlueBackGroundColor},@{NSForegroundColorAttributeName:BL_BlueBackGroundColor}]];
    [self.view addSubview:titleLable];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLable.bottom + 50, 80, 80)];
    imageView.centerX = UIScreenWidth / 2;
    imageView.image = [UIImage imageNamed:@"底图logo"];
    [self.view addSubview:imageView];
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
    //倒计时
    self.sendButton = [[STSendButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30) andWithDuration:60];
    self.sendButton.backgroundColor = BL_BlueBackGroundColor;
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.clipsToBounds = YES;
    self.sendButton.delegate = self;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    textFiled.rightView = self.sendButton;
    textFiled.rightViewMode = UITextFieldViewModeAlways;
    textFiled.height = 43;
    UIView  * line = [[UIView alloc] initWithFrame:CGRectMake(textFiled.left, textFiled.bottom, textFiled.width, 0.5)];
    line.backgroundColor = BL_BlueBackGroundColor;
    [view addSubview:line];
    return view;
}
- (UIView*)configCodeTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth , 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 20, 23)];
    leftImageView.image = [UIImage imageNamed:@"验证码"];
    leftImageView.centerY = view.height/2;
    [view addSubview:leftImageView];
    
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, view.st_width - 50 - 18, 44)];
    textFiled.placeholder = @"请输入验证码";
    textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textFiled.placeholder attributes:@{NSForegroundColorAttributeName:BL_BlueBackGroundColor}];
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:textFiled];
    self.codeTextFiled = textFiled;
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
- (UIView*)configConfirmpwdTextFiled{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth , 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 20, 26)];
    leftImageView.image = [UIImage imageNamed:@"密码(1)"];
    leftImageView.centerY = view.height/2;
    [view addSubview:leftImageView];
    
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, view.st_width - 50 - 18, 44)];
    textFiled.placeholder = @"请再次输入密码";
    textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textFiled.placeholder attributes:@{NSForegroundColorAttributeName:BL_BlueBackGroundColor}];
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:textFiled];
    self.confimPwdTextFiled = textFiled;
    textFiled.rightViewMode = UITextFieldViewModeAlways;
    textFiled.height = 43;
    UIView  * line = [[UIView alloc] initWithFrame:CGRectMake(textFiled.left, textFiled.bottom, textFiled.width, 0.5)];
    line.backgroundColor = BL_BlueBackGroundColor;
    [view addSubview:line];
    
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

