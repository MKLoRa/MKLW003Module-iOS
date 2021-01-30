//
//  MKLBSettingDataModel.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBSettingDataModel.h"

#import "MKMacroDefines.h"

#import "MKLBInterface.h"

@interface MKLBSettingDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLBSettingDataModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError * error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read device name error" block:failedBlock];
            return;
        }
        if (![self readTriggerSensitivity]) {
            [self operationFailedBlockWithMsg:@"Read Tamper Detection Error" block:failedBlock];
            return;
        }
        if (![self readPowerStatus]) {
            [self operationFailedBlockWithMsg:@"Read power status error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKLBInterface lb_readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerSensitivity {
    __block BOOL success = NO;
    [MKLBInterface lb_readTriggerSensitivityWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        if ([returnData[@"result"][@"isOn"] boolValue]) {
            self.sensitivity = [returnData[@"result"][@"value"] integerValue];
        }else {
            self.sensitivity = 0;
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPowerStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_readDefaultPowerStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.powerStatus = [returnData[@"result"][@"state"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"settingPageParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("settingPageQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
