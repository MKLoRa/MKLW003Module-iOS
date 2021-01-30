//
//  MKLBInterface.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lb_filterRulesType) {
    mk_lb_filterRulesClassAType,
    mk_lb_filterRulesClassBType,
};

@interface MKLBInterface : NSObject

#pragma mark ****************************************Device Service Information************************************************

/// Read the battery level of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBatteryPowerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************设备系统应用信息读取************************************************

/// Reading device information reporting interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceInfoReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the power-on status of the device.
/// 0:Switch off.
/// 1:Switch on.
/// 2:Revert to last status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDefaultPowerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// The larger the value, the more sensitive the device judges the movement. Trigger Sensitivity is 0, the tamper detection will be off.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readTriggerSensitivityWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read iBeacon data reporting interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBeaconReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read duplicate data filter type.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readFilterRepeatingDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the reported iBeacon data type.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBeaconReportDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read iBeacon Report Data Max Length.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBeaconReportDataMaxLengthWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Reading mac address
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read iBeacon Report Data Content.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBeaconReportDataContentWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock;

/// Over-limit Indication.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacOverLimitScanStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError * error))failedBlock;

/// The duration for trigger MAC and RSSI.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacOverLimitDurationWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError * error))failedBlock;

/// Over-limit MAC Quantities.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacOverLimitQuantitiesWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError * error))failedBlock;

/// Over-limit RSSI.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readMacOverLimitRSSIWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock;

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
+ (void)lb_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read LoRaWAN network access type.
/*
 1:ABP
 2:OTAA
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read LoRaWAN class type.
/*
 0:classA
 1:classB
 2:classC
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanClassTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the current network status of LoRaWAN.
/*
    0:Not connected to the network.
    1:Connecting
    2:OTAA network access or ABP mode.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the DEVEUI of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPEUI of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the DEVADDR of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPSKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the NWKSKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan upstream data type.
/*
 0:Non-acknowledgement frame.
 1:Confirm the frame.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMessageTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan CH.
/*
 @{
 @"CHL":0
 @"CHH":2
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan DR.
/*
 @{
 @"DR":1
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read ADR status of lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanADRWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan multicast switch.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMulticastStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan multicast address.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMulticastAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read multicast APPSKEY of lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMulticastAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read multicast NWKSKEY of lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanMulticastNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan Linkcheck detection interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLinkcheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan Up link dell time.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readUplinkDellTimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan duty cycle status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanDutyCycleStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan devtime command synchronization interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readLorawanTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************蓝牙广播参数************************************************

/// Read Bluetooth broadcast device name.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Bluetooth broadcast interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceBroadcastIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device scan switch status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceScanStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device scan parameters, including scan interval and scan window duration.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readDeviceScanParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************蓝牙过滤规则************************************************

/// Read the logical relationship between the two sets of filtering rules, the two sets of rules can be OR and and.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLELogicalRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read filter rule switch status.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLEFilterStatusWithType:(mk_lb_filterRulesType)type
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filtered device name.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLEFilterDeviceNameWithType:(mk_lb_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filtered device mac.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLEFilterDeviceMacWithType:(mk_lb_filterRulesType)type
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filtered MAJOR range.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLEFilterDeviceMajorWithType:(mk_lb_filterRulesType)type
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filtered MINOR range.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLEFilterDeviceMinorWithType:(mk_lb_filterRulesType)type
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read filtered raw data.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLEFilterDeviceRawDataWithType:(mk_lb_filterRulesType)type
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read filtered UUID.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLEFilterDeviceUUIDWithType:(mk_lb_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read filtered RSSI.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_readBLEFilterDeviceRSSIWithType:(mk_lb_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
