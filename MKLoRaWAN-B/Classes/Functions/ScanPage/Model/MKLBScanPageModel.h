//
//  MKLBScanPageModel.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKLBScanPageModel : NSObject

@property (nonatomic, strong)CBPeripheral *peripheral;

/// Current rssi of the device
@property (nonatomic, assign)NSInteger rssi;

/// Device name
@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *batteryPercentage;

@property (nonatomic, strong)NSNumber *temperature;

@property (nonatomic, strong)NSNumber *humidity;

/// cell上面显示的时间
@property (nonatomic, copy)NSString *scanTime;

/**
 上一次扫描到的时间
 */
@property (nonatomic, copy)NSString *lastScanDate;

/**
 当前model所在的row
 */
@property (nonatomic, assign)NSInteger index;

/// 设备可连接状态
@property (nonatomic, assign)BOOL connectable;

@end

NS_ASSUME_NONNULL_END
