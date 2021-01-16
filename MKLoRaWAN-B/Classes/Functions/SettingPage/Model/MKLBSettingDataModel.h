//
//  MKLBSettingDataModel.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBSettingDataModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

/// 0:Switch off
/// 1:Switch on
/// 2:Revert to last status
@property (nonatomic, assign)NSInteger powerStatus;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
