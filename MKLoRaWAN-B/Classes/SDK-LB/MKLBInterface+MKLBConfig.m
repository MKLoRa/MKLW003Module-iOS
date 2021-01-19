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

+ (void)lb_configDefaultPowerStatus:(mk_lb_defaultPowerStatus)status
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *stateString = @"00";
    if (status == mk_lb_defaultPowerStatusSwitchOn) {
        stateString = @"01";
    }else if (status == mk_lb_defaultPowerStatusSwitchRevertToLastStatus) {
        stateString = @"02";
    }
    NSString *commandString = [@"ed010501" stringByAppendingString:stateString];
    [self configDataWithTaskID:mk_lb_taskConfigDefaultPowerStatusOperation
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

+ (void)lb_configFilterRepeatingDataType:(mk_lb_filterRepeatingDataType)dataType
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [NSString stringWithFormat:@"%ld",(long)dataType];
    if (type.length == 1) {
        type = [@"0" stringByAppendingString:type];
    }
    NSString *commandString = [@"ed010901" stringByAppendingString:type];
    [self configDataWithTaskID:mk_lb_taskConfigFilterRepeatingDataTypeOperation
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

+ (void)lb_configMacOverLimitScanStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed010f0101" : @"ed010f0100");
    [self configDataWithTaskID:mk_lb_taskConfigMacOverLimitScanStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configMacOverLimitDuration:(NSInteger)duration
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (duration < 1 || duration > 600) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)duration];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed011002" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigMacOverLimitDurationOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configMacOverLimitQuantities:(NSInteger)quantities
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (quantities < 1 || quantities > 255) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)quantities];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed011101" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigMacOverLimitQuantitiesOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configMacOverLimitRssi:(NSInteger)rssi
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *commandString = [@"ed011201" stringByAppendingString:rssiValue];
    [self configDataWithTaskID:mk_lb_taskConfigMacOverLimitRssiOperation
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
    NSString *commandString = (isOn ? @"ed012f0101" : @"ed012f0102");
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

#pragma mark ****************************************蓝牙广播参数************************************************

+ (void)lb_configDeviceName:(NSString *)deviceName
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(deviceName) || deviceName.length < 1 || deviceName.length > 15
        || ![MKBLEBaseSDKAdopter asciiString:deviceName]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)deviceName.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"ed0150%@%@",lenString,tempString];
    [self configDataWithTaskID:mk_lb_taskConfigDeviceNameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/// Configure Bluetooth broadcast interval.
/// @param interval 1 ~ 100,unit:100ms
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configDeviceBroadcastInterval:(NSInteger)interval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed015101" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskConfigDeviceBroadcastIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configScanStatus:(BOOL)isOn
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01520101" : @"ed01520100");
    [self configDataWithTaskID:mk_lb_taskConfigScanStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/// Configure device scan parameters.
/// @param scanInterval 1 ~ 20,unit:5ms.
/// @param scanWindow 1 ~ 20,unit:5ms. scanWindow <= scanInterval
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configScanInterval:(NSInteger)scanInterval
                   scanWindow:(NSInteger)scanWindow
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (scanWindow < 1 || scanWindow > 20 || scanInterval < scanWindow || scanInterval > 20) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *interValvalue = [NSString stringWithFormat:@"%1lx",(unsigned long)scanInterval];
    if (interValvalue.length == 1) {
        interValvalue = [@"0" stringByAppendingString:interValvalue];
    }
    NSString *windowValue = [NSString stringWithFormat:@"%1lx",(unsigned long)scanWindow];
    if (windowValue.length == 1) {
        windowValue = [@"0" stringByAppendingString:windowValue];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed015302",interValvalue,windowValue];
    [self configDataWithTaskID:mk_lb_taskConfigScanParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙过滤规则************************************************

+ (void)lb_configBLELogicalRelationship:(mk_lb_BLELogicalRelationship)ship
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (ship == mk_lb_lLELogicalRelationshipAND ? @"ed01600101" : @"ed01600100");
    [self configDataWithTaskID:mk_lb_taskConfigBLELogicalRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/// Configure filter rule switch status.
/// @param type rule1 or rule2
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configBLEFilterStatusWithType:(mk_lb_filterRulesType)type
                                    isOn:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *typeString = (type == mk_lb_filterRulesClassAType ? @"61" : @"69");
    NSString *state = (isOn ? @"01" : @"00");
    mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAStatusOperation : mk_lb_taskConfigBLEFilterBStatusOperation);
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed01",typeString,@"01",state];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/// Configure the filtered device name.
/// @param type rule1 or rule2
/// @param rules rules
/// @param deviceName 1~29 ascii characters.If rules == mk_lb_filterRules_off, it can be empty.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configBLEFilterDeviceNameWithType:(mk_lb_filterRulesType)type
                                       rules:(mk_lb_filterRules)rules
                                  deviceName:(NSString *)deviceName
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (rules == mk_lb_filterRules_off) {
        //关闭，不需要校验
        NSString *commandString = (type == mk_lb_filterRulesClassAType ? @"ed01620100" : @"ed016a0100");
        mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterADeviceNameOperation : mk_lb_taskConfigBLEFilterBDeviceNameOperation);
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    if (!MKValidStr(deviceName) || deviceName.length > 29) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    
    NSString *typeString = (type == mk_lb_filterRulesClassAType ? @"62" : @"6a");
    NSString *rulesString = (rules == mk_lb_filterRules_forward ? @"01" : @"02");
    mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterADeviceNameOperation : mk_lb_taskConfigBLEFilterBDeviceNameOperation);
    
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)(deviceName.length + 1)];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01",typeString,lenString,rulesString,tempString];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/// Configure the filtered device mac.
/// @param type rule1 or rule2
/// @param rules rules
/// @param mac 1Byte ~ 6Byte.If rules == mk_lb_filterRules_off, it can be empty.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configBLEFilterDeviceMacWithType:(mk_lb_filterRulesType)type
                                      rules:(mk_lb_filterRules)rules
                                        mac:(NSString *)mac
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (rules == mk_lb_filterRules_off) {
        //关闭，不需要校验
        NSString *commandString = (type == mk_lb_filterRulesClassAType ? @"ed01630100" : @"ed016b0100");
        mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAMacOperation : mk_lb_taskConfigBLEFilterBMacOperation);
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    mac = [mac stringByReplacingOccurrencesOfString:@":" withString:@""];
    mac = [mac stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (!MKValidStr(mac) || mac.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:mac] || mac.length % 2 != 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeString = (type == mk_lb_filterRulesClassAType ? @"63" : @"6b");
    NSString *rulesString = (rules == mk_lb_filterRules_forward ? @"01" : @"02");
    mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAMacOperation : mk_lb_taskConfigBLEFilterBMacOperation);
    
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)((mac.length / 2) + 1)];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01",typeString,lenString,rulesString,mac];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

