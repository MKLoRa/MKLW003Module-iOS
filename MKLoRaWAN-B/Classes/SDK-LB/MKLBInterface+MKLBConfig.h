//
//  MKLBInterface+MKLBConfig.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKLBInterface.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lb_loraWanRegion) {
    mk_lb_loraWanRegionAS923,
    mk_lb_loraWanRegionAU915,
    mk_lb_loraWanRegionCN470,
    mk_lb_loraWanRegionCN779,
    mk_lb_loraWanRegionEU433,
    mk_lb_loraWanRegionEU868,
    mk_lb_loraWanRegionKR920,
    mk_lb_loraWanRegionIN865,
    mk_lb_loraWanRegionUS915,
    mk_lb_loraWanRegionRU864,
};

typedef NS_ENUM(NSInteger, mk_lb_loraWanModem) {
    mk_lb_loraWanModemABP,
    mk_lb_loraWanModemOTAA,
};

typedef NS_ENUM(NSInteger, mk_lb_loraWanClassType) {
    mk_lb_loraWanClassTypeA,
    mk_lb_loraWanClassTypeC,
};

typedef NS_ENUM(NSInteger, mk_lb_loraWanMessageType) {
    mk_lb_loraWanUnconfirmMessage,          //Non-acknowledgement frame.
    mk_lb_loraWanConfirmMessage,            //Confirm the frame.
};

typedef NS_ENUM(NSInteger, mk_lb_iBeaconReportDataMaxLength) {
    mk_lb_iBeaconReportDataMax242Byte,
    mk_lb_iBeaconReportDataMax115Byte,
};

@interface MKLBInterface (MKLBConfig)

#pragma mark ****************************************设备系统应用信息设置************************************************

/// Device network access/restart instruction.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_connectNetworkWithSucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device information reporting interval.
/// @param interval 1min ~ 14400min
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configDeviceInfoReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Sync device time.
/// @param timestamp UTC
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device connection password.
/// @param password 8-character ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure iBeacon data reporting interval.
/// @param interval 10s ~ 65535s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configBeaconReportInterval:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the reported iBeacon data type.
/// @param unknownIsOn Whether unknown data is reported.
/// @param iBeaconIsOn Whether iBeacon data is reported.
/// @param eddystoneIsOn Whether eddystone data is reported.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configBeaconReportDataType:(BOOL)unknownIsOn
                          iBeaconIsOn:(BOOL)iBeaconIsOn
                        eddystoneIsOn:(BOOL)eddystoneIsOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure iBeacon Report Data Max Length.
/// @param len len
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configBeaconReportDataMaxLen:(mk_lb_iBeaconReportDataMaxLength)len
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure iBeacon Report Data Content.
/// @param timestampIsOn timestampIsOn
/// @param macIsOn macIsOn
/// @param rssiIsOn rssiIsOn
/// @param broadcastIsOn broadcastIsOn
/// @param responseIsOn responseIsOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configBeaconReportDataContent:(BOOL)timestampIsOn
                                 macIsOn:(BOOL)macIsOn
                                rssiIsOn:(BOOL)rssiIsOn
                           broadcastIsOn:(BOOL)broadcastIsOn
                            responseIsOn:(BOOL)responseIsOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************设备lorawan信息设置************************************************

/// Configure the region information of LoRaWAN.
/// @param region region
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configRegion:(mk_lb_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure LoRaWAN network access type.
/// @param modem modem
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configModem:(mk_lb_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure LoRaWAN class type.
/// @param classType classType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configClassType:(mk_lb_loraWanClassType)classType
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DEVEUI of LoRaWAN.
/// @param devEUI Hexadecimal characters, length must be 16.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPEUI of LoRaWAN.
/// @param appEUI Hexadecimal characters, length must be 16.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPKEY of LoRaWAN.
/// @param appKey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DEVADDR of LoRaWAN.
/// @param devAddr Hexadecimal characters, length must be 8.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPSKEY of LoRaWAN.
/// @param appSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the NWKSKEY of LoRaWAN.
/// @param nwkSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the message type of LoRaWAN.
/// @param messageType messageType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configMessageType:(mk_lb_loraWanMessageType)messageType
                    sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the CH of LoRaWAN.
/// @param chlValue Minimum value of CH.0 ~ 95
/// @param chhValue Maximum value of CH. chlValue ~ 95
/// @param sucBlock Success callback
/// @param failedBlock  Failure callback
+ (void)lb_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DR of LoRaWAN.
/// @param drValue 0~15
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the ADR status of LoRaWAN.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configADRStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the multicast switch of LoRaWAN. Note: When setting the multicast function, you need to send the multicast switch command last.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configMulticastStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the multicast address of LoRaWAN.
/// @param address Hexadecimal characters, length must be 8.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configMulticastAddress:(NSString *)address
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the multicast APPSKEY of LoRaWAN.
/// @param appSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configMulticastAPPSKEY:(NSString *)appSkey
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the multicast NWKSKEY of LoRaWAN.
/// @param nwkSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configMulticastNWKSKEY:(NSString *)nwkSkey
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure LoRaWAN link check detection interval.
/// @param interval 0h~720h
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configLinkCheckInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// It is only used for AS923 and AU915.0: Dell Time no limit,1:Dell Time 400ms.
/// @param time 0/1
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configUpLinkeDellTime:(NSInteger)time
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// It is only used for EU868,CN779, EU433,AS923,KR920,IN865,and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Time Sync Interval.
/// @param interval 0h~255h.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lb_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
