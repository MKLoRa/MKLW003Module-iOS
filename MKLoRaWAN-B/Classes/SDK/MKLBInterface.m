//
//  MKLBInterface.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKLBInterface.h"

#import "MKLBCentralManager.h"
#import "MKLBOperationID.h"
#import "MKLBOperation.h"
#import "CBPeripheral+MKLBAdd.h"

#define centralManager [MKLBCentralManager shared]
#define peripheral ([MKLBCentralManager shared].peripheral)

@implementation MKLBInterface

#pragma mark ****************************************Device Service Information************************************************

+ (void)lb_readBatteryPowerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadBatteryPowerOperation
                           characteristic:peripheral.lb_batteryPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadDeviceModelOperation
                           characteristic:peripheral.lb_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadFirmwareOperation
                           characteristic:peripheral.lb_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadHardwareOperation
                           characteristic:peripheral.lb_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadSoftwareOperation
                           characteristic:peripheral.lb_sofeware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadManufacturerOperation
                           characteristic:peripheral.lb_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ****************************************设备系统应用信息读取************************************************
+ (void)lb_readDeviceInfoReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadDeviceInfoReportIntervalOperation
                     cmdFlag:@"02"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readDefaultPowerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadDefaultPowerStatusOperation
                     cmdFlag:@"05"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readTriggerSensitivityWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadTriggerSensitivityOperation
                     cmdFlag:@"06"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBeaconReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBeaconReportIntervalOperation
                     cmdFlag:@"07"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readFilterRepeatingDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadFilterRepeatingDataTypeOperation
                     cmdFlag:@"09"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBeaconReportDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBeaconReportDataTypeOperation
                     cmdFlag:@"0a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBeaconReportDataMaxLengthWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBeaconReportDataMaxLengthOperation
                     cmdFlag:@"0b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacAddressOperation
                     cmdFlag:@"0d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBeaconReportDataContentWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBeaconReportDataContentOperation
                     cmdFlag:@"0e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacOverLimitScanStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacOverLimitScanStatusOperation
                     cmdFlag:@"0f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacOverLimitDurationWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacOverLimitDurationOperation
                     cmdFlag:@"10"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacOverLimitQuantitiesWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacOverLimitQuantitiesOperation
                     cmdFlag:@"11"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacOverLimitRSSIWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacOverLimitRSSIOperation
                     cmdFlag:@"12"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************设备LoRa参数读取************************************************

+ (void)lb_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanRegionOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanModemOperation
                     cmdFlag:@"22"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanClassTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanClassTypeOperation
                     cmdFlag:@"23"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanNetworkStatusOperation
                     cmdFlag:@"24"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDEVEUIOperation
                     cmdFlag:@"25"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanAPPEUIOperation
                     cmdFlag:@"26"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanAPPKEYOperation
                     cmdFlag:@"27"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDEVADDROperation
                     cmdFlag:@"28"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanAPPSKEYOperation
                     cmdFlag:@"29"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanNWKSKEYOperation
                     cmdFlag:@"2a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMessageTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMessageTypeOperation
                     cmdFlag:@"2b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanCHOperation
                     cmdFlag:@"2c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDROperation
                     cmdFlag:@"2d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanADRWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanADROperation
                     cmdFlag:@"2e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMulticastStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMulticastStatusOperation
                     cmdFlag:@"2f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMulticastAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMulticastAddressOperation
                     cmdFlag:@"30"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMulticastAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMulticastAPPSKEYOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMulticastNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMulticastNWKSKEYOperation
                     cmdFlag:@"32"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLinkcheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanLinkcheckIntervalOperation
                     cmdFlag:@"33"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readUplinkDellTimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanUplinkdwelltimeOperation
                     cmdFlag:@"34"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanDutyCycleStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDutyCycleStatusOperation
                     cmdFlag:@"35"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDevTimeSyncIntervalOperation
                     cmdFlag:@"36"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙广播参数************************************************

+ (void)lb_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadDeviceNameOperation
                     cmdFlag:@"50"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readDeviceBroadcastIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBroadcastIntervalOperation
                     cmdFlag:@"51"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readDeviceScanStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadScanStatusOperation
                     cmdFlag:@"52"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readDeviceScanParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadScanParamsOperation
                     cmdFlag:@"53"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙过滤规则************************************************

+ (void)lb_readBLELogicalRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBLELogicalRelationshipOperation
                     cmdFlag:@"60"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBLEFilterStatusWithType:(mk_lb_filterRulesType)type
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *cmd = @"61";
    mk_lb_taskOperationID taskID = mk_lb_taskReadBLEFilterAStatusOperation;
    if (type == mk_lb_filterRulesClassBType) {
        cmd = @"69";
        taskID = mk_lb_taskReadBLEFilterBStatusOperation;
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBLEFilterDeviceNameWithType:(mk_lb_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *cmd = @"62";
    mk_lb_taskOperationID taskID = mk_lb_taskReadBLEFilterADeviceNameOperation;
    if (type == mk_lb_filterRulesClassBType) {
        cmd = @"6a";
        taskID = mk_lb_taskReadBLEFilterBDeviceNameOperation;
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBLEFilterDeviceMacWithType:(mk_lb_filterRulesType)type
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *cmd = @"63";
    mk_lb_taskOperationID taskID = mk_lb_taskReadBLEFilterADeviceMacOperation;
    if (type == mk_lb_filterRulesClassBType) {
        cmd = @"6b";
        taskID = mk_lb_taskReadBLEFilterBDeviceMacOperation;
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBLEFilterDeviceMajorWithType:(mk_lb_filterRulesType)type
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *cmd = @"64";
    mk_lb_taskOperationID taskID = mk_lb_taskReadBLEFilterAMajorOperation;
    if (type == mk_lb_filterRulesClassBType) {
        cmd = @"6c";
        taskID = mk_lb_taskReadBLEFilterBMajorOperation;
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBLEFilterDeviceMinorWithType:(mk_lb_filterRulesType)type
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *cmd = @"65";
    mk_lb_taskOperationID taskID = mk_lb_taskReadBLEFilterAMinorOperation;
    if (type == mk_lb_filterRulesClassBType) {
        cmd = @"6d";
        taskID = mk_lb_taskReadBLEFilterBMinorOperation;
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBLEFilterDeviceRawDataWithType:(mk_lb_filterRulesType)type
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *cmd = @"66";
    mk_lb_taskOperationID taskID = mk_lb_taskReadBLEFilterARawDataOperation;
    if (type == mk_lb_filterRulesClassBType) {
        cmd = @"6e";
        taskID = mk_lb_taskReadBLEFilterBRawDataOperation;
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBLEFilterDeviceUUIDWithType:(mk_lb_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *cmd = @"67";
    mk_lb_taskOperationID taskID = mk_lb_taskReadBLEFilterAUUIDOperation;
    if (type == mk_lb_filterRulesClassBType) {
        cmd = @"6f";
        taskID = mk_lb_taskReadBLEFilterBUUIDOperation;
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBLEFilterDeviceRSSIWithType:(mk_lb_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *cmd = @"68";
    mk_lb_taskOperationID taskID = mk_lb_taskReadBLEFilterARssiOperation;
    if (type == mk_lb_filterRulesClassBType) {
        cmd = @"70";
        taskID = mk_lb_taskReadBLEFilterBRssiOperation;
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark - private method

+ (void)readDataWithTaskID:(mk_lb_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.lb_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
