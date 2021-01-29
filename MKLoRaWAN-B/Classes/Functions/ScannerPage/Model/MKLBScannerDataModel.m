//
//  MKLBScannerDataModel.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBScannerDataModel.h"

#import "MKMacroDefines.h"

#import "MKLBInterface.h"
#import "MKLBInterface+MKLBConfig.h"

@interface MKLBScannerDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLBScannerDataModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readScanStatus]) {
            [self operationFailedBlockWithMsg:@"Read scan status error" block:failedBlock];
            return;
        }
        if (![self readScanParams]) {
            [self operationFailedBlockWithMsg:@"Read scan params error" block:failedBlock];
            return;
        }
        if (![self readOverLimitStatus]) {
            [self operationFailedBlockWithMsg:@"Read over limit status error" block:failedBlock];
            return;
        }
        if (![self readOverLimitRssi]) {
            [self operationFailedBlockWithMsg:@"Read over limit rssi error" block:failedBlock];
            return;
        }
        if (![self readOverLimitDuration]) {
            [self operationFailedBlockWithMsg:@"Read over limit duration error" block:failedBlock];
            return;
        }
        if (![self readOverLimitQuantities]) {
            [self operationFailedBlockWithMsg:@"Read over limit quantities error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self checkParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configScanStatus]) {
            [self operationFailedBlockWithMsg:@"Config scan status error" block:failedBlock];
            return;
        }
        if (![self configScanParams]) {
            [self operationFailedBlockWithMsg:@"Config scan params error" block:failedBlock];
            return;
        }
        if (![self configOverLimitStatus]) {
            [self operationFailedBlockWithMsg:@"Config over limit status error" block:failedBlock];
            return;
        }
        if (![self configOverLimitRssi]) {
            [self operationFailedBlockWithMsg:@"Config over limit rssi error" block:failedBlock];
            return;
        }
        if (![self configOverLimitDuration]) {
            [self operationFailedBlockWithMsg:@"Config over limit duration error" block:failedBlock];
            return;
        }
        if (![self configOverLimitQuantities]) {
            [self operationFailedBlockWithMsg:@"Config over limit quantities error" block:failedBlock];
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
- (BOOL)readScanStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_readDeviceScanStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.scanStatus = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configScanStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_configScanStatus:self.scanStatus sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readScanParams {
    __block BOOL success = NO;
    [MKLBInterface lb_readDeviceScanParamsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.scanInterval = returnData[@"result"][@"scanInterval"];
        self.scanWindow = returnData[@"result"][@"scanWindow"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configScanParams {
    __block BOOL success = NO;
    [MKLBInterface lb_configScanInterval:[self.scanInterval integerValue] scanWindow:[self.scanWindow integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverLimitStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_readMacOverLimitScanStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.overLimitStatus = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverLimitStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_configMacOverLimitScanStatus:self.overLimitStatus sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverLimitRssi {
    __block BOOL success = NO;
    [MKLBInterface lb_readMacOverLimitRSSIWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rssi = [returnData[@"result"][@"rssi"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverLimitRssi {
    __block BOOL success = NO;
    [MKLBInterface lb_configMacOverLimitRssi:self.rssi sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverLimitQuantities {
    __block BOOL success = NO;
    [MKLBInterface lb_readMacOverLimitQuantitiesWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.quantities = returnData[@"result"][@"quantities"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverLimitQuantities {
    __block BOOL success = NO;
    [MKLBInterface lb_configMacOverLimitQuantities:[self.quantities integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverLimitDuration {
    __block BOOL success = NO;
    [MKLBInterface lb_readMacOverLimitDurationWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.duration = returnData[@"result"][@"duration"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverLimitDuration {
    __block BOOL success = NO;
    [MKLBInterface lb_configMacOverLimitDuration:[self.duration integerValue] sucBlock:^{
        success = YES;
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
        NSError *error = [[NSError alloc] initWithDomain:@"scannerParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    if (self.scanStatus) {
        if (!ValidStr(self.scanWindow) || [self.scanWindow integerValue] < 1 || [self.scanWindow integerValue] > 20) {
            return NO;
        }
        if (!ValidStr(self.scanInterval)) {
            return NO;
        }
        if ([self.scanInterval integerValue] > 20 || [self.scanInterval integerValue] < [self.scanWindow integerValue]) {
            return NO;
        }
    }
    if (self.overLimitStatus) {
        if (!ValidStr(self.quantities) || [self.quantities integerValue] < 1 || [self.quantities integerValue] > 255) {
            return NO;
        }
        if (!ValidStr(self.duration) || [self.duration integerValue] < 1 || [self.duration integerValue] > 600) {
            return NO;
        }
    }
    return YES;
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
        _readQueue = dispatch_queue_create("scannerParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
