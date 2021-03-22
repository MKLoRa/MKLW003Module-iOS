//
//  MKLBSynDataParser.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBSynDataParser.h"

#import "MKBLEBaseSDKAdopter.h"

@implementation MKLBSynDataParser

+ (NSArray *)parseScannerTrackedData:(NSString *)content {
    content = [content substringFromIndex:10];
    
    NSInteger index = 0;
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i < content.length; i ++) {
        if (index >= content.length) {
            break;
        }
        NSInteger subLen = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(index, 2)];
        index += 2;
        if (content.length < (index + subLen * 2 + 1)) {
            break;
        }
        NSString *subContent = [content substringWithRange:NSMakeRange(index, subLen * 2)];
        NSDictionary *dateDic = [self parseDateString:[subContent substringWithRange:NSMakeRange(0, 14)]];
        NSString *tempMac = [[subContent substringWithRange:NSMakeRange(14, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
                                [tempMac substringWithRange:NSMakeRange(10, 2)],
                                [tempMac substringWithRange:NSMakeRange(8, 2)],
                                [tempMac substringWithRange:NSMakeRange(6, 2)],
                                [tempMac substringWithRange:NSMakeRange(4, 2)],
                                [tempMac substringWithRange:NSMakeRange(2, 2)],
                                [tempMac substringWithRange:NSMakeRange(0, 2)]];
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:[subContent substringWithRange:NSMakeRange(26, 2)]];
        NSString *rawData = [subContent substringFromIndex:28];
        index += subLen * 2;
        NSDictionary *dic = @{
            @"dateDic":dateDic,
            @"macAddress":macAddress,
            @"rssi":rssi,
            @"rawData":rawData,
        };
        [dataList addObject:dic];
    }
    return dataList;
}

+ (NSDictionary *)parseDateString:(NSString *)date {
    NSString *year = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(0, 4)];
    NSString *month = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(4, 2)];
    if (month.length == 1) {
        month = [@"0" stringByAppendingString:month];
    }
    NSString *day = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(6, 2)];
    if (day.length == 1) {
        day = [@"0" stringByAppendingString:day];
    }
    NSString *hour = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(8, 2)];
    if (hour.length == 1) {
        hour = [@"0" stringByAppendingString:hour];
    }
    NSString *min = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(10, 2)];
    if (min.length == 1) {
        min = [@"0" stringByAppendingString:min];
    }
    NSString *second = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(12, 2)];
    if (second.length == 1) {
        second = [@"0" stringByAppendingString:second];
    }
    return @{
        @"year":year,
        @"month":month,
        @"day":day,
        @"hour":hour,
        @"minute":min,
        @"second":second,
    };
}

@end
