//
//  GHUtils.h
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMUtils: NSObject
//网络可用时候的回调
+ (void)netWorkMonitorinCanUseWithHandle:(void(^)())handle;
@end
