//
//  GHUtils.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMUtils.h"

@implementation TMUtils
+ (void)netWorkMonitorinCanUseWithHandle:(void (^)())handle{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            if (handle) {
                handle();
            }
        }
    }];
    [manager startMonitoring];
}
@end
