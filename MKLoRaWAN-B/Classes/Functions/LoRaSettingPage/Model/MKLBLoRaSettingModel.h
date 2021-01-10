//
//  MKLBLoRaSettingModel.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBLoRaSettingModel : NSObject

//1:ABP,2:OTAA
@property (nonatomic, assign)NSInteger modem;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *devEUI;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *appEUI;

//OTAA模式
@property (nonatomic, copy)NSString *appKey;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *devAddr;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *nwkSKey;

//OTAA模式/ABP模式
@property (nonatomic, copy)NSString *appSKey;

/**
 0:AS923
 1:AU915
 2:CN470
 3:CN778
 4:EU433
 5:EU868
 6:KR920
 7:IN865
 8:US915
 9:RU864
 */
@property (nonatomic, assign)NSInteger region;

/// 0:非确认帧，1:确认帧
@property (nonatomic, assign)NSInteger messageType;

/// 底部是否需要高级选项
@property (nonatomic, assign)BOOL needAdvanceSetting;

/// 底部高级选项是否打开(needAdvanceSetting == YES情况下)
@property (nonatomic, assign)BOOL advancedStatus;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
