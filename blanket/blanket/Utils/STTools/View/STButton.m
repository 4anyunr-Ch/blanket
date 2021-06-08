//
//  STButton.m
//  STTools
//
//  Created by stoneobs on 16/4/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STButton.h"
@interface STButton()
@property(nonatomic,strong)UIButton         *closeButton;
@end

@implementation STButton
- (void)dealloc
{

}
+(STButton*)logoutBut
{
    STButton* but= [[[self class] alloc]initWithFrame:CGRectZero title:@"退出登录" titleColor:[UIColor whiteColor] titleFont:15 cornerRadius:10 backgroundColor:[UIColor darkGrayColor] backgroundImage:nil image:nil];
    
    return but;
}
+(STButton*)registerBut
{
    STButton* but= [[[self class] alloc]initWithFrame:CGRectZero title:@"注册" titleColor:[UIColor whiteColor] titleFont:15 cornerRadius:10 backgroundColor:[UIColor redColor] backgroundImage:nil image:nil];
    
    
    return but;
}
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titlecolor titleFont:(CGFloat)fontsize cornerRadius:(CGFloat)radius backgroundColor:(UIColor *)backcolor backgroundImage:(UIImage *)backgroundimage image:(UIImage *)image
{
    if (self=[super init]) {
        self.frame = frame;
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:fontsize]];
        self.layer.cornerRadius = radius;
        self.clipsToBounds = YES;
        self.backgroundColor = backcolor;
         self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setBackgroundImage:backgroundimage forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clicAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
#pragma mark --Get and Setter
- (void)setShowCloseButton:(BOOL)showCloseButton
{
    if (showCloseButton) {
        UIView  *view = [self viewWithTag:9998];
        [view removeFromSuperview];
        UIButton * test =[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 0, 20, 20)];
        [test setBackgroundImage:[UIImage imageNamed:@"icon_Number"] forState:UIControlStateNormal];
        [test setTitle:@"—" forState:UIControlStateNormal];
        [test setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        test.titleLabel.font = [UIFont systemFontOfSize:10];
        test.layer.cornerRadius = 10;
        test.tag = 9998;
        test.clipsToBounds = YES;
        self.clipsToBounds = NO;
        [self bringSubviewToFront:test];
        [test addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:test];
    } else {
        UIView  *view = [self viewWithTag:9998];
        [view removeFromSuperview];
    }
    
    
    _showCloseButton = showCloseButton;
}
//添加badgeValue
- (void)setBadgeValue:(NSString *)badgeValue
{
    if (badgeValue) {
        if (badgeValue.length > 2) {
            badgeValue=@"99";
        }
        UIView  *view = [self viewWithTag:9999];
        [view removeFromSuperview];
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 7, -7, 14, 14)];
        [icon setBackgroundImage:[UIImage imageNamed:@"icon_Number"] forState:UIControlStateNormal];
        [icon setTitle:badgeValue forState:UIControlStateNormal];
        [icon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        icon.titleLabel.font = [UIFont systemFontOfSize:10];
        icon.layer.cornerRadius = 7;
        icon.tag = 9999;
        icon.clipsToBounds = YES;
        self.clipsToBounds = NO;
        [self addSubview:icon];
        
    }
}


- (void)setClicAction:(STButtonTouchAction)clicAction
{
    if (clicAction) {
        _clicAction=clicAction;
    }
}
- (void)clicAction:(UIButton*)sender
{
    if (self.clicAction) {
        self.clicAction(sender);
    }
}
#pragma mark --Private Method
- (void)showRoundShadow{
    if (!self.superview) {
        //return;
    }
    CALayer *layer = [CALayer layer];
    
    layer.frame = self.frame;
    
    layer.backgroundColor = [UIColor clearColor].CGColor;
    
    layer.shadowColor = [UIColor grayColor].CGColor;
    
    layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width + 5, self.frame.size.height + 5) cornerRadius:52.5].CGPath;
    
    layer.shadowOpacity = 0.5;
    
    layer.shadowOffset = CGSizeMake(-3, -2);
    layer.cornerRadius = 3;
    
    //这里self表示当前自定义的view
    
    [self.superview.layer insertSublayer:layer below:self.layer];
}
- (void)letImageViewAsright:(CGFloat)insetX
{
    //在使用一次titleLabel和imageView后才能正确获取titleSize
    self.titleLabel.backgroundColor = self.titleLabel.backgroundColor;
    self.imageView.backgroundColor = self.imageView.backgroundColor;
    CGSize titleSize = self.titleLabel.bounds.size;
    CGFloat interval = insetX;
    self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
}
- (void)makeImageRight{
    UIImage * image = self.imageView.image;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
}
#pragma mark --selected Action
- (void)removeSelf
{
    if (self.closeAction) {
        self.closeAction(self);
    }
    
}
@end
