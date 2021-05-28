//
//  STRadioButton.h
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  说明：单选框

#import <UIKit/UIKit.h>

@interface STRadioButton : UIView
@property(nonatomic,strong)NSString         *checkedString;//当前选中的按钮title
@property(nonatomic,strong)NSNumber         *checkedNum;
@property(nonatomic)NSInteger               makenumOfarrayChecked;//选中某个按钮
@property(nonatomic,readonly)NSInteger               count;//一共多少个按钮
@property(nonatomic,strong)UIColor            *titleColor;//标题颜色
@property(nonatomic,strong)UIColor            *selectedTitleColor;
@property(nonatomic, copy) void(^actionHandle)(NSInteger index);
-(instancetype)initWithRadio:(NSArray<NSString*>*)array andWithFrame:(CGRect)frame;

@end
