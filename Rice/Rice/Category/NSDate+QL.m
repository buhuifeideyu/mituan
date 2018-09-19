//
//  NSDate+QL.m
//  QLKit
//
//  Created by Sim on 13-1-9.
//  Copyright (c) 2013年 3gtv.net. All rights reserved.
//

#import "NSDate+QL.h"

@implementation NSDate (QL)


// 取值范围0 ~ 6 对应 (周日 ~ 周六)
+(NSInteger)ql_weekday:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    NSUInteger unitFlags = NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday] - 1;
    return week;
}

+(NSArray*)ql_getThisWeekAllDates
{
    NSMutableArray *days = [NSMutableArray array];
    NSDate *dateNow = [NSDate date];
    NSInteger weekdayToday = [NSDate ql_weekday:dateNow];
    NSInteger dayEarlerCount = weekdayToday ;//前面还有dayEarlerCount天
    NSDate *_tmpDate;
    
    int secOfDay = 24 *60 *60;
    NSDate *_sundayThisWeek = [NSDate dateWithTimeIntervalSinceNow:(-dayEarlerCount * secOfDay)];
    for(int _idx = 0;_idx <7;++_idx){
        _tmpDate = [_sundayThisWeek dateByAddingTimeInterval:_idx * secOfDay];
        [days addObject:_tmpDate];
    }
    return days;
}

-(BOOL)ql_isLaterDate:(NSDate*)date
{
    NSTimeInterval _t1 = [self timeIntervalSince1970];
    NSTimeInterval _t2 = [date timeIntervalSince1970];
    return (_t1 >=_t2);
}

-(BOOL)ql_isEarlyerDate:(NSDate*)date
{
    NSTimeInterval _t1 = [self timeIntervalSince1970];
    NSTimeInterval _t2 = [date timeIntervalSince1970];
    return (_t1 <_t2);
}

-(BOOL)ql_isBetweenDate:(NSDate*)start andDate:(NSDate*)end
{
    NSTimeInterval _t = [self timeIntervalSince1970];
    NSTimeInterval _ts = [start timeIntervalSince1970];
    NSTimeInterval _te = [end timeIntervalSince1970];
    return (_ts < _t && _t <_te);
}

+(NSDate*)ql_dateWithString:(NSString *)datestr
{
    if (datestr == nil) {
        return nil;
    }
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    NSDate *_tmpDate = [_formatter dateFromString:datestr];
    if (!_tmpDate) {
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _tmpDate = [_formatter dateFromString:datestr];
    }
    return _tmpDate;
}

+(NSDate*)ql_dateWithString:(NSString *)datestr withFormat:(NSString *)format
{
    if (datestr == nil) {
        return nil;
    }
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:format];
    NSDate *_tmpDate = [_formatter dateFromString:datestr];
    return _tmpDate;
}

-(NSString*)ql_ToString
{
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *_tmpstr = [_formatter stringFromDate:self];
    return _tmpstr;
}

-(NSString*)ql_ToStringWithFormat:(NSString*)format
{
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:format];
    NSString *_tmpstr = [_formatter stringFromDate:self];
    return _tmpstr;
}

-(BOOL)ql_isToday
{
    BOOL isToday = NO;
    NSString *strThisDate = [self ql_ToStringWithFormat:@"yyyy-MM-dd"];
    NSString *strToday = [[NSDate date] ql_ToStringWithFormat:@"yyyy-MM-dd"];
    isToday = [strThisDate isEqualToString:strToday];
    return isToday;
}

-(BOOL)ql_isYesterday
{
    BOOL isYesterday = NO;

    NSTimeInterval oldtime = [self timeIntervalSince1970];
    NSDate *olddate = [NSDate dateWithTimeIntervalSince1970:oldtime];
    NSString *oldDay = [olddate ql_ToStringWithFormat:@"dd"];
    
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    NSDate *nowdate = [NSDate dateWithTimeIntervalSince1970:nowtime];
    NSString *toDay = [nowdate ql_ToStringWithFormat:@"dd"];
    
    int days = toDay.intValue - oldDay.intValue;
    if (days>0 && days<2 ) {
        isYesterday = YES;
    }
    
    
    return isYesterday;
}


+(NSDate*)dateFromRFC1123:(NSString*)value_
{
    if(value_ == nil)
        return nil;
    static NSDateFormatter *rfc1123 = nil;
    if(rfc1123 == nil)
    {
        rfc1123 = [[NSDateFormatter alloc] init];
        rfc1123.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    }
    NSDate *ret = [rfc1123 dateFromString:value_];
    if(ret != nil)
        return ret;
    
    static NSDateFormatter *rfc850 = nil;
    if(rfc850 == nil)
    {
        rfc850 = [[NSDateFormatter alloc] init];
        rfc850.locale = rfc1123.locale;
        rfc850.timeZone = rfc1123.timeZone;
        rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
    }
    ret = [rfc850 dateFromString:value_];
    if(ret != nil)
        return ret;
    
    static NSDateFormatter *asctime = nil;
    if(asctime == nil)
    {
        asctime = [[NSDateFormatter alloc] init];
        asctime.locale = rfc1123.locale;
        asctime.timeZone = rfc1123.timeZone;
        asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    }
    return [asctime dateFromString:value_];
}

//+(NSDate *)dateNowAtGMT8
//{
//    NSDate *_dtnow = [[QLHTTPRequestManager shareInstance] createRemoteDateNow];
//    NSDateFormatter *_dtformatter = [[NSDateFormatter alloc] init];
//    _dtformatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    _dtformatter.dateStyle = NSDateFormatterFullStyle;
//    _dtformatter.timeStyle = NSDateFormatterFullStyle;
//    NSString *_dtstr = [_dtformatter stringFromDate:_dtnow];
//    NSDate *_formattedDate = [_dtformatter dateFromString:_dtstr];
//    [_dtformatter release];
//    return _formattedDate;
//}

-(NSDate *)localeDateToTimeZone:(NSString *)timeZoneName
{
    if (!timeZoneName) {
        timeZoneName = @"Asia/Shanghai";
    }
    NSDateFormatter *_dtformatter = [[NSDateFormatter alloc] init];
    _dtformatter.timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    _dtformatter.dateStyle = NSDateFormatterFullStyle;
    _dtformatter.timeStyle = NSDateFormatterFullStyle;
    NSString *_strDt = [_dtformatter stringFromDate:self];
    NSDate *_newDt = [_dtformatter dateFromString:_strDt];
    return _newDt;
}

-(NSString *)stringFromDateWithTimeZone:(NSString *)timeZoneName withFormatte:(NSString *)formatte
{
    if (!timeZoneName) {
        timeZoneName = @"Asia/Shanghai";
    }
    if (!formatte) {
        formatte = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *_dtformatter = [[NSDateFormatter alloc] init];
    _dtformatter.timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    _dtformatter.dateStyle = NSDateFormatterFullStyle;
    _dtformatter.timeStyle = NSDateFormatterFullStyle;
    _dtformatter.dateFormat = formatte;
    NSString *_strDt = [_dtformatter stringFromDate:self];
    return _strDt;
}

+ (NSString *)stringForDateWithTime:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:time];
    
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter1 setDateFormat:@"YYYY-MM-dd"];
    
    NSString * comfromTimeStr = [formatter1 stringFromDate:date];
    return  comfromTimeStr;
}

+ (NSString *)stringForDateWithMessageTime:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:time];
    
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSString * comfromTimeStr = [formatter1 stringFromDate:date];
    return  comfromTimeStr;
}

+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
}

+(NSString *)getHHMMSSFromSS:(NSString *)totalTime {
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}



@end
