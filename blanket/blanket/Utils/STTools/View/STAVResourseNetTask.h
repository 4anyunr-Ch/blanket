//
//  STAVResourseNetTask.h
//  STNewTools
//
//  Created by stoneobs on 17/6/5.
//  Copyright © 2017年 stoneobs. All rights reserved.
//
//**********************网络获取数据，提供给STAVResourseLoder***************************
/*
 目前的逻辑：AVPlyer seturl 的时候，开始通过AVURlAsset 获取数据，（并不是play的时候），此时，我们通过STAVResourseNetTask 给AVURlAsset数据。AVPlyer seturl 的时候 会重复调用- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest 我们处理的时候，都只处理最后一条，每次之前的请求会被cancle，并且range 是0 至视屏的最大值。
 一旦用户range，则不考虑任何情况，缓存失败。只有没有seek 操作，才会顺利保存，这是目前ios音视频处理的通用方法。
 后续优化：
 关于用户多次seek，如果时间多，可以考虑每次请求成功之后，保存range的临时文件，到最后通过判断range 是否连续，连续，则取出临时文件A 的0-800 B的800 - 1000.假如c 是600 —— 1200，此时取1000- 1200，以此类推，将多个文件合并成一个。
 增加优化缓存策略，如果剩余文件在1m内，则自动下载，将其缓存。
 */
#import <Foundation/Foundation.h>
@class STAVResourseNetTask;
@protocol STAVResourseNetTaskDelegate <NSObject>
- (void)task:(STAVResourseNetTask *)task didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType;
- (void)didReceiveVideoDataWithTask:(STAVResourseNetTask *)task;
- (void)didFinishLoadingWithTask:(STAVResourseNetTask *)task;
- (void)didFailLoadingWithTask:(STAVResourseNetTask *)task WithError:(NSInteger )errorCode;
@end

@interface STAVResourseNetTask : NSObject
@property (nonatomic, strong, readonly) NSURL                      *url;

@property (nonatomic, readonly        ) NSUInteger                 offset;//当前起始位置

@property (nonatomic, readonly        ) NSUInteger                 videoLength;//资源data长度

@property (nonatomic, readonly        ) NSUInteger                 downLoadingOffset;//已经下载了多少
//http://tool.oschina.net/commons/ 常见 	Content-Type
@property (nonatomic, strong, readonly) NSString                   * mimeType;//可以接受的资源类型


@property (nonatomic, assign)           BOOL                       isFinishLoad;

@property(nonatomic,weak)id<STAVResourseNetTaskDelegate>           delegate;


- (void)beginNetRequestWithUrl:(NSURL*)url andOffset:(NSUInteger)offset;

- (void)cancleNetRequest;

- (void)continueNetRequest;

- (void)clearData;//加载失败，清除缓存
@end
