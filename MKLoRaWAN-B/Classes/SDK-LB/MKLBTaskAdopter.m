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
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data{
    mk_lb_taskOperationID operationID = mk_lb_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    if ([cmd isEqualToString:@"02"]) {
        //读取设备信息上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadDeviceInfoReportIntervalOperation;
    }else if ([cmd isEqualToString:@"05"]) {
        //读取设备上电状态
        resultDic = @{
            @"state":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadDefaultPowerStatusOperation;
    }else if ([cmd isEqualToString:@"07"]) {
        //读取iBeacon数据上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadBeaconReportIntervalOperation;
    }else if ([cmd isEqualToString:@"09"]) {
        //读取重复数据过滤类型
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadFilterRepeatingDataTypeOperation;
    }else if ([cmd isEqualToString:@"0a"]) {
        //读取上报的iBeacon数据类型
        NSString *state = [MKBLEBaseSDKAdopter binaryByhex:content];
        BOOL unknown = [[state substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL iBeacon = [[state substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        BOOL eddystone = [[state substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
        resultDic = @{
            @"unknown":@(unknown),
            @"iBeacon":@(iBeacon),
            @"eddystone":@(eddystone),
        };
        operationID = mk_lb_taskReadBeaconReportDataTypeOperation;
    }else if ([cmd isEqualToString:@"0b"]) {
        //读取上报的iBeacon最大数据长度
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadBeaconReportDataMaxLengthOperation;
    }else if ([cmd isEqualToString:@"0d"]) {
        //读取mac地址
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        operationID = mk_lb_taskReadMacAddressOperation;
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
    }else if ([cmd isEqualToString:@"0e"]) {
        //读取iBeacon上报数据内容选择
        NSString *state = [MKBLEBaseSDKAdopter binaryByhex:content];
        BOOL response = [[state substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL broadcast = [[state substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        BOOL rssi = [[state substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
        BOOL mac = [[state substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
        BOOL timestamp = [[state substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
        resultDic = @{
            @"response":@(response),
            @"broadcast":@(broadcast),
            @"rssi":@(rssi),
            @"mac":@(mac),
            @"timestamp":@(timestamp),
        };
        operationID = mk_lb_taskReadBeaconReportDataContentOperation;
    }else if ([cmd isEqualToString:@"0f"]) {
        //读取扫描MAC超限开关
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, content.length)] == 1);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lb_taskReadMacOverLimitScanStatusOperation;
    }else if ([cmd isEqualToString:@"10"]) {
        //读取扫描MAC超限间隔
        resultDic = @{
            @"duration":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadMacOverLimitDurationOperation;
    }else if ([cmd isEqualToString:@"11"]) {
        //读取扫描MAC超限数量
        resultDic = @{
            @"quantities":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadMacOverLimitQuantitiesOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //读取扫描MAC超限RSSI
        resultDic = @{
            @"rssi":[MKBLEBaseSDKAdopter signedHexTurnString:content],
        };
        operationID = mk_lb_taskReadMacOverLimitRSSIOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //读取LoRaWAN频段
        resultDic = @{
            @"region":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadLorawanRegionOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //读取LoRaWAN入网类型
        resultDic = @{
            @"modem":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadLorawanModemOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //读取LoRaWAN class类型
        resultDic = @{
            @"classType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadLorawanClassTypeOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //读取LoRaWAN网络状态
        resultDic = @{
            @"status":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
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
            @"messageType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
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
            @"DR":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadLorawanDROperation;
    }else if ([cmd isEqualToString:@"2e"]) {
        //读取LoRaWAN ADR
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, content.length)] == 1);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lb_taskReadLorawanADROperation;
    }else if ([cmd isEqualToString:@"2f"]) {
        //读取LoRaWAN 组播开关
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, content.length)] == 1);
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
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, content.length)] == 1);
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
    }else if ([cmd isEqualToString:@"50"]) {
        //读取蓝牙名称
        NSData *nameData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *deviceName = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"deviceName":(MKValidStr(deviceName) ? deviceName : @""),
        };
        operationID = mk_lb_taskReadDeviceNameOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //读取蓝牙广播间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadBroadcastIntervalOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //读取蓝牙扫描开关状态
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, content.length)] == 1);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lb_taskReadScanStatusOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //读取扫描参数
        NSString *scanInterval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *scanWindow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        resultDic = @{
            @"scanInterval":scanInterval,
            @"scanWindow":scanWindow,
        };
        operationID = mk_lb_taskReadScanParamsOperation;
    }else if ([cmd isEqualToString:@"60"]) {
        //读取蓝牙过滤规则开关与或逻辑
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lb_taskReadBLELogicalRelationshipOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //读取蓝牙过滤规则1开关
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, content.length)] == 1);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lb_taskReadBLEFilterAStatusOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //读取蓝牙过滤规则1的过滤广播名称
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *deviceName = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            deviceName = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(5, data.length - 5)] encoding:NSUTF8StringEncoding];
        }
        if (!MKValidStr(deviceName)) {
            deviceName = @"";
        }
        resultDic = @{
            @"rule":rule,
            @"deviceName":deviceName,
        };
        operationID = mk_lb_taskReadBLEFilterADeviceNameOperation;
    }else if ([cmd isEqualToString:@"63"]) {
        //读取蓝牙过滤规则1过滤的mac地址
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *macAddress = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            macAddress = [content substringWithRange:NSMakeRange(2, content.length - 2)];
        }
        resultDic = @{
            @"rule":rule,
            @"macAddress":macAddress
        };
        operationID = mk_lb_taskReadBLEFilterADeviceMacOperation;
    }else if ([cmd isEqualToString:@"64"]) {
        //读取蓝牙过滤规则1过滤的major范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *majorLow = @"";
        NSString *majorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            majorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            majorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"majorLow":majorLow,
            @"majorHigh":majorHigh,
        };
        operationID = mk_lb_taskReadBLEFilterAMajorOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //读取蓝牙过滤规则1过滤的minor范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *minorLow = @"";
        NSString *minorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            minorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            minorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"minorLow":minorLow,
            @"minorHigh":minorHigh,
        };
        operationID = mk_lb_taskReadBLEFilterAMinorOperation;
    }else if ([cmd isEqualToString:@"66"]) {
        //读取蓝牙过滤规则1过滤的原始数据
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSMutableArray *filterList = [NSMutableArray array];
        if ([rule integerValue] > 0) {
            NSInteger subIndex = 2;
            //最多五条过滤数据
            for (NSInteger i = 0; i < 5; i ++) {
                NSInteger index0Len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(subIndex, 2)];
                NSString *index0Data = [content substringWithRange:NSMakeRange(subIndex + 2, index0Len * 2)];
                
                NSDictionary *index0Dic = @{
                    @"dataType":[index0Data substringWithRange:NSMakeRange(0, 2)],
                    @"minIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(2, 2)],
                    @"maxIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(4, 2)],
                    @"rawData":[index0Data substringFromIndex:6],
                    @"index":@(i),
                };
                [filterList addObject:index0Dic];
                subIndex += (index0Data.length + 2);
                if (subIndex >= content.length) {
                    break;
                }
            }
        }
        resultDic = @{
            @"rule":rule,
            @"filterList":filterList,
        };
        operationID = mk_lb_taskReadBLEFilterARawDataOperation;
    }else if ([cmd isEqualToString:@"67"]) {
        //读取蓝牙过滤规则1过滤的UUID
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *uuid = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            uuid = [content substringWithRange:NSMakeRange(2, content.length - 2)];
        }
        resultDic = @{
            @"rule":rule,
            @"uuid":uuid
        };
        operationID = mk_lb_taskReadBLEFilterAUUIDOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //读取蓝牙过滤规则1过滤的RSSI
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:content];
        resultDic = @{
            @"rssi":rssi,
        };
        operationID = mk_lb_taskReadBLEFilterARssiOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //读取蓝牙过滤规则2开关
        BOOL isOn = ([MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(content, content.length)] == 1);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lb_taskReadBLEFilterBStatusOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //读取蓝牙过滤规则2的过滤广播名称
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *deviceName = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            deviceName = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(5, data.length - 5)] encoding:NSUTF8StringEncoding];
        }
        if (!MKValidStr(deviceName)) {
            deviceName = @"";
        }
        resultDic = @{
            @"rule":rule,
            @"deviceName":deviceName,
        };
        operationID = mk_lb_taskReadBLEFilterBDeviceNameOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //读取蓝牙过滤规则2过滤的mac地址
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *macAddress = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            macAddress = [content substringWithRange:NSMakeRange(2, content.length - 2)];
        }
        resultDic = @{
            @"rule":rule,
            @"macAddress":macAddress
        };
        operationID = mk_lb_taskReadBLEFilterBDeviceMacOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //读取蓝牙过滤规则2过滤的major范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *majorLow = @"";
        NSString *majorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            majorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            majorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"majorLow":majorLow,
            @"majorHigh":majorHigh,
        };
        operationID = mk_lb_taskReadBLEFilterBMajorOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //读取蓝牙过滤规则2过滤的minor范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *minorLow = @"";
        NSString *minorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            minorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            minorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"minorLow":minorLow,
            @"minorHigh":minorHigh,
        };
        operationID = mk_lb_taskReadBLEFilterBMinorOperation;
    }else if ([cmd isEqualToString:@"6e"]) {
        //读取蓝牙过滤规则2过滤的原始数据
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSMutableArray *filterList = [NSMutableArray array];
        if ([rule integerValue] > 0) {
            NSInteger subIndex = 2;
            //最多五条过滤数据
            for (NSInteger i = 0; i < 5; i ++) {
                NSInteger index0Len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(subIndex, 2)];
                NSString *index0Data = [content substringWithRange:NSMakeRange(subIndex + 2, index0Len * 2)];
                
                NSDictionary *index0Dic = @{
                    @"dataType":[index0Data substringWithRange:NSMakeRange(0, 2)],
                    @"minIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(2, 2)],
                    @"maxIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(4, 2)],
                    @"rawData":[index0Data substringFromIndex:6],
                    @"index":@(i),
                };
                [filterList addObject:index0Dic];
                subIndex += (index0Data.length + 2);
                if (subIndex >= content.length) {
                    break;
                }
            }
        }
        resultDic = @{
            @"rule":rule,
            @"filterList":filterList,
        };
        operationID = mk_lb_taskReadBLEFilterBRawDataOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //读取蓝牙过滤规则2过滤的UUID
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *uuid = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            uuid = [content substringWithRange:NSMakeRange(2, content.length - 2)];
        }
        resultDic = @{
            @"rule":rule,
            @"uuid":uuid
        };
        operationID = mk_lb_taskReadBLEFilterBUUIDOperation;
    }else if ([cmd isEqualToString:@"70"]) {
        //读取蓝牙过滤规则2过滤的RSSI
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:content];
        resultDic = @{
            @"rssi":rssi,
        };
        operationID = mk_lb_taskReadBLEFilterBRssiOperation;
    }
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_lb_taskOperationID operationID = mk_lb_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"00"];
    if ([cmd isEqualToString:@"01"]) {
        //入网/重启
        operationID = mk_lb_taskConfigConnectNetworkOperation;
    }else if ([cmd isEqualToString:@"02"]) {
        //设置设备信息上报间隔
        operationID = mk_lb_taskConfigDeviceInfoReportIntervalOperation;
    }else if ([cmd isEqualToString:@"03"]) {
        //设置时间同步
        operationID = mk_lb_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"04"]) {
        //设置连接密码
        operationID = mk_lb_taskConfigPasswordOperation;
    }else if ([cmd isEqualToString:@"05"]) {
        //设置设备默认上电状态
        operationID = mk_lb_taskConfigDefaultPowerStatusOperation;
    }else if ([cmd isEqualToString:@"07"]) {
        //设置iBeacon数据上报间隔
        operationID = mk_lb_taskConfigBeaconReportIntervalOperation;
    }else if ([cmd isEqualToString:@"09"]) {
        //配置重复数据过滤规则
        operationID = mk_lb_taskConfigFilterRepeatingDataTypeOperation;
    }else if ([cmd isEqualToString:@"0a"]) {
        //设置iBeacon数据上报类型
        operationID = mk_lb_taskConfigBeaconReportDataTypeOperation;
    }else if ([cmd isEqualToString:@"0b"]) {
        //设置iBeacon数据上报最大长度
        operationID = mk_lb_taskConfigBeaconReportDataMaxLenOperation;
    }else if ([cmd isEqualToString:@"0e"]) {
        //配置iBeacon上报数据内容选择
        operationID = mk_lb_taskConfigBeaconReportDataContentOperation;
    }else if ([cmd isEqualToString:@"0f"]) {
        //配置扫描MAC超限开关
        operationID = mk_lb_taskConfigMacOverLimitScanStatusOperation;
    }else if ([cmd isEqualToString:@"10"]) {
        //配置扫描MAC超限间隔
        operationID = mk_lb_taskConfigMacOverLimitDurationOperation;
    }else if ([cmd isEqualToString:@"11"]) {
        //配置扫描MAC超限数量
        operationID = mk_lb_taskConfigMacOverLimitQuantitiesOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //配置扫描MAC超限RSSI
        operationID = mk_lb_taskConfigMacOverLimitRssiOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //region
        operationID = mk_lb_taskConfigRegionOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //modem
        operationID = mk_lb_taskConfigModemOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //class type
        operationID = mk_lb_taskConfigClassTypeOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //devEUI
        operationID = mk_lb_taskConfigDEVEUIOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //appEUI
        operationID = mk_lb_taskConfigAPPEUIOperation;
    }else if ([cmd isEqualToString:@"27"]) {
        //appKey
        operationID = mk_lb_taskConfigAPPKEYOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //devAddr
        operationID = mk_lb_taskConfigDEVADDROperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //appSkey
        operationID = mk_lb_taskConfigAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"2a"]) {
        //nwkSkey
        operationID = mk_lb_taskConfigNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"2b"]) {
        //message type
        operationID = mk_lb_taskConfigMessageTypeOperation;
    }else if ([cmd isEqualToString:@"2c"]) {
        //CH
        operationID = mk_lb_taskConfigCHValueOperation;
    }else if ([cmd isEqualToString:@"2d"]) {
        //DR
        operationID = mk_lb_taskConfigDRValueOperation;
    }else if ([cmd isEqualToString:@"2e"]) {
        //ADR
        operationID = mk_lb_taskConfigADRStatusOperation;
    }else if ([cmd isEqualToString:@"2f"]) {
        //组播开关
        operationID = mk_lb_taskConfigMulticastStatusOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //组播地址
        operationID = mk_lb_taskConfigMulticastAddressOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //组播appSkey
        operationID = mk_lb_taskConfigMulticastAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //组播nwkSkey
        operationID = mk_lb_taskConfigMulticastNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //link check 检测间隔
        operationID = mk_lb_taskConfigLinkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //un link dell time
        operationID = mk_lb_taskConfigUpLinkeDellTimeOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //duty cycle
        operationID = mk_lb_taskConfigDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //sync time interval
        operationID = mk_lb_taskConfigTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"50"]) {
        //配置广播名称
        operationID = mk_lb_taskConfigDeviceNameOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //配置广播间隔
        operationID = mk_lb_taskConfigDeviceBroadcastIntervalOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //配置扫描开关
        operationID = mk_lb_taskConfigScanStatusOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //配置扫描参数
        operationID = mk_lb_taskConfigScanParamsOperation;
    }else if ([cmd isEqualToString:@"60"]) {
        //配置蓝牙过滤规则开关逻辑
        operationID = mk_lb_taskConfigBLELogicalRelationshipOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //配置过滤规则1的开关状态
        operationID = mk_lb_taskConfigBLEFilterAStatusOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //配置过滤规则1的广播名称
        operationID = mk_lb_taskConfigBLEFilterADeviceNameOperation;
    }else if ([cmd isEqualToString:@"63"]) {
        //配置过滤规则1的MAC地址
        operationID = mk_lb_taskConfigBLEFilterAMacOperation;
    }else if ([cmd isEqualToString:@"64"]) {
        //配置过滤规则1的MAJOR范围
        operationID = mk_lb_taskConfigBLEFilterAMajorOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //配置过滤规则1的MINOR范围
        operationID = mk_lb_taskConfigBLEFilterAMinorOperation;
    }else if ([cmd isEqualToString:@"66"]) {
        //配置过滤规则1的raw data
        operationID = mk_lb_taskConfigBLEFilterARawDataOperation;
    }else if ([cmd isEqualToString:@"67"]) {
        //配置过滤规则1的UUID
        operationID = mk_lb_taskConfigBLEFilterAUUIDOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //配置过滤规则1的RSSI
        operationID = mk_lb_taskConfigBLEFilterARSSIOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //配置过滤规则2的开关状态
        operationID = mk_lb_taskConfigBLEFilterBStatusOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //配置过滤规则2的广播名称
        operationID = mk_lb_taskConfigBLEFilterBDeviceNameOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //配置过滤规则2的MAC地址
        operationID = mk_lb_taskConfigBLEFilterBMacOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //配置过滤规则2的MAJOR范围
        operationID = mk_lb_taskConfigBLEFilterBMajorOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //配置过滤规则2的MINOR范围
        operationID = mk_lb_taskConfigBLEFilterBMinorOperation;
    }else if ([cmd isEqualToString:@"6e"]) {
        //配置过滤规则2的raw data
        operationID = mk_lb_taskConfigBLEFilterBRawDataOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //配置过滤规则2的UUID
        operationID = mk_lb_taskConfigBLEFilterBUUIDOperation;
    }else if ([cmd isEqualToString:@"70"]) {
        //配置过滤规则2的RSSI
        operationID = mk_lb_taskConfigBLEFilterBRSSIOperation;
    }
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_lb_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
