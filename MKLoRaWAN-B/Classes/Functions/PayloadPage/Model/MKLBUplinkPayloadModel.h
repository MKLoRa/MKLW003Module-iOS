//
//  MKLBUplinkPayloadModel.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBUplinkPayloadModel : NSObject

/// 设备信息上报间隔
@property (nonatomic, copy)NSString *deviceInfoInterval;

/// iBeacon上报的数据类型
@property (nonatomic, assign)BOOL iBeaconIsOn;

@property (nonatomic, assign)BOOL eddystoneIsOn;

@property (nonatomic, assign)BOOL unknownIsOn;

/// iBeacon上报数据内容选择
@property (nonatomic, assign)BOOL timestampIsOn;

@property (nonatomic, assign)BOOL macIsOn;

@property (nonatomic, assign)BOOL rssiIsOn;

@property (nonatomic, assign)BOOL broadcastIsOn;

@property (nonatomic, assign)BOOL responseIsOn;

/// iBeacon上报数据最大长度，0:最大242字节，1:115字节
@property (nonatomic, assign)NSInteger maxLenType;

/// iBeacon上报间隔
@property (nonatomic, copy)NSString *beaconReportInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
