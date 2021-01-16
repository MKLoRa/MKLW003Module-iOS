//
//  MKLBMulticastGroupModel.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBMulticastGroupModel.h"

#import "MKMacroDefines.h"

#import "MKLBInterface.h"
#import "MKLBInterface+MKLBConfig.h"

@interface MKLBMulticastGroupModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLBMulticastGroupModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError * error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readMulticastStatus]) {
            [self operationFailedBlockWithMsg:@"Read Multicast Status Error" block:failedBlock];
            return;
        }
        if (![self readAddr]) {
            [self operationFailedBlockWithMsg:@"Read Multicast Address Error" block:failedBlock];
            return;
        }
        if (![self readAppSkey]) {
            [self operationFailedBlockWithMsg:@"Read Multicast AppSkey Error" block:failedBlock];
            return;
        }
        if (![self readNwkSkey]) {
            [self operationFailedBlockWithMsg:@"Read Multicast NwkSkey Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError * error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configMulticastStatus]) {
            [self operationFailedBlockWithMsg:@"Config Multicast Status Error" block:failedBlock];
            return;
        }
        if (![self configAddr]) {
            [self operationFailedBlockWithMsg:@"Config Multicast Address Error" block:failedBlock];
            return;
        }
        if (![self configAppSkey]) {
            [self operationFailedBlockWithMsg:@"Config Multicast AppSkey Error" block:failedBlock];
            return;
        }
        if (![self configNwkSkey]) {
            [self operationFailedBlockWithMsg:@"Config Multicast NwkSkey Error" block:failedBlock];
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
- (BOOL)readMulticastStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanMulticastStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMulticastStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_configMulticastStatus:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAddr {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanMulticastAddressWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.mcAddr = returnData[@"result"][@"address"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAddr {
    __block BOOL success = NO;
    [MKLBInterface lb_configMulticastAddress:self.mcAddr sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAppSkey {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanMulticastAPPSKEYWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.mcAppSkey = returnData[@"result"][@"appSkey"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAppSkey {
    __block BOOL success = NO;
    [MKLBInterface lb_configMulticastAPPSKEY:self.mcAppSkey sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNwkSkey {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanMulticastNWKSKEYWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.mcNwkSkey = returnData[@"result"][@"nwkSkey"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNwkSkey {
    __block BOOL success = NO;
    [MKLBInterface lb_configMulticastNWKSKEY:self.mcNwkSkey sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"multicastGroupParams"
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
        _readQueue = dispatch_queue_create("multicastGroupQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
