//
//  STNoresultView.h
//  KunLun
//
//  Created by Mac on 2017/11/27.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/************无数据view******************/
@interface STNoresultView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString*)title
                  buttonTitle:(NSString*)buttonTitle
                 buttonHandle:(void(^)(NSString* titleString))handle;
@end
