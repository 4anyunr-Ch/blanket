//
//  STAVResourseLoder.h
//  STNewTools
//
//  Created by stoneobs on 17/6/5.
//  Copyright © 2017年 stoneobs. All rights reserved.
//
//**********************AVAsset 资源代理***************************
/*
 说明：这个loader 是将 AVPlyer 的 自动数据获取截断，通过AVURLAsset的代理 将request 的分片请求range 拿到。然后自己填充request 的数据
 唯一有用的就是代理中分片请求的request，里面包含的range 是AVPlyer处理的，其他数据提供和缓存是由自己处理
 */
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface STAVResourseLoder : NSObject<AVAssetResourceLoaderDelegate>


/**
 将可以播放的url转换成不可播放的url，我们仅仅需要request的range，然后自己请求数据。转换成badurl 的原因是，让AVPlyer无法加载，我们通过请求获取数据，实现一次流量，永久缓存

 @param url 初始url
 @return bad url
 */
+ (NSURL*)streamingUrlFromUrl:(NSURL*)url;

/**
 将bad url 转换成可用url

 @param streamingUrl streamingUrl description
 
 @param isHttps 是否是https 是则头部是https
 @return 可用url
 */
+ (NSURL*)orginUrlFromStreamingUrl:(NSURL*)streamingUrl isHttps:(BOOL)isHttps;
@end
