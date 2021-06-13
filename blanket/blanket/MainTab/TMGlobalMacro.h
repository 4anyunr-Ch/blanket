//
//  GHGlobalMacro.h
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#ifndef KLGlobalMacro_h
#define KLGlobalMacro_h

#define UIColorFromRGBA(v)  [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIScreenFrame  [UIScreen mainScreen].bounds
#define UINavigationBarHeight 64
#define ios11  ([UIDevice currentDevice].systemVersion.floatValue > 11.0)

#define KL_firstTextColor       UIColorFromRGBA(0x333333)
#define KL_secendTextColor      UIColorFromRGBA(0x666666)
#define KL_thirdTextColor       UIColorFromRGBA(0x999999)
#define KL_lineColor            UIColorFromRGBA(0xd9d9d9)
#define KL_backgroundColor      UIColorFromRGBA(0xf2f2f2)

#define KL_redColor             UIColorFromRGBA(0xf03611)
#define KL_grayBackGroundColor  UIColorFromRGBA(0xB3B3B3)
#define KL_YellowBackGroundColor  UIColorFromRGBA(0xD89c10)
#define KL_BlueBackGroundColor   UIColorFromRGBA(0x2a92ea)
#define KL_BlackBackGroundColor UIColorFromRGBA(0x1a1a1a)
#define KL_placeHoderImage      [UIImage new]
//bl
#define BL_firstTextColor       UIColorFromRGBA(0x333333)
#define BL_secendTextColor      UIColorFromRGBA(0x666666)
#define BL_thirdTextColor       UIColorFromRGBA(0x999999)
#define BL_lineColor            UIColorFromRGBA(0xd9d9d9)
#define BL_backgroundColor      UIColorFromRGBA(0xf2f2f2)

#define BL_redColor             UIColorFromRGBA(0xf03611)
#define BL_grayBackGroundColor  UIColorFromRGBA(0xB3B3B3)
#define BL_YellowBackGroundColor  UIColorFromRGBA(0xD89c10)
#define BL_BlueBackGroundColor    [UIColor colorWithRed:0/255.0 green:147/255.0 blue:215/255.0 alpha:1]
#define BL_BlackBackGroundColor UIColorFromRGBA(0x1a1a1a)
#define BL_placeHoderImage      [UIImage new]
//今后统一规范，不在使用前缀，多个app通用
#define FirstTextColor       UIColorFromRGBA(0x333333)
#define SecendTextColor      UIColorFromRGBA(0x666666)
#define ThirdTextColor       UIColorFromRGBA(0x999999)
#define LineColor            UIColorFromRGBA(0xd9d9d9)
#define BackgroundColor      UIColorFromRGBA(0xf2f2f2)

#endif /* KLGlobalMacro_h */
