//
//  Order.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/25.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "Order.h"

@implementation BizContent

- (NSString *)description
{
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    
    [tmpDict addEntriesFromDictionary:@{@"subject":_subject?:@"",
                                        @"out_trade_no":_out_trade_no?:@"",
                                        @"total_amount":_total_amount?:@"",
                                        @"seller_id":_seller_id?:@"",
                                        @"product_code":_product_code?:@"QUICK_MSECURITY_PAY"}];
    
    if (_body.length > 0)
    {
        [tmpDict setObject:_body forKey:@"body"];
    }
    if (_timeout_express.length > 0)
    {
        [tmpDict setObject:_timeout_express forKey:@"timeout_express"];
    }
    
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:tmpDict options:0 error:nil];
    NSString *tmpStr = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
    return tmpStr;
}

@end

@implementation Order

- (NSString *)orderInfoEncoded:(BOOL)bEncoded
{
    if (_app_id.length <= 0)
    {
        return nil;
    }
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict addEntriesFromDictionary:@{@"app_id":_app_id,
                                         @"method":_method?:@"alipay.trade.app.pay",
                                         @"charset":_charset?:@"utf-8",
                                         @"timestamp":_timestamp?:@"",
                                         @"version":_version?:@"1.0",
                                         @"biz_content":_biz_content.description?:@"",
                                         @"sign_type":_sign_type?:@"RSA"}];
    
    if (_format.length > 0)
    {
        [tempDict setObject:_format forKey:@"format"];
    }
    if (_return_url.length > 0)
    {
        [tempDict setObject:_return_url forKey:@"return_url"];
    }
    if (_notify_url.length > 0)
    {
        [tempDict setObject:_app_auth_token forKey:@"app_auth_token"];
    }
    NSArray* sortedKeyArray = [[tempDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (NSString* key in sortedKeyArray) {
        NSString* orderItem = [self orderItemWithKey:key andValue:[tempDict objectForKey:key] encoded:bEncoded];
        if (orderItem.length > 0) {
            [tmpArray addObject:orderItem];
        }
    }
    return [tmpArray componentsJoinedByString:@"&"];
}

- (NSString*)orderItemWithKey:(NSString*)key andValue:(NSString*)value encoded:(BOOL)bEncoded
{
    if (key.length > 0 && value.length > 0) {
        if (bEncoded) {
            value = [self encodeValue:value];
        }
        return [NSString stringWithFormat:@"%@=%@", key, value];
    }
    return nil;
}

- (NSString*)encodeValue:(NSString*)value
{
    NSString* encodedValue = value;
    if (value.length > 0) {
        encodedValue = (__bridge_transfer  NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    }
    return encodedValue;
}

@end
