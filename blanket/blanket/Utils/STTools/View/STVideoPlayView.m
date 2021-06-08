//
//  STVideoPlayView.m
//  STNewTools
//
//  Created by stoneobs on 17/4/12.
//  Copyright © 2017年 stoneobs. All rights reserved.
//


#import "STVideoPlayView.h"
#import "UIView+STDirection.h"
#import <AVFoundation/AVFoundation.h>
#import "STProgressHudTool.h"
#import "UIColor+Chameleon.h"
#import "UIImageView+WebCache.h"
#import "STAVResourseLoder.h"
#import "TBloaderURLConnection.h"
//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
typedef NS_ENUM(NSUInteger, toolbarType) {
    toolbarTypeIsBeingIsBeingShow,//正在出现
    toolbarTypeShowed,
    toolbarTypeIsBeingHide,//正在消失
    toolbarTypeDidHide,
};
@interface STVideoPlayView()<AVAssetResourceLoaderDelegate>
//背景图
@property(nonatomic,strong)UIImageView          *backGroundImageView;
//头部view
@property(nonatomic,strong)UIView               *topView;

@property(nonatomic,strong)UIButton             *returnButton;//返回按钮

@property(nonatomic,strong)UILabel              *titleLable;
//底部View
@property(nonatomic,strong)UIView               *bottomView;

@property(nonatomic,strong)UIButton             *playButton;//播放按钮

@property(nonatomic,strong)UILabel              *duringLable;//播放了多少时间

@property(nonatomic,strong)UISlider             *slider;//进度

@property(nonatomic,strong)UILabel              *totalTimeLable;//视屏时长

@property(nonatomic,strong)UIButton             *fullScreenButton;//全屏按钮

//播放器
@property(nonatomic,strong)AVPlayer             *player;//播放器管理

@property(nonatomic,strong)AVPlayerItem         *playerItem;//播放资源

@property(nonatomic,strong)AVPlayerLayer        *playLayer;//播放界面

@property(nonatomic,assign)BOOL                 isReadToPlay;//是否准备好播放了



// 计算
@property(nonatomic,weak)UIView                 *parentView;//父试图

@property(nonatomic,strong)NSDateFormatter      *dateFormatter;//计算

@property(nonatomic,assign)CGRect               originFrame;

@property(nonatomic,assign)CGAffineTransform    originTransform;

@property(nonatomic,assign)toolbarType                 cureentToolState;//工具栏状态


//缓存

@property(nonatomic,strong)dispatch_queue_t            global_cache_queue;

@property(nonatomic,strong)NSMutableArray<AVAssetResourceLoadingRequest*>            *requestArray;

@property(nonatomic,strong)TBloaderURLConnection            *resouerLoader;
@end
@implementation STVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame andVideoUrl:(NSString *)videoUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        self.videoUrl = videoUrl;
        self.originFrame = frame;
        self.originTransform = self.transform;
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        [self configTopView];
        [self configBottomView];
        [self autoHideToolView];
        [self addObserver:self forKeyPath:@"self.playerItem.status" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"self.playerItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    }
    return self;
}

