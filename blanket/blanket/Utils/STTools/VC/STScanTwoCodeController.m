//
//  LVScanTwoCodeController.m
//  lover
//
//  Created by stoneobs on 16/4/8.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STScanTwoCodeController.h"
#import <AVFoundation/AVFoundation.h>
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define BACKROUND_COLOR  STRGB(0xF4F5F0)
@interface STScanTwoCodeController ()<AVCaptureMetadataOutputObjectsDelegate,AVAudioPlayerDelegate>
@property(nonatomic,strong)AVCaptureSession         *session;
@property(nonatomic,strong)AVCaptureDevice          *device;
@property(nonatomic,strong)AVAudioPlayer            *audioPlayer;
@property(nonatomic,strong)UIImageView              *scrollImage;
@property(nonatomic)        BOOL                     isLight;
@property(nonatomic,copy)STScanTwoCodeControllerResult resultBlock;
@end

@implementation STScanTwoCodeController
-(instancetype)initWithHandle:(STScanTwoCodeControllerResult)handle
{
    if (self = [super init]) {
        if (handle) {
            self.resultBlock = handle;
        }
    }
    return  self;
}
//播放器懒加载
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        //扫描完成之后播放这个声音
        NSString *urlStr = [[NSBundle mainBundle]pathForResource:@"shake_match" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops = 0;//设置为0不循环
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}
#pragma mark --生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightTitle:@"开灯"];
    
    UIImageView * scanView = [[UIImageView alloc]init];
    scanView.center = self.view.center;
    scanView.bounds = CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_WIDTH/2);
    scanView.image = [UIImage imageNamed:@"scanscanBg"];
    [self.view addSubview:scanView];
    _scrollImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scanView.frame.size.width, 10)];
    _scrollImage.image = [UIImage imageNamed:@"scanLine"];
    [scanView addSubview:_scrollImage];
    
    [self startAnimation];
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest=CGRectMake((self.view.center.y-SCREEN_WIDTH/4)/SCREEN_HEIGHT, (self.view.center.x-SCREEN_WIDTH/4)/SCREEN_WIDTH, SCREEN_WIDTH/2/SCREEN_HEIGHT, SCREEN_WIDTH/2/SCREEN_WIDTH);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [_session addInput:input];
    }
    if (output) {
        [_session addOutput:output];
    }
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [_session startRunning];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setRightTitle:(NSString*)title;
{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
    right.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = right;

}
- (void)rightBarAction:(id)sender
{
    self.isLight=!self.isLight;
    if (self.isLight) {
        if ([_device hasFlash] && [_device hasTorch]) {
            [_device lockForConfiguration:nil];
            [_device setFlashMode:AVCaptureFlashModeOn];
            [_device setTorchMode:AVCaptureTorchModeOn];
            [_device unlockForConfiguration];
        }
    }
    else{
        if ([_device hasFlash] && [_device hasTorch]) {
            [_device lockForConfiguration:nil];
            [_device setFlashMode:AVCaptureFlashModeOff];
            [_device setTorchMode:AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
        }
    }
    
    
}
//开始动画
- (void)startAnimation
{
    __weak STScanTwoCodeController * weakSelf =self;
    [UIView animateWithDuration:1.5 animations:^{
        CGRect frame = self.scrollImage.frame;
        frame.origin.y = SCREEN_WIDTH/2-10;
        self.scrollImage.frame = frame;
    
    } completion:^(BOOL finished) {
        [weakSelf cicleAnimation];
    }];
}
-(void)cicleAnimation
{
    CGRect frame = self.scrollImage.frame;
    frame.origin.y = 0;
    self.scrollImage.frame = frame;
    
    __weak STScanTwoCodeController * weakSelf =self;
    [UIView animateWithDuration:1.5 animations:^{
        CGRect frame = self.scrollImage.frame;
        frame.origin.y = SCREEN_WIDTH/2-10;
        self.scrollImage.frame = frame;
 
    } completion:^(BOOL finished) {
        [weakSelf startAnimation];
    }];
}
//输出流
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        [self.audioPlayer play];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSString * result =metadataObject.stringValue;
        if (self.resultBlock) {
            self.resultBlock(result);
        }
        
    }
}


@end
