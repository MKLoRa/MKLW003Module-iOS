//
//  CBPeripheral+MKLBAdd.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKLBAdd)

#pragma mark - Read only

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lb_batteryPower;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lb_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lb_deviceModel;

@property (nonatomic, strong, readonly)CBCharacteristic *lb_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lb_sofeware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lb_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *lb_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *lb_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *lb_custom;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *lb_storageData;

- (void)lb_updateCharacterWithService:(CBService *)service;

- (void)lb_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)lb_connectSuccess;

- (void)lb_setNil;

@end

NS_ASSUME_NONNULL_END