#pragma mark --Geter And Seter
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLable.text = title;
}
- (UIImageView *)backGroundImageView{
    if (_backGroundImageView) {
        return _backGroundImageView;
    }
    _backGroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backGroundImageView.clipsToBounds = YES;
    return _backGroundImageView;
}
- (void)setVideoUrl:(NSString *)videoUrl{

    _videoUrl = videoUrl;
    //初始化播放器
    [self.playLayer removeFromSuperlayer];
    
    //用aseet 初始化可以设置缓存机制
    if (!videoUrl) {
        videoUrl = @"";
    }
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:_videoUrl] resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    AVURLAsset * asset = [AVURLAsset assetWithURL:[components URL]];
    
    
    self.global_cache_queue = dispatch_queue_create("queue For YYMusic Cache", DISPATCH_QUEUE_SERIAL);
    self.requestArray = [NSMutableArray new];
    self.resouerLoader = [TBloaderURLConnection new];
    [asset.resourceLoader setDelegate: self.resouerLoader queue:self.global_cache_queue];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    

    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.playLayer.frame = self.bounds;
    
    

    
       __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        //每播放一秒的回调
        [weakSelf playerIsBeingPlaying];
        
    }];
    
    
}
- (void)setBackGroundImageUrl:(NSString *)backGroundImageUrl{
    _backGroundImageUrl = backGroundImageUrl;
    [self.backGroundImageView sd_setImageWithURL:[NSURL URLWithString:backGroundImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self insertSubview:self.backGroundImageView atIndex:0];
   
}
#pragma mark --kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.playerItem.status"]) {
        id statuskey = change[NSKeyValueChangeNewKey] ;
        if (statuskey && ![statuskey isKindOfClass:[NSNull class]]) {
            AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
            [self judgeItemStatus:status];
        }

    }else if ([keyPath isEqualToString:@"self.playerItem.loadedTimeRanges"]){
    
    
    }
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.playerItem.status"];
    [self removeObserver:self forKeyPath:@"self.playerItem.loadedTimeRanges"];
}
#pragma mark --SubView
- (void)layoutSubviews
{
    [super layoutSubviews];

    
}
- (void)configTopView{

    self.topView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.st_width, 30)];

    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(goBackAction)  forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"STTools.bundle/STImages/nav_back.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"STTools.bundle/STImages/nav_back.png"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 20, 30, 30);
    btn.st_centerY =  self.topView.st_height / 2;
    self.returnButton = btn;
    [self.topView addSubview:self.returnButton];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.st_width - 100, 44)];
    self.titleLable.text = @"fdfsdfdf";
    self.titleLable.st_centerY = self.topView.st_height / 2;
    self.titleLable.st_centerX = self.st_width / 2;
    self.titleLable.font = [UIFont systemFontOfSize:15];
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.titleLable];
    

    [self addSubview:self.topView];
    

}
- (void)configBottomView{

    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.st_width, 30)];
    self.bottomView.st_bottom = self.st_height;
    
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 16, 16)];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"STTools.bundle/STImages/btn_play.png"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"STTools.bundle/STImages/btn_pause.png"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.st_centerY = self.bottomView.st_height /2;
    [self.bottomView addSubview:self.playButton];
    
    UIFont  * font = [UIFont fontWithName:@"AppleGothic" size:10];
    self.duringLable = [[UILabel alloc] initWithFrame:CGRectMake(self.playButton.st_right + 10, 0, 40, 10)];
    self.duringLable.textColor = [UIColor whiteColor];
    self.duringLable.font = font;
    self.duringLable.text = @"00:01";
    self.duringLable.st_centerY = self.bottomView.st_height /2;
    self.duringLable.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:self.duringLable];
    
    
    self.fullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.st_width - 10 - 16, 0, 16, 16)];
    [self.fullScreenButton setBackgroundImage:[UIImage imageNamed:@"STTools.bundle/STImages/btn_fullScreen.png"] forState:UIControlStateNormal];
    [self.fullScreenButton addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.fullScreenButton.st_centerY = self.bottomView.st_height /2;
    [self.bottomView addSubview:self.fullScreenButton];
    
    
    self.totalTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(self.fullScreenButton.st_left - 10 - 40 , 0, 40, 10)];
    self.totalTimeLable.textColor = [UIColor whiteColor];
    self.totalTimeLable.font = font;
    self.totalTimeLable.text = @"30:01";
    self.totalTimeLable.st_centerY = self.bottomView.st_height /2;
    self.totalTimeLable.textAlignment = NSTextAlignmentRight;
    [self.bottomView addSubview:self.totalTimeLable];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.duringLable.st_right + 10, 0, self.totalTimeLable.st_left -10 -(self.duringLable.st_right + 10), 30)];
    self.slider.backgroundColor = [UIColor clearColor];
    self.slider.tintColor = [UIColor whiteColor];
    self.slider.thumbTintColor = [UIColor whiteColor];
    self.slider.st_centerX = self.bottomView.st_width / 2;
    [self.slider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    [self.bottomView addSubview:self.slider];
    
    [self addSubview:self.bottomView];
    
    self.cureentToolState = toolbarTypeShowed;
    


}
- (void)autoHideToolView{

    //开始四秒之后隐藏工具栏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.st_top = self.st_height   ;
            self.topView.st_bottom = 0;
        } completion:^(BOOL finished) {
            self.cureentToolState = toolbarTypeDidHide;
        }];
    });
    
    
    //添加手势
    UITapGestureRecognizer  * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonAction:)];
    [self addGestureRecognizer:tapGes];
    
}
#pragma mark --Action Method
- (void)goBackAction{

    if (self.fullScreenButton.selected) {
        [self fullScreenButtonAction:self.fullScreenButton];
    }else{
    
        if (self.backActionHandle) {
            self.backActionHandle();
        }
    }

}
- (void)playButtonAction:(UIButton*)buttton{

    if (self.cureentToolState == toolbarTypeDidHide) {
        
        //下方已经隐藏
        
        self.cureentToolState = toolbarTypeIsBeingIsBeingShow;
        [UIView animateWithDuration:0.25 animations:^{
            if (self.fullScreenButton.selected) {
                self.topView.st_top = 20;
                self.bottomView.st_bottom = self.st_width;
            }else{
                self.topView.st_top = 0;
                self.bottomView.st_bottom = self.st_height   ;
            }
        
        } completion:^(BOOL finished) {
            self.cureentToolState = toolbarTypeShowed;
            //四秒之后隐藏工具栏
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    if (self.fullScreenButton.selected) {
                        self.topView.st_bottom = 0;
                        self.bottomView.st_top = self.st_width   ;
                    }else{
                        self.topView.st_bottom = 0;
                        self.bottomView.st_top = self.st_height   ;
                    }
                        

                } completion:^(BOOL finished) {
                    self.cureentToolState = toolbarTypeDidHide;
                }];
            });
            
        }];
        
        return;
    }
   
        self.playButton.selected = ! self.playButton.selected;
        
        if (self.playButton.selected) {
            if (self.isReadToPlay) {
                //播放的时候加载播放器到视图，普通状态显示背景图
                [self.layer insertSublayer:self.playLayer atIndex:0];
                if (self.shouldHideImageViewWhenReady) {
                    [self.backGroundImageView removeFromSuperview];
                }
                [self.player play];
            }
        }else{
            [self.player pause];
            
        }
    
 
 
    

    
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (void)fullScreenButtonAction:(UIButton*)buttton{
    
    self.fullScreenButton.selected = !self.fullScreenButton.selected;

    if (self.fullScreenButton.selected) {
      //初始 - 全屏
        self.parentView = self.superview;
        CGRect windowFrame  =   [self convertRect:self.bounds toView:self.window];
        self.frame = windowFrame;
        [self removeFromSuperview];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self resetCalculateView];
            self.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.center = [UIApplication sharedApplication].keyWindow.center;
            
          
           
            
        }completion:^(BOOL finished) {
           
        }];
   }else{
       
        //全屏- 初始
       [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
       [UIView animateWithDuration:0.5 animations:^{
            
            self.transform = CGAffineTransformMakeRotation(0 *  M_PI/2);;
            self.frame = self.originFrame;
           [self resetCalculateView];
           
          
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            self.frame = self.originFrame;
            [self.parentView addSubview:self];
        }];
        
    }


    

    
    
   
    


}

