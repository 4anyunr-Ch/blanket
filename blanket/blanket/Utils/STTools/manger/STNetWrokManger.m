//
//  STNetWrokManger.m
//  GodHorses
//
//  Created by Mac on 2017/11/14.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STNetWrokManger.h"

@implementation STNetWrokManger
{
    AFHTTPSessionManager *_manager;
    NSMutableDictionary *_requestTaskPool;
}
static const double kAFTimeoutInterval = 15;
static STNetWrokManger *instance = nil;

- (id)init
{
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = kAFTimeoutInterval;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    }
    return self;
}
#pragma mark - Public Method
+ (STNetWrokManger *)defaultClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestWithPath:(NSString *)url
                 method:(STHttpRequestType)method
             parameters:(id)parameters
                success:(STSuccessBlock)success
                failure:(STFailureBlock)failure
{
    NSString * newUrl = url;
    newUrl = [newUrl stringByReplacingOccurrencesOfString:@"test" withString:@"www"];
    if (method == STHttpRequestTypePost) {
        [_manager POST:newUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"ret"]];
            if ([retCode isEqualToString:@"200"]) {
                if (success) {
                    success(task,responseObject);
                }
            } else {
                if (failure) {
                    STError * sterror = [STError new];
                    sterror.desc = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"msg"]];
                    failure(0,sterror);
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.localizedDescription;
                failure(0,sterror);
            }
        }];
    }else if (method == STHttpRequestTypeGet) {
        [_manager GET:newUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"ret"]];
            if ([retCode isEqualToString:@"200"]) {
                if (success) {
                    success(task,responseObject);
                }
            } else {
                if (failure) {
                    STError * sterror = [STError new];
                    sterror.desc = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"msg"]];
                    failure(0,sterror);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.localizedDescription;
                failure(0,sterror);
            }
        }];
    }
}
//有返回值的请求
- (NSURLSessionDataTask *)taskRequestWithPath:(NSString *)url
                                       method:(STHttpRequestType)method
                                   parameters:(id)parameters
                                      success:(STSuccessBlock)success
                                      failure:(STFailureBlock)failure
{
    url = [url stringByReplacingOccurrencesOfString:@"test" withString:@"www"];
    if (method == STHttpRequestTypePost) {
        return  [_manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"ret"]];
            if ([retCode isEqualToString:@"200"]) {
                success(task,responseObject);
            }else {
                if (failure) {
                    STError * sterror =  [STError new];
                    sterror.desc = [responseObject valueForKey:@"msg"];
                    failure(0,sterror);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.localizedDescription;
                failure(0,sterror);
            }
        }];
    }else if (method == STHttpRequestTypeGet) {
        return    [_manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"ret"]];
            if ([retCode isEqualToString:@"200"]) {
                success(task,responseObject);
            }else {
                if (failure) {
                    STError * sterror =  [STError new];
                    sterror.desc = [responseObject valueForKey:@"msg"];
                    failure(0,sterror);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = error.localizedDescription;
                failure(0,sterror);
            }
        }];
    }
    return nil;
}
//下载文件
- (NSURLSessionDownloadTask *)downLoadWithUrl:(NSString *)url
                                     progress:(STProgressBlock)progress
                                      success:(STCompletionHandlerBlock)CompletionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    NSURLSessionDownloadTask *download =  [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createDir = [NSString stringWithFormat:@"%@/ZuoBiao/Files", pathDocuments];
        
        // 判断文件夹是否存在，如果不存在，则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:createDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            NSLog(@"FileDir is exists.");
        }
        NSString *path = [createDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (CompletionHandler) {
            CompletionHandler(response, filePath, error);
        }
        
    }];
    return download;
}
- (void)imageRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                       image:(UIImage*)image
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure
{
    
    url = [url stringByReplacingOccurrencesOfString:@"test" withString:@"www"];
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        long long time = [[NSDate date] timeIntervalSince1970]* 1000;
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"head_img" fileName:[NSString stringWithFormat:@"%lld.png",time] mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"ret"]];
        if ([retCode isEqualToString:@"200"]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:@"msg"];
                failure(0,sterror);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.localizedDescription;
            failure(0,sterror);
        }
    }];
    
}
//附带imageName 参数
- (void)imageRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                       image:(UIImage*)image
                   imageName:(NSString*)imageName
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure{
    url = [url stringByReplacingOccurrencesOfString:@"test" withString:@"www"];
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        long long time = [[NSDate date] timeIntervalSince1970]* 1000;
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:imageName fileName:[NSString stringWithFormat:@"%lld.png",time] mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"ret"]];
        if ([retCode isEqualToString:@"200"]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:@"msg"];
                failure(0,sterror);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.localizedDescription;
            failure(0,sterror);
        }
    }];
    
}
- (void)imageRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                      images:(NSArray*)imageArray
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure
{
    url = [url stringByReplacingOccurrencesOfString:@"test" withString:@"www"];
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        long long time = [[NSDate date] timeIntervalSince1970]* 1000;
        for (NSInteger i=1; i<=imageArray.count;i++ ) {
            UIImage * ima =imageArray[i-1];
            
            NSData * data =UIImageJPEGRepresentation(ima, 0.5);
            [formData appendPartWithFileData:data name:@"images" fileName:[NSString stringWithFormat:@"%lld-%ld.png",time,i] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"code"]];
        if ([retCode isEqualToString:@"200"]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:@"msg"];
                failure(0,sterror);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.localizedDescription;
            failure(0,sterror);
        }
    }];
}
//iamge参数
- (void)imageRequestWithPath:(NSString *)url
                  parameters:(id)parameters
                      images:(NSArray*)imageArray
                   imageName:(NSString*)imageName
                    progress:(STProgressBlock)progress
                     success:(STSuccessBlock)success
                     failure:(STFailureBlock)failure{
    url = [url stringByReplacingOccurrencesOfString:@"test" withString:@"www"];
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        long long time = [[NSDate date] timeIntervalSince1970]* 1000;
        for (NSInteger i=1; i<=imageArray.count;i++ ) {
            UIImage * ima =imageArray[i-1];
            
            NSData * data =UIImageJPEGRepresentation(ima, 0.5);
            [formData appendPartWithFileData:data name:imageName fileName:[NSString stringWithFormat:@"%lld-%ld.png",time,i] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"code"]];
        if ([retCode isEqualToString:@"200"]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:@"msg"];
                failure(0,sterror);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.localizedDescription;
            failure(0,sterror);
        }
    }];
}
- (void)uploadFileWithUrl:(NSString *)url
                 filePath:(NSString *)filePath
               parameters:(id)parameters
                 progress:(STProgressBlock)progress
                  success:(STSuccessBlock)success
                  failure:(STFailureBlock)failure
{
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"ret"]];
        if ([retCode isEqualToString:@"200"]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:@"msg"];
                failure(0,sterror);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.localizedDescription;
            failure(0,sterror);
        }
    }];
}
- (NSURLSessionDataTask *)sessionUploadFileWithUrl:(NSString *)url
                                          filePath:(NSString *)filePath
                                        parameters:(id)parameters
                                          progress:(STProgressBlock)progress
                                           success:(STSuccessBlock)success
                                           failure:(STFailureBlock)failure{
    
    return     [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *retCode = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"ret"]];
        if ([retCode isEqualToString:@"200"]) {
            success(task,responseObject);
        }else {
            if (failure) {
                STError * sterror =  [STError new];
                sterror.desc = [responseObject valueForKey:@"msg"];
                failure(0,sterror);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            STError * sterror =  [STError new];
            sterror.desc = error.localizedDescription;
            failure(0,sterror);
        }
    }];
}

@end
