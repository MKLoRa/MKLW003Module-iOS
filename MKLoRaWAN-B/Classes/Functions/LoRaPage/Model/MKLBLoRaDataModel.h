//
//  MKLBLoRaDataModel.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBLoRaDataModel : NSObject

@property (nonatomic, copy)NSString *modem;

@property (nonatomic, copy)NSString *region;

@property (nonatomic, copy)NSString *deviceType;

/// 网络连接状态
@property (nonatomic, assign)BOOL connected;

@property (nonatomic, assign)BOOL multicastSettingStatus;

@property (nonatomic, copy)NSString *syncInterval;

- (void)startReadWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)startConfigWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END