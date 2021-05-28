//
//  STSendButton.h
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  发送验证码button，可以倒计时
#import <UIKit/UIKit.h>
@protocol STSendButtonDlegate <NSObject>

/**
 将要点击，可判断一系列状态

 @param button button description
 @return return 返回yes 响应点击事件，返回NO，不响应
 */
- (BOOL)STSendButtonWillClic:(UIButton*)button;
/**
 点击按钮

 @param button 按钮
 @param isFirstClic 是否是第一次点击
 @param duration  时间
 */
- (void)STSendButtonDidClic:(UIButton*)button isFirstClic:(BOOL)isFirstClic duration:(NSInteger)duration;

//即将倒计时
//- (void)STSendButtonWillCountdown:(UIButton*)button duration:(NSInteger)duration;

/**
 正在倒计时，此时可以使用关闭按钮交互，并且title 随动

 @param button 按钮
 @param duration 当前剩余时间
 */
- (void)STSendButtonDidCountdown:(UIButton*)button duration:(NSInteger)duration;

/**
 设置的时间已经结束

 @param button 倒计时按钮
 */
- (void)STSendButtonTimeEnded:(UIButton*)button;
@end
#import <UIKit/UIKit.h>

@interface STSendButton : UIButton
@property(nonatomic,assign)NSInteger            duration;//时间
@property(nonatomic,weak)id<STSendButtonDlegate>            delegate;
-(instancetype)initWithFrame:(CGRect)frame andWithDuration:(NSInteger)duration;
-(void)timerBegin;//手动开始
-(void)timerEnd;//手动结束


@end



//用法示例
//-(void)STSendButtonDidClic:(UIButton *)button isFirstClic:(BOOL)isFirstClic duration:(NSInteger)duration
//{
//    [self.sendButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",duration] forState:UIControlStateNormal];
//    self.sendButton.userInteractionEnabled = NO;
//    [self.sendButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
//    //开始
//    [self.sendButton timerBegin];
//    
//}
//-(void)STSendButtonDidCountdown:(UIButton *)button duration:(NSInteger)duration
//{
//    [self.sendButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",duration] forState:UIControlStateNormal];
//    
//}
//-(void)STSendButtonTimeEnded:(UIButton *)button
//{
//    [self.sendButton setTitleColor:THEME_BLUE forState:UIControlStateNormal];
//    self.sendButton.userInteractionEnabled = YES;
//    [self.sendButton timerEnd];
//    [self.sendButton setTitle:@"重新发送" forState:UIControlStateNormal];
//    
//}
