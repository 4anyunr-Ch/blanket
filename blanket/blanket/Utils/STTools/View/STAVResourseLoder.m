//
//  STAVResourseLoder.m
//  STNewTools
//
//  Created by stoneobs on 17/6/5.
//  Copyright © 2017年 stoneobs. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "STAVResourseLoder.h"
#import <AVFoundation/AVFoundation.h>
#import "STAVResourseNetTask.h"
@interface STAVResourseLoder()<STAVResourseNetTaskDelegate>

@property(nonatomic,strong)NSMutableArray            *requestArray;

@property(nonatomic,strong)STAVResourseNetTask            *netTask;//网络数据获取器

@end
@implementation STAVResourseLoder

- (NSMutableArray *)requestArray{
    if (!_requestArray) {
        _requestArray = [NSMutableArray new];
    }
    return _requestArray;
}
+ (NSURL *)streamingUrlFromUrl:(NSURL *)url{
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return   [components URL];

}
+ (NSURL *)orginUrlFromStreamingUrl:(NSURL *)streamingUrl isHttps:(BOOL)isHttps{

    NSURLComponents *components = [NSURLComponents componentsWithURL:streamingUrl resolvingAgainstBaseURL:NO];
    components.scheme = isHttps?@"https":@"http";
    return   [components URL];

}
#pragma mark --AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    /*这里会发送多次分段请求，如果一个请求成功或者失败，那么就会有新的分段请求开始，直到数据全部获取，[loadingRequest finishLoading];
     第一个分段请求，只有两个字节
    */
    [self.requestArray addObject:loadingRequest];
    [self analyzeTheLoadingRequest:loadingRequest];
    return YES;
}
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    [self.requestArray removeObject:loadingRequest];
    NSLog(@"完成了一个分段请求\n");

}
#pragma mark --STAVResourseNetTaskDelegate
- (void)didReceiveVideoDataWithTask:(STAVResourseNetTask *)task{
    [self fillDataInTheRequestArray];
}
#pragma mark --Private Method
//分析loadingRequest，
- (void)analyzeTheLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{

    //TO DO 这里会多次进入，setrul 的时候，会有几个分段请求，
    if (self.netTask.downLoadingOffset > 0) {
        //必然请求开始，那么就会有数据，处理数据
        [self fillDataInTheRequestArray];
    }
    NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.currentOffset, NSUIntegerMax);
    if (!self.netTask) {
        self.netTask = [[STAVResourseNetTask alloc] init];
        self.netTask.delegate = self;
        [self.netTask beginNetRequestWithUrl:[loadingRequest.request URL] andOffset:0];
    }else{
        //判断是否seek操作，有就重新设置range
        //是否往回seek
        BOOL isBackSeek = range.location < self.netTask.offset;
        //是否往前seek
        BOOL isFutureSeek = self.netTask.offset + self.netTask.downLoadingOffset < range.location;
        if (isBackSeek || isFutureSeek) {
            //只要seek 操作，就重新请求
             [self.netTask beginNetRequestWithUrl:[loadingRequest.request URL] andOffset:range.location];
        }
    }
    
   
}
//循环便利requestArray，填充数据
- (void)fillDataInTheRequestArray{

    NSMutableArray * array = [NSMutableArray arrayWithArray:self.requestArray];// 防止还在进行遍历操作，对requestArray进行增删，报错
    
    for (AVAssetResourceLoadingRequest * loadingRequest in array) {
        [self fillTheContentInfoWithContentRequest:loadingRequest.contentInformationRequest];
        //To Do 如果数据填充成功，则移除loadingRequest
        BOOL isFillFinshed  = [self isFinshedFromRequest:loadingRequest.dataRequest];
        if (isFillFinshed) {
            [loadingRequest finishLoading];
            [self.requestArray removeObject:loadingRequest];
        }
    }

}
- (BOOL)isFinshedFromRequest:(AVAssetResourceLoadingDataRequest*)dataRequest{

//    long long startOffset = dataRequest.requestedOffset;//开始位置
//    
//    long long nowOffset = dataRequest.currentOffset;//现在位置
//    
//    long long length = dataRequest.requestedLength;
//    
//
//    
//    //如果下载的startOffset - length  区间 在 已经下载区间范围之内，则这个请求数据已经完整
//    //左区间
//    BOOL isLeftOffsetFinsh = self.netTask.offset <= startOffset;
//    //右区间
//    BOOL isRightOffsetFinsh = (self.netTask.offset+self.netTask.downLoadingOffset) >= nowOffset;
//    if (isLeftOffsetFinsh && isRightOffsetFinsh) {
//        //数据下载完毕 To Do
//        //和STAVResourseNetTask 的地址一致
//        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//        NSString * videoPath = [document stringByAppendingPathComponent:@"temp.mp4"];
//        //获取文件数据
//        NSData * data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoPath]];
//        
//        //请求必然是从0开始，所以，只需要知道这次请求长度，
//        [dataRequest respondWithData:[data subdataWithRange:NSMakeRange(0,nowOffset - startOffset)]];
//      
//        
//        return YES;
//    }
//    
//    return NO;
    long long startOffset = dataRequest.requestedOffset;
    
    if (dataRequest.currentOffset != 0) {
        startOffset = dataRequest.currentOffset;
    }
    
    if ((self.netTask.offset +self.netTask.downLoadingOffset) < startOffset)
    {
        //NSLog(@"NO DATA FOR REQUEST");
        return NO;
    }
    
    if (startOffset < self.netTask.offset) {
        return NO;
    }
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString * videoPath = [document stringByAppendingPathComponent:@"temp.mp4"];
    NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoPath] options:NSDataReadingMappedIfSafe error:nil];
    
    // This is the total data we have from startOffset to whatever has been downloaded so far
    NSUInteger unreadBytes = self.netTask.downLoadingOffset - ((NSInteger)startOffset - self.netTask.offset);
    
    // Respond with whatever is available if we can't satisfy the request fully yet
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    
    NSRange dataRange = NSMakeRange((NSUInteger)startOffset- self.netTask.offset, (NSUInteger)numberOfBytesToRespondWith);
    if (dataRange.length > filedata.length) {
        return NO;
    }
    [dataRequest respondWithData:[filedata subdataWithRange:dataRange]];
    
    
    
    long long endOffset = startOffset + dataRequest.requestedLength;
    BOOL didRespondFully = (self.netTask.offset + self.netTask.downLoadingOffset) >= endOffset;
    
    return didRespondFully;
}
//填充请求的文件信息
- (void)fillTheContentInfoWithContentRequest:(AVAssetResourceLoadingContentInformationRequest*)contentRequest{

    //赋予资源信息
    NSString *mimeType = self.netTask.mimeType;
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
    contentRequest.byteRangeAccessSupported = YES;
    contentRequest.contentType = CFBridgingRelease(contentType);
    contentRequest.contentLength = self.netTask.videoLength;

}
@end
