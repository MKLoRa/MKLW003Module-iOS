//
//  MKLBInterface.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBInterface : NSObject

#pragma mark ****************************************Device Service Information************************************************

/// Read the battery level of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBatteryPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceModelWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readFirmwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readHardwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readSoftwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readManufacturerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock;

#pragma mark ****************************************设备系统应用信息读取************************************************

/// Reading device information reporting interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceInfoReportIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read iBeacon data reporting interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBeaconReportIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the reported iBeacon data type.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBeaconReportDataTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read iBeacon Report Data Max Length.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBeaconReportDataMaxLengthWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                         failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading mac address
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacAddressWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read iBeacon Report Data Content.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBeaconReportDataContentWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                       failedBlock:(void (^)(NSError * _Nonnull))failedBlock;

/// Over-limit Indication.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacOverLimitScanStatusWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                      failedBlock:(void (^)(NSError * _Nonnull))failedBlock;

/// The duration for trigger MAC and RSSI.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacOverLimitDurationWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                    failedBlock:(void (^)(NSError * _Nonnull))failedBlock;

/// Over-limit MAC Quantities.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacOverLimitQuantitiesWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                      failedBlock:(void (^)(NSError * _Nonnull))failedBlock;

/// Over-limit RSSI.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacOverLimitRSSIWithSucBlock:(void (^)(id _Nonnull))sucBlock
                                failedBlock:(void (^)(NSError * _Nonnull))failedBlock;

#pragma mark ****************************************设备LoRa参数读取************************************************

/// Read the region information of LoRaWAN.
/*
 0:AS923 
 1:AU915
 2:CN470
 3:CN779
 4:EU433
 5:EU868
 6:KR920
 7:IN865
 8:US915
 9:RU864
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanRegionWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read LoRaWAN network access type.
/*
 1:ABP
 2:OTAA
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanModemWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read LoRaWAN class type.
/*
 0:classA
 1:classB
 2:classC
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanClassTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the current network status of LoRaWAN.
/*
    0:Not connected to the network.
    1:Connecting
    2:OTAA network access or ABP mode.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanNetworkStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the DEVEUI of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanDEVEUIWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the APPEUI of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanAPPEUIWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the APPKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanAPPKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the DEVADDR of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanDEVADDRWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the APPSKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanAPPSKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the NWKSKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanNWKSKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan upstream data type.
/*
 0:Non-acknowledgement frame.
 1:Confirm the frame.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMessageTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                  failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan CH.
/*
 @{
 @"CHL":0
 @"CHH":2
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanCHWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan DR.
/*
 @{
 @"DR":1
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanDRWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                         failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read ADR status of lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanADRWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan multicast switch.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMulticastStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan multicast address.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMulticastAddressWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read multicast APPSKEY of lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMulticastAPPSKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read multicast NWKSKEY of lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMulticastNWKSKEYWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan Linkcheck detection interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLinkcheckIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan Up link dell time.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readUplinkDellTimeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan duty cycle status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanDutyCycleStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read lorawan devtime command synchronization interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanTimeSyncIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

#pragma mark ****************************************蓝牙广播参数************************************************

/// Read Bluetooth broadcast device name.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceNameWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read Bluetooth broadcast interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceBroadcastIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device scan switch status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceScanStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device scan parameters, including scan interval and scan window duration.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceScanParamsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
