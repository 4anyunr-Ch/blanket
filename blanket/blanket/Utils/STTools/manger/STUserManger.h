//
//  STUserManger.h
//  GodHorses
//
//  Created by Mac on 2017/11/25.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STUserManger : NSObject
@property(nonatomic, strong) NSString                     *token;
@property(nonatomic, strong) NSString                     *userID;
+ (STUserManger*)defult;
- (void)updateToken:(NSString *)token;
- (void)updateUserID:(NSString *)userID;
//删除用户信息
- (void)removeUserPreferce;
@end
