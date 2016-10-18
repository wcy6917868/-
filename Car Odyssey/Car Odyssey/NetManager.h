//
//  NetManager.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/8.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^SuccessBlock)(id data);
typedef void (^FailedBlock)(NSError *error);

@interface NetManager : NSObject

+ (instancetype)shareManager;

- (void)requestUrlPost:(NSString *)url andParameter:(NSMutableDictionary *)ParameterDic withSuccessBlock:(SuccessBlock)successB andFailedBlock:(FailedBlock)failedB;

- (void)requestUrlGet:(NSString *)url withSuccessBlock:(SuccessBlock)successB andFailedBlock:(FailedBlock)failedB;

- (void)requestUrlPostImage:(NSString *)url andParameter:(NSMutableDictionary *)ParameterDic withImageData:(NSData *)imageData  withSuccessBlock:(SuccessBlock)successB andFailedBlock:(FailedBlock)failedB;

@end
