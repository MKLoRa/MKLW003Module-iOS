//
//  MKLBAdvertiserDataModel.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/11.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBAdvertiserDataModel.h"

#import "MKMacroDefines.h"

#import "MKLBInterface.h"
#import "MKLBInterface+MKLBConfig.h"

@interface MKLBAdvertiserDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLBAdvertiserDataModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readAdvName]) {
            [self operationFailedBlockWithMsg:@"Read adv name error" block:failedBlock];
            return;
        }
        if (![self readAdvInterval]) {
            [self operationFailedBlockWithMsg:@"Read adv interval error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        NSString *checkMsg = [self checkParam];
        if (ValidStr(checkMsg)) {
            [self operationFailedBlockWithMsg:checkMsg block:failedBlock];
            return;
        }
        if (![self configAdvName]) {
            [self operationFailedBlockWithMsg:@"Config adv name error" block:failedBlock];
            return;
        }
        if (![self configAdvInterval]) {
            [self operationFailedBlockWithMsg:@"Config adv interval error" block:failedBlock];
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
- (BOOL)readAdvName {
    __block BOOL success = NO;
    [MKLBInterface lb_readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvName {
    __block BOOL success = NO;
    [MKLBInterface lb_configDeviceName:self.advName sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvInterval {
    __block BOOL success = NO;
    [MKLBInterface lb_readDeviceBroadcastIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvInterval {
    __block BOOL success = NO;
    [MKLBInterface lb_configDeviceBroadcastInterval:[self.advInterval integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"advertiserParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (NSString *)checkParam {
    if (!ValidStr(self.advName) || self.advName.length > 15) {
        return @"The maximum length of ADV Name is 15 characters";
    }
    if (!ValidStr(self.advInterval) || [self.advInterval integerValue] < 1 || [self.advInterval integerValue] > 100) {
        return @"ADV Interval range is 1~100";
    }
    return @"";
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
        _readQueue = dispatch_queue_create("advertiserQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
