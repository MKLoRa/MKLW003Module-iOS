//
//  MKLBUplinkPayloadModel.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBUplinkPayloadModel.h"

#import "MKMacroDefines.h"

#import "MKLBInterface.h"
#import "MKLBInterface+MKLBConfig.h"

@interface MKLBUplinkPayloadModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLBUplinkPayloadModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceInfoInterval]) {
            [self operationFailedBlockWithMsg:@"Read Device Info Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readBeaconReportDataType]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Report Data Type Error" block:failedBlock];
            return;
        }
        if (![self readBeaconReportContent]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Report Data Content Error" block:failedBlock];
            return;
        }
        if (![self readBeaconReportMaxLen]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Report Data Max Length Error" block:failedBlock];
            return;
        }
        if (![self readBeaconReportInterval]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Report Interval Error" block:failedBlock];
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
        if (![self configDeviceInfoInterval]) {
            [self operationFailedBlockWithMsg:@"Config Device Info Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configBeaconReportDataType]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Report Data Type Error" block:failedBlock];
            return;
        }
        if (![self configBeaconReportContent]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Report Data Content Error" block:failedBlock];
            return;
        }
        if (![self configBeaconReportMaxLen]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Report Data Max Length Error" block:failedBlock];
            return;
        }
        if (![self configBeaconReportInterval]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Report Interval Error" block:failedBlock];
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
- (BOOL)readDeviceInfoInterval {
    __block BOOL success = NO;
    [MKLBInterface lb_readDeviceInfoReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceInfoInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceInfoInterval {
    __block BOOL success = NO;
    [MKLBInterface lb_configDeviceInfoReportInterval:[self.deviceInfoInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBeaconReportDataType {
    __block BOOL success = NO;
    [MKLBInterface lb_readBeaconReportDataTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.unknownIsOn = [returnData[@"result"][@"unknown"] boolValue];
        self.iBeaconIsOn = [returnData[@"result"][@"iBeacon"] boolValue];
        self.eddystoneIsOn = [returnData[@"result"][@"eddystone"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconReportDataType {
    __block BOOL success = NO;
    [MKLBInterface lb_configBeaconReportDataType:self.unknownIsOn iBeaconIsOn:self.iBeaconIsOn eddystoneIsOn:self.eddystoneIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBeaconReportContent {
    __block BOOL success = NO;
    [MKLBInterface lb_readBeaconReportDataContentWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.responseIsOn = [returnData[@"result"][@"response"] boolValue];
        self.broadcastIsOn = [returnData[@"result"][@"broadcast"] boolValue];
        self.rssiIsOn = [returnData[@"result"][@"rssi"] boolValue];
        self.macIsOn = [returnData[@"result"][@"mac"] boolValue];
        self.timestampIsOn = [returnData[@"rsult"][@"timestamp"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconReportContent {
    __block BOOL success = NO;
    [MKLBInterface lb_configBeaconReportDataContent:self.timestampIsOn macIsOn:self.macIsOn rssiIsOn:self.rssiIsOn broadcastIsOn:self.broadcastIsOn responseIsOn:self.responseIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBeaconReportMaxLen {
    __block BOOL success = NO;
    [MKLBInterface lb_readBeaconReportDataMaxLengthWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.maxLenType = [returnData[@"result"][@"type"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconReportMaxLen {
    __block BOOL success = NO;
    [MKLBInterface lb_configBeaconReportDataMaxLen:self.maxLenType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBeaconReportInterval {
    __block BOOL success = NO;
    [MKLBInterface lb_readBeaconReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.beaconReportInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconReportInterval {
    __block BOOL success = NO;
    [MKLBInterface lb_configBeaconReportInterval:[self.beaconReportInterval integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"uplinkParams"
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
        _readQueue = dispatch_queue_create("uplinkQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
