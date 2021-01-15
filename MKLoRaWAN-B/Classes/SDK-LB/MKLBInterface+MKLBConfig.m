//
//  MKLBInterface+MKLBConfig.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKLBInterface+MKLBConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKLBCentralManager.h"
#import "MKLBOperationID.h"
#import "MKLBOperation.h"
#import "CBPeripheral+MKLBAdd.h"

#define centralManager [MKLBCentralManager shared]

@implementation MKLBInterface (MKLBConfig)

#pragma mark ****************************************设备系统应用信息设置************************************************

+ (void)lb_connectNetworkWithSucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self configDataWithTaskID:mk_lb_taskConfigConnectNetworkOperation
                          data:@"ed010100"
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configDeviceInfoReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 14400) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed010202" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigDeviceInfoReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)timestamp];
    NSString *commandString = [@"ed010304" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigDeviceTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length != 8) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *commandString = [@"ed010408" stringByAppendingString:commandData];
    [self configDataWithTaskID:mk_lb_taskConfigPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configBeaconReportInterval:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed010702" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigBeaconReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configBeaconReportDataType:(BOOL)unknownIsOn
                          iBeaconIsOn:(BOOL)iBeaconIsOn
                        eddystoneIsOn:(BOOL)eddystoneIsOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *byteStr = [NSString stringWithFormat:@"00000%@%@%@",eddystoneIsOn ? @"1" : @"0",iBeaconIsOn ? @"1" : @"0",unknownIsOn ? @"1" : @"0"];
    NSString *value = [NSString stringWithFormat:@"%1lx",strtoul([byteStr UTF8String], 0, 2)];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed010a01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigBeaconReportDataTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configBeaconReportDataMaxLen:(mk_lb_iBeaconReportDataMaxLength)len
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (len == mk_lb_iBeaconReportDataMax242Byte) ? @"ed010b0100" : @"ed010b0101";
    [self configDataWithTaskID:mk_lb_taskConfigBeaconReportDataMaxLenOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configBeaconReportDataContent:(BOOL)timestampIsOn
                                 macIsOn:(BOOL)macIsOn
                                rssiIsOn:(BOOL)rssiIsOn
                           broadcastIsOn:(BOOL)broadcastIsOn
                            responseIsOn:(BOOL)responseIsOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *byteStr = [NSString stringWithFormat:@"000%@%@%@%@%@",timestampIsOn ? @"1" : @"0",macIsOn ? @"1" : @"0",rssiIsOn ? @"1" : @"0",broadcastIsOn ? @"1" : @"0",responseIsOn ? @"1" : @"0"];
    NSString *value = [NSString stringWithFormat:@"%1lx",strtoul([byteStr UTF8String], 0, 2)];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed010e01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigBeaconReportDataContentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************设备lorawan信息设置************************************************

+ (void)lb_configRegion:(mk_lb_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed012101",[self lorawanRegionString:region]];
    [self configDataWithTaskID:mk_lb_taskConfigRegionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configModem:(mk_lb_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (modem == mk_lb_loraWanModemABP) ? @"ed01220101" : @"ed01220102";
    [self configDataWithTaskID:mk_lb_taskConfigModemOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configClassType:(mk_lb_loraWanClassType)classType
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (classType == mk_lb_loraWanClassTypeA) ? @"ed01230100" : @"ed01230102";
    [self configDataWithTaskID:mk_lb_taskConfigClassTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devEUI) || devEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:devEUI]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012508" stringByAppendingString:devEUI];
    [self configDataWithTaskID:mk_lb_taskConfigDEVEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appEUI) || appEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:appEUI]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012608" stringByAppendingString:appEUI];
    [self configDataWithTaskID:mk_lb_taskConfigAPPEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appKey) || appKey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appKey]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012710" stringByAppendingString:appKey];
    [self configDataWithTaskID:mk_lb_taskConfigAPPKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devAddr) || devAddr.length != 8 || ![MKBLEBaseSDKAdopter checkHexCharacter:devAddr]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012804" stringByAppendingString:devAddr];
    [self configDataWithTaskID:mk_lb_taskConfigDEVADDROperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appSkey) || appSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appSkey]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012910" stringByAppendingString:appSkey];
    [self configDataWithTaskID:mk_lb_taskConfigAPPSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(nwkSkey) || nwkSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:nwkSkey]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012a10" stringByAppendingString:nwkSkey];
    [self configDataWithTaskID:mk_lb_taskConfigNWKSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configMessageType:(mk_lb_loraWanMessageType)messageType
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (messageType == mk_lb_loraWanUnconfirmMessage) ? @"ed012b0100" : @"ed012b0101";
    [self configDataWithTaskID:mk_lb_taskConfigMessageTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock {
    if (chlValue < 0 || chlValue > 95 || chhValue < chlValue || chhValue > 95) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *lowValue = [NSString stringWithFormat:@"%1lx",(unsigned long)chlValue];
    if (lowValue.length == 1) {
        lowValue = [@"0" stringByAppendingString:lowValue];
    }
    NSString *highValue = [NSString stringWithFormat:@"%1lx",(unsigned long)chhValue];
    if (highValue.length == 1) {
        highValue = [@"0" stringByAppendingString:highValue];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed012c02",lowValue,highValue];
    [self configDataWithTaskID:mk_lb_taskConfigCHValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock {
    if (drValue < 0 || drValue > 15) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)drValue];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed012d01",value];
    [self configDataWithTaskID:mk_lb_taskConfigDRValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configADRStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed012e0100" : @"ed012e0101");
    [self configDataWithTaskID:mk_lb_taskConfigADRStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configMulticastStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed012f0100" : @"ed012f0101");
    [self configDataWithTaskID:mk_lb_taskConfigMulticastStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configMulticastAddress:(NSString *)address
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(address) || address.length != 8 || ![MKBLEBaseSDKAdopter checkHexCharacter:address]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed013004" stringByAppendingString:address];
    [self configDataWithTaskID:mk_lb_taskConfigMulticastAddressOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configMulticastAPPSKEY:(NSString *)appSkey
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appSkey) || appSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appSkey]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed013110" stringByAppendingString:appSkey];
    [self configDataWithTaskID:mk_lb_taskConfigMulticastAPPSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configMulticastNWKSKEY:(NSString *)nwkSkey
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(nwkSkey) || nwkSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:nwkSkey]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed013210" stringByAppendingString:nwkSkey];
    [self configDataWithTaskID:mk_lb_taskConfigMulticastNWKSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configLinkCheckInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 720) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed013302",value];
    [self configDataWithTaskID:mk_lb_taskConfigLinkCheckIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configUpLinkeDellTime:(NSInteger)time
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (time != 0 && time != 1) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = (time == 0 ? @"ed01340100" : @"ed01340101");
    [self configDataWithTaskID:mk_lb_taskConfigUpLinkeDellTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01350100" : @"ed01350101");
    [self configDataWithTaskID:mk_lb_taskConfigDutyCycleStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 255) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed013601" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigTimeSyncIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_lb_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:centralManager.peripheral.lb_custom resetNum:NO commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [self operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

+ (void)operationParamsErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [MKBLEBaseSDKAdopter getErrorWithCode:-999 message:@"Params error"];
            block(error);
        }
    });
}

+ (void)operationSetParamsErrorBlock:(void (^)(NSError *error))block{
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [MKBLEBaseSDKAdopter getErrorWithCode:-10001 message:@"Set parameter error"];
            block(error);
        }
    });
}

+ (NSString *)lorawanRegionString:(mk_lb_loraWanRegion)region {
    switch (region) {
        case mk_lb_loraWanRegionAS923:
            return @"00";
        case mk_lb_loraWanRegionAU915:
            return @"01";
        case mk_lb_loraWanRegionCN470:
            return @"02";
        case mk_lb_loraWanRegionCN779:
            return @"03";
        case mk_lb_loraWanRegionEU433:
            return @"04";
        case mk_lb_loraWanRegionEU868:
            return @"05";
        case mk_lb_loraWanRegionKR920:
            return @"06";
        case mk_lb_loraWanRegionIN865:
            return @"07";
        case mk_lb_loraWanRegionUS915:
            return @"08";
        case mk_lb_loraWanRegionRU864:
            return @"09";
    }
}

@end
