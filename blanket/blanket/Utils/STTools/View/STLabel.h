//
//  STLabel.h
//  lover
//
//  Created by stoneobs on 16/5/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  可以居上的lable

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface STLabel : UILabel

/**
 可以居中居上居下的label
 */
@property (nonatomic) VerticalAlignment verticalAlignment;
-(instancetype)initWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor font:(CGFloat)font isSizetoFit:(BOOL)isSizetoFit textAlignment:(NSTextAlignment)textAlignment;
@end