- (void)sliderAction{
    //slider的value值为视频的时间
    
    CGFloat  floatseconds = self.slider.value;
    
    //让视频从指定的CMTime对象处播放。
    
    CMTime startTime = CMTimeMakeWithSeconds(floatseconds,self.playerItem.currentTime.timescale);
    
    //让视频从指定处播放
    
    [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
        [STProgressHudTool showProgressHudWithStyle:STProgressHudStyleRonateIndicator];
        if (finished) {
            [STProgressHudTool hideCureentProgressHud];
            if (!self.playButton.isSelected) {
                [self.player play];
            }
        }

    }];


}
//每一秒播放回调
- (void)playerIsBeingPlaying{
    [self calculate];//计算缓冲
    CGFloat currentSecond = _playerItem.currentTime.value/_playerItem.currentTime.timescale;// 计算当前在第几秒
    [self.slider setValue:currentSecond animated:YES];
    NSString *timeString = [self convertTime:currentSecond];
    self.duringLable.text = timeString;
    CGFloat totalSecond = _playerItem.duration.value / _playerItem.duration.timescale;// 转换成秒
    NSString * totalString = [self convertTime:totalSecond];// 转换成播放时间
    self.totalTimeLable.text = totalString;
    
}

#pragma mark --Private Method
- (void)judgeItemStatus:(AVPlayerItemStatus)status{
    switch(status)
    
    {
            
        case AVPlayerItemStatusFailed:
            
            NSLog(@"item 有误");
            
            self.isReadToPlay = NO;
            
            break;
            
        case AVPlayerItemStatusReadyToPlay:
            
            NSLog(@"准好播放了");

            self.isReadToPlay = YES;
            if (self.playButton.isSelected) {
                [self play];
            }
            self.slider.maximumValue = self.playerItem.duration.value/self.playerItem.duration.timescale;
            [self playerIsBeingPlaying];
            
            break;
            
        case AVPlayerItemStatusUnknown:
            
            NSLog(@"视频资源出现未知错误");
            
            self.isReadToPlay = NO;
            
            break;
            
        default:
            
            break;
            
    }
}
-(NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
- (void)calculate{
    //改变slider 部分颜色
    NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
    //NSLog(@"Time Interval:%f",timeInterval);
    
    CMTime duration = self.playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
     NSLog(@"缓冲了百分之:%f",timeInterval / totalDuration);
    //[self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
}
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
//重新计算view的位置
- (void)resetCalculateView{

    self.playLayer.frame = self.bounds;
    // imageview 计算
    if (_backGroundImageView) {
        _backGroundImageView.st_width = self.st_width;
        _backGroundImageView.st_height = self.st_height;
    }
    //顶部计算
    if (self.fullScreenButton.isSelected) {
        self.topView.st_top = 20;//全屏状态
    }else{
        self.topView.st_top = 0;
    }
    
    
    self.topView.st_width = self.st_width;
    
    self.titleLable.st_width = self.st_width - 100 ;
    
    self.titleLable.st_centerX = self.st_width / 2;
    
    //底部计算
    self.bottomView.st_width = self.st_width;
    
    self.bottomView.st_bottom = self.st_height;
    
    self.playButton.st_left = 10;
    
    self.duringLable.st_left = self.playButton.st_right  + 10;
    
    self.fullScreenButton.st_right = self.bottomView.st_width  - 10 ;
    
    self.totalTimeLable.st_right = self.fullScreenButton.st_left - 10;
    
    self.slider.frame = CGRectMake(self.duringLable.st_right + 10, 0, self.totalTimeLable.st_left - 10 - (self.duringLable.st_right + 10), 30);
    
    

}

- (void)pause{
    [self.player pause];
}
- (void)play{
    [self.player play];
}

//-----------------------YYMusic  cache -------------------------------------------
#pragma mark --AVAssetResourceLoaderDelegate
//是否可以请求，此时将请求保存自己处理，
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{

    NSLog(@"视屏多了一个请求");
   
    [self.requestArray addObject:loadingRequest];
    // [loadingRequest finishLoading];
    return YES;
}
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest{
    
    return YES;
}
//某一个请求完成，将结束([loadingRequest finishLoading])这个请求，并且继续发送一个新的请求
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{

    //[self.requestArray removeObject:loadingRequest];
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForResponseToAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge{

    return YES;
}
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge{


}
@end
