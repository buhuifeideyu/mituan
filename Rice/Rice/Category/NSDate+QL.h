//
//  NSDate+QL.h
//  QLKit
//
//  Created by Sim on 13-1-9.
//  Copyright (c) 2013年 3gtv.net. All rights reserved.
//

#import <Foundation/Foundation.h>

enum QL_WEEKDAY_DAY
{
    QL_WEEKDAY_Mo = 1,
    QL_WEEKDAY_Tu = 2,
    QL_WEEKDAY_We = 3,
    QL_WEEKDAY_Th = 4,
    QL_WEEKDAY_Ft = 5,
    QL_WEEKDAY_Sa = 6,
    QL_WEEKDAY_Su = 0
};

@interface NSDate (QL)

+(NSInteger)ql_weekday:(NSDate*)date;
-(BOOL)ql_isLaterDate:(NSDate*)date;
-(BOOL)ql_isEarlyerDate:(NSDate*)date;
-(BOOL)ql_isBetweenDate:(NSDate*)start andDate:(NSDate*)end;
/**
 *  返回属于今周的所有日期
 *
 *  @return
 */
+(NSArray*)ql_getThisWeekAllDates;
/**
 *  字符串转换成NSDate（默认格式：yyyy-MM-dd HH:mm:ss)
 *
 *  @param datestr 日期字符串
 *
 *  @return
 */
+(NSDate*)ql_dateWithString:(NSString *)datestr;
/**
 *  字符串转换成NSDate
 *
 *  @param datestr 日期字符串
 *  @param format  数据源格式，例如：yyyy-MM-dd HH:mm:ss
 *
 *  @return
 */
+(NSDate*)ql_dateWithString:(NSString *)datestr withFormat:(NSString *)format;
/**
 *  转换成字符串(默认格式:yyyy-MM-dd HH:mm:ss)
 *
 *  @return
 */
-(NSString*)ql_ToString;
/**
 *  转换成字符串
 *
 *  @param format 字符串格式
 *
 *  @return
 */
-(NSString*)ql_ToStringWithFormat:(NSString*)format;
/**
 *  日期是否为今天
 *
 *  @return
 */
-(BOOL)ql_isToday;
/**
 *  日期是否为昨天
 *
 *  @return
 */
-(BOOL)ql_isYesterday;

+(NSDate*)dateFromRFC1123:(NSString*)value_;

////东八区当前时间（准确）
//+(NSDate *)dateNowAtGMT8;

/**
 *  把时间转换为某个时区时间，timeZoneName为nil时，默认为东八区
 *
 *  @param timeZoneName timeZoneName为nil时，默认为东八区
 *
 *  @return
 */
-(NSDate *)localeDateToTimeZone:(NSString *)timeZoneName;

/**
 *  NSDate 格式化为 NSString,时区为nil时，默认为东八区
 *
 *  @param timeZoneName 时区为nil时，默认为东八区
 *  @param formatte     转换格式
 *
 *  @return
 */
-(NSString *)stringFromDateWithTimeZone:(NSString *)timeZoneName withFormatte:(NSString *)formatte;

+ (NSString *)stringForDateWithTime:(NSString *)time;

+ (NSString *)stringForDateWithMessageTime:(NSString *)time;

+(NSString *)getMMSSFromSS:(NSString *)totalTime;

+(NSString *)getHHMMSSFromSS:(NSString *)totalTime;
@end
