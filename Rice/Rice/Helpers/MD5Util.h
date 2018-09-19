//
//  MD5Util.h
//  QLKit
//
//  Created by Sim on 12-9-3.
//  Copyright (c) 2012年 3gtv.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Util : NSObject
+ (NSString *)MD5:(NSString *)str;
+(NSString*)md5:(NSString *)str;
+(NSString *)md5WithData:(NSData *)data;
+(NSString *)md5_16_String:(NSString *)str;
@end
