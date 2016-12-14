//
//  Order.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/25.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

@interface BizContent : NSObject

@property (nonatomic,copy)NSString *body;

@property (nonatomic,copy)NSString *subject;

@property (nonatomic,copy)NSString *out_trade_no;

@property (nonatomic,copy)NSString *timeout_express;

@property (nonatomic,copy)NSString *total_amount;

@property (nonatomic,copy)NSString *seller_id;

@property (nonatomic,copy)NSString *product_code;

@end

@interface Order : NSObject

@property (nonatomic,copy)NSString *app_id;

@property (nonatomic,copy)NSString *method;

@property (nonatomic,copy)NSString *format;

@property (nonatomic,copy)NSString *return_url;

@property (nonatomic,copy)NSString *charset;

@property (nonatomic,copy)NSString *timestamp;

@property (nonatomic,copy)NSString *version;

@property (nonatomic,copy)NSString *notify_url;

@property (nonatomic,copy)NSString *app_auth_token;

@property (nonatomic,strong)BizContent *biz_content;

@property (nonatomic,copy)NSString *sign_type;

- (NSString *)orderInfoEncoded:(BOOL)bEncoded;

@end