/// Configure the filtered MAJOR range.
/// @param type rule1 or rule2
/// @param rules rules
/// @param majorMin 0~65535
/// @param majorMax majorMin ~ 65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configBLEFilterDeviceMajorWithType:(mk_lb_filterRulesType)type
                                        rules:(mk_lb_filterRules)rules
                                     majorMin:(NSInteger)majorMin
                                     majorMax:(NSInteger)majorMax
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (rules == mk_lb_filterRules_off) {
        //关闭，不需要校验
        NSString *commandString = (type == mk_lb_filterRulesClassAType ? @"ed01640100" : @"ed016c0100");
        mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAMajorOperation : mk_lb_taskConfigBLEFilterBMajorOperation);
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    if (majorMin < 0 || majorMin > 65535 || majorMax < majorMin || majorMax > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [NSString stringWithFormat:@"%1lx",(unsigned long)majorMin];
    if (minString.length == 1) {
        minString = [@"000" stringByAppendingString:minString];
    }else if (minString.length == 2) {
        minString = [@"00" stringByAppendingString:minString];
    }else if (minString.length == 3) {
        minString = [@"0" stringByAppendingString:minString];
    }
    NSString *maxString = [NSString stringWithFormat:@"%1lx",(unsigned long)majorMax];
    if (maxString.length == 1) {
        maxString = [@"000" stringByAppendingString:maxString];
    }else if (maxString.length == 2) {
        maxString = [@"00" stringByAppendingString:maxString];
    }else if (maxString.length == 3) {
        maxString = [@"0" stringByAppendingString:maxString];
    }
    NSString *typeString = (type == mk_lb_filterRulesClassAType ? @"64" : @"6c");
    NSString *rulesString = (rules == mk_lb_filterRules_forward ? @"01" : @"02");
    mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAMajorOperation : mk_lb_taskConfigBLEFilterBMajorOperation);
    
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ed01",typeString,@"05",rulesString,minString,maxString];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configBLEFilterDeviceMinorWithType:(mk_lb_filterRulesType)type
                                        rules:(mk_lb_filterRules)rules
                                     minorMin:(NSInteger)minorMin
                                     minorMax:(NSInteger)minorMax
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (rules == mk_lb_filterRules_off) {
        //关闭，不需要校验
        NSString *commandString = (type == mk_lb_filterRulesClassAType ? @"ed01650100" : @"ed016d0100");
        mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAMinorOperation : mk_lb_taskConfigBLEFilterBMinorOperation);
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    if (minorMin < 0 || minorMin > 65535 || minorMax < minorMin || minorMax > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [NSString stringWithFormat:@"%1lx",(unsigned long)minorMin];
    if (minString.length == 1) {
        minString = [@"000" stringByAppendingString:minString];
    }else if (minString.length == 2) {
        minString = [@"00" stringByAppendingString:minString];
    }else if (minString.length == 3) {
        minString = [@"0" stringByAppendingString:minString];
    }
    NSString *maxString = [NSString stringWithFormat:@"%1lx",(unsigned long)minorMax];
    if (maxString.length == 1) {
        maxString = [@"000" stringByAppendingString:maxString];
    }else if (maxString.length == 2) {
        maxString = [@"00" stringByAppendingString:maxString];
    }else if (maxString.length == 3) {
        maxString = [@"0" stringByAppendingString:maxString];
    }
    NSString *typeString = (type == mk_lb_filterRulesClassAType ? @"65" : @"6d");
    NSString *rulesString = (rules == mk_lb_filterRules_forward ? @"01" : @"02");
    mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAMinorOperation : mk_lb_taskConfigBLEFilterBMinorOperation);
    
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ed01",typeString,@"05",rulesString,minString,maxString];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configBLEFilterDeviceRawDataWithType:(mk_lb_filterRulesType)type
                                          rules:(mk_lb_filterRules)rules
                                    rawDataList:(NSArray <mk_lb_BLEFilterRawDataProtocol> *)rawDataList
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (rules == mk_lb_filterRules_off) {
        //关闭，不需要校验
        NSString *commandString = (type == mk_lb_filterRulesClassAType ? @"ed01660100" : @"ed016e0100");
        mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterARawDataOperation : mk_lb_taskConfigBLEFilterBRawDataOperation);
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    if (!MKValidArray(rawDataList) || rawDataList.count > 5) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *contentData = @"";
    for (id <mk_lb_BLEFilterRawDataProtocol>protocol in rawDataList) {
        if (![self isConfirmRawFilterProtocol:protocol]) {
            [self operationParamsErrorBlock:failedBlock];
            return;
        }
        NSString *minIndex = [NSString stringWithFormat:@"%1lx",(unsigned long)protocol.minIndex];
        if (minIndex.length == 1) {
            minIndex = [@"0" stringByAppendingString:minIndex];
        }
        NSString *maxIndex = [NSString stringWithFormat:@"%1lx",(unsigned long)protocol.maxIndex];
        if (maxIndex.length == 1) {
            maxIndex = [@"0" stringByAppendingString:maxIndex];
        }
        NSString *lenString = [NSString stringWithFormat:@"%1lx",(unsigned long)(protocol.rawData.length / 2 + 3)];
        if (lenString.length == 1) {
            lenString = [@"0" stringByAppendingString:lenString];
        }
        NSString *conditionString = [NSString stringWithFormat:@"%@%@%@%@%@",lenString,protocol.dataType,minIndex,maxIndex,protocol.rawData];
        contentData = [contentData stringByAppendingString:conditionString];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)((contentData.length / 2) + 1)];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *typeString = (type == mk_lb_filterRulesClassAType ? @"66" : @"6e");
    NSString *rulesString = (rules == mk_lb_filterRules_forward ? @"01" : @"02");
    mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterARawDataOperation : mk_lb_taskConfigBLEFilterBRawDataOperation);
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01",typeString,lenString,rulesString,contentData];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configBLEFilterDeviceUUIDWithType:(mk_lb_filterRulesType)type
                                       rules:(mk_lb_filterRules)rules
                                        uuid:(NSString *)uuid
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (rules == mk_lb_filterRules_off) {
        //关闭，不需要校验
        NSString *commandString = (type == mk_lb_filterRulesClassAType ? @"ed01670100" : @"ed016f0100");
        mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAUUIDOperation : mk_lb_taskConfigBLEFilterBUUIDOperation);
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    uuid = [uuid stringByReplacingOccurrencesOfString:@":" withString:@""];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (!MKValidStr(uuid) || uuid.length > 32 || uuid.length % 2 != 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)((uuid.length / 2) + 1)];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *typeString = (type == mk_lb_filterRulesClassAType ? @"67" : @"6f");
    NSString *rulesString = (rules == mk_lb_filterRules_forward ? @"01" : @"02");
    mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterAUUIDOperation : mk_lb_taskConfigBLEFilterBUUIDOperation);
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01",typeString,lenString,rulesString,uuid];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_configBLEFilterDeviceRSSIWithType:(mk_lb_filterRulesType)type
                                        rssi:(NSInteger)rssi
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *typeString = (type == mk_lb_filterRulesClassAType ? @"68" : @"70");
    mk_lb_taskOperationID taskID = (type == mk_lb_filterRulesClassAType ? mk_lb_taskConfigBLEFilterARSSIOperation : mk_lb_taskConfigBLEFilterBRSSIOperation);
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed01",typeString,@"01",rssiValue];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************存储数据协议************************************************

