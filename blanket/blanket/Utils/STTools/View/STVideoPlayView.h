//
//  STVideoPlayView.h
//  STNewTools
//
//  Created by stoneobs on 17/4/12.
//  Copyright © 2017年 stoneobs. All rights reserved.
//
//**********************这是一个视屏播放View***************************
#import <UIKit/UIKit.h>

@interface STVideoPlayView : UIView

@property(nonatomic,strong)NSString            *videoUrl;

@property(nonatomic,strong)NSString            *backGroundImageUrl;//背景图

@property(nonatomic,strong)NSString            *title;//标题

@property(nonatomic,assign)BOOL                 shouldHideImageViewWhenReady;//是否在转备好的时候隐藏背景图

@property(nonatomic,assign)BOOL                 shouldPlayVoice;//是否展示声音，默认yes


@property(nonatomic,copy)void(^backActionHandle)();

- (instancetype)initWithFrame:(CGRect)frame  andVideoUrl:(NSString*)videoUrl;


- (void)pause;

- (void)play;
@end
