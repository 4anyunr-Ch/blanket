//
//  STAVResourseNetTask.m
//  STNewTools
//
//  Created by stoneobs on 17/6/5.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "STAVResourseNetTask.h"

@interface STAVResourseNetTask()<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableArray  *taskArr;

@property (nonatomic, strong) NSFileHandle    *fileHandle;
@property (nonatomic, strong) NSString        *tempPath;

@property(nonatomic,strong)NSURLSessionDataTask * task;//下载task

@end
@implementation STAVResourseNetTask

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mimeType = @"video/mp4";//解析格式，
        _taskArr = [NSMutableArray array];
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        _tempPath =  [document stringByAppendingPathComponent:@"temp.mp4"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_tempPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
            [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
            
        } else {
            [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
        }
    }
    return self;
}
#pragma mark --Public Method
- (void)beginNetRequestWithUrl:(NSURL *)url andOffset:(NSUInteger)offset{

    _url = url;
    _offset = offset;
    //如果同时存在两个级以上的请求，那么证明至少在第一次seek（拖动位置）之后没有加载完数据，则这个时候缓存的数据是不连续的，需要将之前的缓存数据移除，重新获取
    if (self.taskArr.count >= 1) {
        [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
    }
    _downLoadingOffset = 0;
    
    NSURLComponents *originURLComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    originURLComponents.scheme = @"http";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[originURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    if (offset > 0 && self.videoLength > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)offset, (unsigned long)self.videoLength - 1] forHTTPHeaderField:@"Range"];
    }
  
    [self.task cancel];//取消之前的task，之前的task要么已经完成，要么就是seek到新位置，还没结束，此时就算缓存回来，数据也不作处理。此时会进入(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    self.task = [session dataTaskWithRequest:request];
    [self.task resume];//开始请求
    
    
}
#pragma mark --NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
  
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    
    NSUInteger videoLength;
    
    if ([length integerValue] == 0) {
        videoLength = (NSUInteger)httpResponse.expectedContentLength;
    } else {
        videoLength = [length integerValue];
    }
    
    _videoLength = videoLength;
    [self.taskArr addObject:dataTask];
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
}

// 接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    [self.fileHandle seekToEndOfFile];//跳转到文件末尾，准备追加数据
    
    [self.fileHandle writeData:data];//写入文件
    
    _downLoadingOffset += data.length;//已经下载的长度
    if ([self.delegate respondsToSelector:@selector(didReceiveVideoDataWithTask:)]) {
        [self.delegate didReceiveVideoDataWithTask:self];
    }
}

// 请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    //移除
    [self.taskArr removeObject:self.task];
}
@end
