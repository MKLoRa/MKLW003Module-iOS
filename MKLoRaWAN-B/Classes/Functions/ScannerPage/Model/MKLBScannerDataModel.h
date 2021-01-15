//
//  MKLBScannerDataModel.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBScannerDataModel : NSObject

@property (nonatomic, assign)BOOL scanStatus;

@property (nonatomic, copy)NSString *scanInterval;

@property (nonatomic, copy)NSString *scanWindow;

@property (nonatomic, assign)BOOL overLimitStatus;

/// 扫描MAC超限触发RSSI
@property (nonatomic, assign)NSInteger rssi;

/// 扫描MAC超限数量
@property (nonatomic, copy)NSString *quantities;

/// 扫描MAC超限间隔
@property (nonatomic, copy)NSString *duration;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
