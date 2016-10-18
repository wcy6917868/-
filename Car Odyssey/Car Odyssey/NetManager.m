//
//  NetManager.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/8.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "NetManager.h"

@interface NetManager ()
@property (nonatomic,strong)AFHTTPSessionManager *sessionManager;

@end

@implementation NetManager

+ (instancetype)shareManager
{
    static NetManager *netManager = nil;
    if (netManager == nil)
    {
        netManager = [[NetManager alloc]init];
        netManager.sessionManager = [AFHTTPSessionManager manager];
        netManager.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
         netManager.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return netManager;
}

- (void)requestUrlPost:(NSString *)url andParameter:(NSMutableDictionary *)ParameterDic withSuccessBlock:(SuccessBlock)successB andFailedBlock:(FailedBlock)failedB
{
    [self.sessionManager POST:url parameters:ParameterDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successB([NSJSONSerialization JSONObjectWithData: responseObject options:NSJSONReadingAllowFragments error:nil]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedB(error);
        
    }];
}

- (void)requestUrlGet:(NSString *)url withSuccessBlock:(SuccessBlock)successB andFailedBlock:(FailedBlock)failedB
{
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        successB([NSJSONSerialization JSONObjectWithData: responseObject options:NSJSONReadingAllowFragments error:nil]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         failedB(error);
    }];
}

- (void)requestUrlPostImage:(NSString *)url andParameter:(NSMutableDictionary *)ParameterDic withImageData:(NSData *)imageData  withSuccessBlock:(SuccessBlock)successB andFailedBlock:(FailedBlock)failedB
{
    [self.sessionManager POST:url parameters:ParameterDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        [formData appendPartWithFileData:imageData name:@"binary" fileName:@"image.png" mimeType:@"image/png"];
    }
    progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        successB([NSJSONSerialization JSONObjectWithData: responseObject options:NSJSONReadingAllowFragments error:nil]);
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         failedB(error);
    }];
}


@end
