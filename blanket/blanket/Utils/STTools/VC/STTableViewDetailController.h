//
//  STTableViewDetailController.h
//  ZuoBiao
//
//  Created by stoneobs on 17/2/17.
//  Copyright © 2017年 stoneobs. All rights reserved.
//  tableiview 详情,单个cell和textfiled

#import <UIKit/UIKit.h>
@class STTableViewDetailController;
typedef void(^STTableViewDetailHandle)(NSString * text);
typedef void(^STTableViewDetailComplete)(NSString * text,STTableViewDetailController * detailControllerVC);
@interface STTableViewDetailController : UIViewController

@property(nonatomic,strong)UITextField                    *textFiled;//可以更改键盘类型

@property(nonatomic,assign)BOOL                           isShowTextNum;//defult yes

@property(nonatomic,assign)NSInteger                      maxTextNum;//defult 15；

@property(nonatomic,strong)NSString                       *rightItemTitle;

@property(nonatomic,strong)UIColor                        *rightItemTitleColor;

@property(nonatomic,strong)UILabel                         *detailLabel;//footerlabel,和数量label

@property(nonatomic,assign)BOOL                            rightBarUserInterface;//默认yes

@property(nonatomic,assign)BOOL                            canotPopViewController;//默认NO

@property(nonatomic,copy)void(^viewWillAppearblock)();

@property(nonatomic,copy)void(^textFiledDidChange)(NSString *text);

- (instancetype)initWithPlaceholder:(NSString*)placeholder
                              title:(NSString*)title
                             handle:(STTableViewDetailHandle) handle;
- (instancetype)initWithPlaceholder:(NSString*)placeholder
                              title:(NSString*)title
                               text:(NSString*)text
                             handle:(STTableViewDetailHandle) handle;
- (instancetype)initWithPlaceholder:(NSString*)placeholder
                              title:(NSString*)title
                           complete:(STTableViewDetailComplete) complete;
- (instancetype)initWithPlaceholder:(NSString*)placeholder
                              title:(NSString*)title
                               text:(NSString*)text
                           complete:(STTableViewDetailComplete) complete;
@end
