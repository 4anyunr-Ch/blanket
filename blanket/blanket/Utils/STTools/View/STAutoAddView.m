//
//  STAutoAddView.m
//  GodHorses
//
//  Created by Mac on 2017/11/18.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STAutoAddView.h"
@interface STAutoAddView()
@property(nonatomic, strong) UILabel                     *titleLable;
@end
@implementation STAutoAddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
    }
    return self;
}
- (NSString *)currentNum{
    return self.titleLable.text;
}
#pragma mark --subView
- (void)configSubView{
    
    CGFloat witdh = self.frame.size.width / 3;
    CGFloat height = self.frame.size.height;
    
    self.reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, witdh, height)];
    self.reduceButton.backgroundColor = KL_backgroundColor;
    [self.reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [self.reduceButton setTitleColor:KL_secendTextColor forState:UIControlStateNormal];
    self.reduceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.reduceButton addTarget:self action:@selector(onSelectedReduceButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reduceButton];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(witdh, 0, witdh, height)];
    self.titleLable.text = @"1";
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.textColor = KL_secendTextColor;
    self.titleLable.font = [UIFont systemFontOfSize:13];
    self.titleLable.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLable];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(witdh * 2, 0, witdh, height)];
    self.addButton.backgroundColor = KL_backgroundColor;
    [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    self.addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.addButton setTitleColor:KL_secendTextColor forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(onSelectedAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
}
#pragma mark --Action Method
- (void)onSelectedReduceButton{
    if ([self.titleLable.text isEqualToString:@"1"]) {
        return;
    }else{
        NSInteger num = [self.titleLable.text integerValue];
        num = num - 1;
        self.titleLable.text = @(num).description;
    }
}
- (void)onSelectedAddButton{
    
    NSInteger num = [self.titleLable.text integerValue];
    num = num + 1;
    self.titleLable.text = @(num).description;
    
}
@end

