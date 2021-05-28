//
//  TBVideoRequestTask.m
//  avplayerSavebufferData
//
//  Created by qianjianeng on 15/9/18.
//  Copyright (c) 2015年 qianjianeng. All rights reserved.
//
//// github地址：https://github.com/suifengqjn/TBPlayer

#import "TBVideoRequestTask.h"

@interface TBVideoRequestTask () <NSURLSessionDataDelegate, AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) NSURL           *url;
@property (nonatomic        ) NSUInteger      offset;

@property (nonatomic        ) NSUInteger      videoLength;
@property (nonatomic, strong) NSString        *mimeType;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableArray  *taskArr;

@property (nonatomic, assign) NSUInteger      downLoadingOffset;
@property (nonatomic, assign) BOOL            once;

@property (nonatomic, strong) NSFileHandle    *fileHandle;
@property (nonatomic, strong) NSString        *tempPath;
@property(nonatomic,strong)NSURLSessionDataTask * task;//下载task
@end

@implementation TBVideoRequestTask

- (instancetype)init
{
    self = [super init];
    if (self) {
          NSLog(@"沙盒 -- %@",NSHomeDirectory());
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

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset
{
    _url = url;
    _offset = offset;
    
    //如果建立第二次请求，先移除原来文件，再创建新的
    if (self.taskArr.count >= 1) {
        [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
    }
    
    _downLoadingOffset = 0;
    
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    if (offset > 0 && self.videoLength > 0) {
        unsigned long num = (unsigned long)self.videoLength - 1;
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)offset,num ] forHTTPHeaderField:@"Range"];
    }

    [self.task cancel];//取消之前的task，之前的task要么已经完成，要么就是seek到新位置，还没结束，此时就算缓存回来，数据也不作处理。此时会进入(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    self.task = [session dataTaskWithRequest:request];
    [self.task resume];//开始请求
       
}



- (void)cancel
{
    [self.connection cancel];
    
}

#pragma mark --NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    
    _isFinishLoad = NO;
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
    
    self.videoLength = videoLength;
    self.mimeType = @"video/mp4";
    
    
    if ([self.delegate respondsToSelector:@selector(task:didReceiveVideoLength:mimeType:)]) {
        [self.delegate task:self didReceiveVideoLength:self.videoLength mimeType:self.mimeType];
    }
    
    [self.taskArr addObject:dataTask];
    
    
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
}

// 接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    [self.fileHandle seekToEndOfFile];//跳转到文件末尾，准备追加数据
    
    [self.fileHandle writeData:data];//写入文件
    NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.tempPath] options:NSDataReadingMappedIfSafe error:nil];
    _downLoadingOffset += data.length;//已经下载的长度
    if ([self.delegate respondsToSelector:@selector(didReceiveVideoDataWithTask:) ]&& filedata.length > 2) {
        [self.delegate didReceiveVideoDataWithTask:self];
    }
}

// 请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    //移除
    if (!error) {
        if (self.taskArr.count < 2) {
            _isFinishLoad = YES;
            
            //这里自己写需要保存数据的路径
            NSLog(@"沙盒 -- %@",NSHomeDirectory());
            NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *movePath =  [document stringByAppendingPathComponent:@"保存数据.mp4"];
            
            BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:_tempPath toPath:movePath error:nil];
            if (isSuccess) {
                NSLog(@"rename success");
            }else{
                NSLog(@"rename fail");
            }
            NSLog(@"----%@", movePath);
        }
        
        if ([self.delegate respondsToSelector:@selector(didFinishLoadingWithTask:)]) {
            [self.delegate didFinishLoadingWithTask:self];
        }
    }else{
        //错误
    }
}

#pragma mark -  NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _isFinishLoad = NO;
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
    
    self.videoLength = videoLength;
    self.mimeType = @"video/mp4";
    

    if ([self.delegate respondsToSelector:@selector(task:didReceiveVideoLength:mimeType:)]) {
        [self.delegate task:self didReceiveVideoLength:self.videoLength mimeType:self.mimeType];
    }
    
    [self.taskArr addObject:connection];
    
    
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
    
   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [self.fileHandle seekToEndOfFile];
    
    [self.fileHandle writeData:data];

    _downLoadingOffset += data.length;
    
    
    if ([self.delegate respondsToSelector:@selector(didReceiveVideoDataWithTask:)]) {
        [self.delegate didReceiveVideoDataWithTask:self];
    }
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    if (self.taskArr.count < 2) {
        _isFinishLoad = YES;
        
        //这里自己写需要保存数据的路径
        NSLog(@"沙盒 -- %@",NSHomeDirectory());
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *movePath =  [document stringByAppendingPathComponent:@"保存数据.mp4"];

        BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:_tempPath toPath:movePath error:nil];
        if (isSuccess) {
            NSLog(@"rename success");
        }else{
            NSLog(@"rename fail");
        }
        NSLog(@"----%@", movePath);
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishLoadingWithTask:)]) {
        [self.delegate didFinishLoadingWithTask:self];
    }
    
}

//网络中断：-1005
//无网络连接：-1009
//请求超时：-1001
//服务器内部错误：-1004
//找不到服务器：-1003
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error.code == -1001 && !_once) {      //网络超时，重连一次
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self continueLoading];
        });
    }
    if ([self.delegate respondsToSelector:@selector(didFailLoadingWithTask:WithError:)]) {
        [self.delegate didFailLoadingWithTask:self WithError:error.code];
    }
    if (error.code == -1009) {
        NSLog(@"无网络连接");
    }
}


- (void)continueLoading
{
    _once = YES;
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:_url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)_downLoadingOffset, (unsigned long)self.videoLength - 1] forHTTPHeaderField:@"Range"];
    
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    self.task = [session dataTaskWithRequest:request];
    [self.task resume];//开始请求
}

- (void)clearData
{
    [self.connection cancel];
    //移除文件
    [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
    
    
    
}
@end
