//
//  LVScanTwoCodeController.h
//  lover
//
//  Created by stoneobs on 16/4/8.
//  Copyright © 2016年 stoneobs. All rights reserved.
// 二维码控制器，

#import <UIKit/UIKit.h>
typedef void(^STScanTwoCodeControllerResult)(NSString * result);
@interface STScanTwoCodeController : UIViewController
-(instancetype)initWithHandle:(STScanTwoCodeControllerResult)handle;
@end
