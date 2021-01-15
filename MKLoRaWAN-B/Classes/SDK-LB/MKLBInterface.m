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

@implementation MKLBInterface

#pragma mark ****************************************Device Service Information************************************************

+ (void)lb_readBatteryPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadBatteryPowerOperation
                           characteristic:centralManager.peripheral.lb_batteryPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readDeviceModelWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadDeviceModelOperation
                           characteristic:centralManager.peripheral.lb_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readFirmwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadFirmwareOperation
                           characteristic:centralManager.peripheral.lb_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readHardwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadHardwareOperation
                           characteristic:centralManager.peripheral.lb_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readSoftwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadSoftwareOperation
                           characteristic:centralManager.peripheral.lb_sofeware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lb_readManufacturerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lb_taskReadManufacturerOperation
                           characteristic:centralManager.peripheral.lb_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ****************************************设备系统应用信息读取************************************************
+ (void)lb_readDeviceInfoReportIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadDeviceInfoReportIntervalOperation
                     cmdFlag:@"02"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBeaconReportIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBeaconReportIntervalOperation
                     cmdFlag:@"07"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBeaconReportDataTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBeaconReportDataTypeOperation
                     cmdFlag:@"0a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBeaconReportDataMaxLengthWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                         failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBeaconReportDataMaxLengthOperation
                     cmdFlag:@"0b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacAddressWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacAddressOperation
                     cmdFlag:@"0d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readBeaconReportDataContentWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                       failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBeaconReportDataContentOperation
                     cmdFlag:@"0e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacOverLimitScanStatusWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                      failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacOverLimitScanStatusOperation
                     cmdFlag:@"0f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacOverLimitDurationWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                    failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacOverLimitDurationOperation
                     cmdFlag:@"10"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacOverLimitQuantitiesWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                      failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacOverLimitQuantitiesOperation
                     cmdFlag:@"11"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readMacOverLimitRSSIWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadMacOverLimitRSSIOperation
                     cmdFlag:@"12"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************设备LoRa参数读取************************************************

+ (void)lb_readLorawanRegionWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanRegionOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanModemWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanModemOperation
                     cmdFlag:@"22"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanClassTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanClassTypeOperation
                     cmdFlag:@"23"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanNetworkStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanNetworkStatusOperation
                     cmdFlag:@"24"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanDEVEUIWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDEVEUIOperation
                     cmdFlag:@"25"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanAPPEUIWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanAPPEUIOperation
                     cmdFlag:@"26"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanAPPKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanAPPKEYOperation
                     cmdFlag:@"27"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanDEVADDRWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDEVADDROperation
                     cmdFlag:@"28"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanAPPSKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanAPPSKEYOperation
                     cmdFlag:@"29"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanNWKSKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanNWKSKEYOperation
                     cmdFlag:@"2a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMessageTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                  failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMessageTypeOperation
                     cmdFlag:@"2b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanCHWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanCHOperation
                     cmdFlag:@"2c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanDRWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDROperation
                     cmdFlag:@"2d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanADRWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanADROperation
                     cmdFlag:@"2e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMulticastStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMulticastStatusOperation
                     cmdFlag:@"2f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMulticastAddressWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMulticastAddressOperation
                     cmdFlag:@"30"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMulticastAPPSKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMulticastAPPSKEYOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanMulticastNWKSKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanMulticastNWKSKEYOperation
                     cmdFlag:@"32"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLinkcheckIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanLinkcheckIntervalOperation
                     cmdFlag:@"33"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readUplinkDellTimeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanUplinkdwelltimeOperation
                     cmdFlag:@"34"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanDutyCycleStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDutyCycleStatusOperation
                     cmdFlag:@"35"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readLorawanTimeSyncIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadLorawanDevTimeSyncIntervalOperation
                     cmdFlag:@"36"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙广播参数************************************************

+ (void)lb_readDeviceNameWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadDeviceNameOperation
                     cmdFlag:@"50"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readDeviceBroadcastIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadBroadcastIntervalOperation
                     cmdFlag:@"51"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readDeviceScanStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadScanStatusOperation
                     cmdFlag:@"52"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lb_readDeviceScanParamsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lb_taskReadScanParamsOperation
                     cmdFlag:@"53"
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
                       characteristic:centralManager.peripheral.lb_custom
                             resetNum:NO
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