+ (void)lb_readNumberOfDaysStoredData:(NSInteger)days
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (days < 1 || days > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)days];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed01a002" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lb_taskReadNumberOfDaysStoredDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_clearAllDatasWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01a100";
    [self configDataWithTaskID:mk_lb_taskClearAllDatasOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lb_pauseSendLocalData:(BOOL)pause
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (pause ? @"ed01a20100" : @"ed01a20101");
    [self configDataWithTaskID:mk_lb_taskPauseSendLocalDataOperation
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

+ (BOOL)isConfirmRawFilterProtocol:(id <mk_lb_BLEFilterRawDataProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_lb_BLEFilterRawDataProtocol)]) {
        return NO;
    }
    if (!MKValidStr(protocol.dataType) || protocol.dataType.length != 2 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.dataType]) {
        return NO;
    }
    NSArray *typeList = [self dataTypeList];
    if (![typeList containsObject:[protocol.dataType uppercaseString]]) {
        return NO;
    }
    if (protocol.minIndex == 0 && protocol.maxIndex == 0) {
        if (!MKValidStr(protocol.rawData) || protocol.rawData.length > 58 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.rawData] || (protocol.rawData.length % 2 != 0)) {
            return NO;
        }
        return YES;
    }
    if (protocol.minIndex < 0 || protocol.minIndex > 29 || protocol.maxIndex < 0 || protocol.maxIndex > 29) {
        return NO;
    }
    
    if (protocol.maxIndex < protocol.minIndex) {
        return NO;
    }
    if (!MKValidStr(protocol.rawData) || protocol.rawData.length > 58 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.rawData]) {
        return NO;
    }
    NSInteger totalLen = (protocol.maxIndex - protocol.minIndex + 1) * 2;
    if (protocol.rawData.length != totalLen) {
        return NO;
    }
    return YES;
}

+ (NSArray *)dataTypeList {
    return @[@"01",@"02",@"03",@"04",@"05",
             @"06",@"07",@"08",@"09",@"0A",
             @"0D",@"0E",@"0F",@"10",@"11",
             @"12",@"14",@"15",@"16",@"17",
             @"18",@"19",@"1A",@"1B",@"1C",
             @"1D",@"1E",@"1F",@"20",@"21",
             @"22",@"23",@"24",@"25",@"26",
             @"27",@"28",@"29",@"2A",@"2B",
             @"2C",@"2D",@"3D",@"FF"];
}

@end
