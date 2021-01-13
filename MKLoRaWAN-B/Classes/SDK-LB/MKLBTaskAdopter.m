//
//  MKLBTaskAdopter.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKLBTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKLBOperationID.h"

NSString *const mk_lb_communicationDataNum = @"mk_lb_communicationDataNum";

@implementation MKLBTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
        //电池电量
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        return [self dataParserGetDataSuccess:@{@"batteryPower":battery} operationID:mk_lb_taskReadBatteryPowerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_lb_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_lb_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_lb_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_lb_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_lb_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //密码相关
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *state = @"";
        if (content.length == 8) {
            state = [content substringWithRange:NSMakeRange(6, 2)];
        }
        return [self dataParserGetDataSuccess:@{@"state":state} operationID:mk_lb_connectPasswordOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        return [self parseCustomData:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    mk_lb_taskOperationID operationID = mk_lb_defaultTaskOperationID;
    return [self dataParserGetDataSuccess:@{@"result":@(YES)} operationID:operationID];
}

#pragma mark - 数据解析
+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    if (![[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ed"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd {
    mk_lb_taskOperationID operationID = mk_lb_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    if ([cmd isEqualToString:@"01"]) {
        
    }else if ([cmd isEqualToString:@"0d"]) {
        //读取mac地址
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        operationID = mk_lb_taskReadMacAddressOperation;
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
    }else if ([cmd isEqualToString:@"21"]) {
        //读取LoRaWAN频段
        resultDic = @{
            @"region":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
        };
        operationID = mk_lb_taskReadLorawanRegionOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //读取LoRaWAN入网类型
        resultDic = @{
            @"modem":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
        };
        operationID = mk_lb_taskReadLorawanModemOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //读取LoRaWAN class类型
        resultDic = @{
            @"classType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
        };
        operationID = mk_lb_taskReadLorawanClassTypeOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //读取LoRaWAN网络状态
        resultDic = @{
            @"status":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
        };
        operationID = mk_lb_taskReadLorawanNetworkStatusOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //读取LoRaWAN DEVEUI
        resultDic = @{
            @"devEUI":content,
        };
        operationID = mk_lb_taskReadLorawanDEVEUIOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //读取LoRaWAN APPEUI
        resultDic = @{
            @"appEUI":content
        };
        operationID = mk_lb_taskReadLorawanAPPEUIOperation;
    }else if ([cmd isEqualToString:@"27"]) {
        //读取LoRaWAN APPKEY
        resultDic = @{
            @"appKey":content
        };
        operationID = mk_lb_taskReadLorawanAPPKEYOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //读取LoRaWAN DEVADDR
        resultDic = @{
            @"devAddr":content
        };
        operationID = mk_lb_taskReadLorawanDEVADDROperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //读取LoRaWAN APPSKEY
        resultDic = @{
            @"appSkey":content
        };
        operationID = mk_lb_taskReadLorawanAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"2a"]) {
        //读取LoRaWAN nwkSkey
        resultDic = @{
            @"nwkSkey":content
        };
        operationID = mk_lb_taskReadLorawanNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"2b"]) {
        //读取LoRaWAN 上行数据类型
        resultDic = @{
            @"messageType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
        };
        operationID = mk_lb_taskReadLorawanMessageTypeOperation;
    }else if ([cmd isEqualToString:@"2c"]) {
        //读取LoRaWAN CH
        resultDic = @{
            @"CHL":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"CHH":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)]
        };
        operationID = mk_lb_taskReadLorawanCHOperation;
    }else if ([cmd isEqualToString:@"2d"]) {
        //读取LoRaWAN DR
        resultDic = @{
            @"DR":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
        };
        operationID = mk_lb_taskReadLorawanDROperation;
    }else if ([cmd isEqualToString:@"2e"]) {
        //读取LoRaWAN ADR
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, 2)] == 1);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lb_taskReadLorawanADROperation;
    }else if ([cmd isEqualToString:@"2f"]) {
        //读取LoRaWAN 组播开关
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, 2)] == 1);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lb_taskReadLorawanMulticastStatusOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //读取LoRaWAN 组播地址
        resultDic = @{
            @"address":content
        };
        operationID = mk_lb_taskReadLorawanMulticastAddressOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //读取LoRaWAN 组播APPSKEY
        resultDic = @{
            @"appSkey":content
        };
        operationID = mk_lb_taskReadLorawanMulticastAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //读取LoRaWAN 组播NWKSKEY
        resultDic = @{
            @"nwkSkey":content
        };
        operationID = mk_lb_taskReadLorawanMulticastNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //读取LoRaWAN link check检测间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadLorawanLinkcheckIntervalOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //读取LoRaWAN up link dwell time检测间隔
        resultDic = @{
            @"time":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadLorawanUplinkdwelltimeOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //读取LoRaWAN duty cycle
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, 2)] == 1);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lb_taskReadLorawanDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //读取LoRaWAN devtime指令同步间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadLorawanDevTimeSyncIntervalOperation;
    }
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    return @{};
}

#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_lb_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
