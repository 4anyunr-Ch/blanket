//
//  STAutoAddView.h
//  GodHorses
//
//  Created by Mac on 2017/11/18.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/************上平加减按钮，自动计算数字******************/
@interface STAutoAddView : UIView
@property(nonatomic, strong) NSString                     *currentNum;
@property(nonatomic, strong) UIButton                     *addButton;//+
@property(nonatomic, strong) UIButton                     *reduceButton;//-

@end
