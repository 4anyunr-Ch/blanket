//
//  STUserManger.m
//  GodHorses
//
//  Created by Mac on 2017/11/25.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STUserManger.h"
#define currentUser @"currentUser"
#define GH_USER_TOKEN @"GH_USER_TOKEN"
#define GH_USERID     @"GH_USERID"
@implementation STUserManger
+ (STUserManger *)defult{
    static STUserManger * deflut = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deflut = [STUserManger new];
    });
    return deflut;
}

- (NSString *)token{
    NSString * token = [[NSUserDefaults standardUserDefaults] valueForKey:GH_USER_TOKEN];
    return token;
}
- (NSString *)userID{
    NSString * token = [[NSUserDefaults standardUserDefaults] valueForKey:GH_USERID];
    return token;
}
- (void)updateToken:(NSString *)token{
    if (token.length) {
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:GH_USER_TOKEN];
    }else{
        NSLog(@"GH_USER_TOKEN 不能为空");
    }
}
- (void)updateUserID:(NSString *)userID{
    if (userID.length) {
        [[NSUserDefaults standardUserDefaults] setValue:userID forKey:GH_USERID];
    }else{
        NSLog(@"GH_USERID 不能为空");
    }
}
- (void)removeUserPreferce{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GH_USER_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GH_USERID];
}
- (void)removeToken{
    
}
@end
