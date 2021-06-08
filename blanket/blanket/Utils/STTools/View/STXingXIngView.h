//
//  STXingXIngView.h
//  GodHorses
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/************评价星星******************/
@interface STXingXIngView : UIView
@property(nonatomic, assign) NSInteger                     chosedNum;
- (instancetype)initWithFrame:(CGRect)frame maxsNum:(NSInteger)maxsNum;
//传入几颗星星点亮
- (void)makeXingXingSelectedWithNum:(NSInteger)num;
@end
