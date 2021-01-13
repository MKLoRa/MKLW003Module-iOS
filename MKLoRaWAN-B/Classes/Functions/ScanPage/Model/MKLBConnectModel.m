//
//  MKLBConnectModel.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBConnectModel.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKMacroDefines.h"

@interface MKLBConnectModel ()

@property (nonatomic, strong)dispatch_queue_t connectQueue;

@property (nonatomic, strong)dispatch_semaphore_t connectSemaphore;

@end

@implementation MKLBConnectModel

- (void)connectDevice:(CBPeripheral *)peripheral
             password:(NSString *)password
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failed {
    
}

#pragma mark - getter
- (dispatch_queue_t)connectQueue {
    if (!_connectQueue) {
        _connectQueue = dispatch_queue_create("com.moko.connectQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _connectQueue;
}

- (dispatch_semaphore_t)connectSemaphore {
    if (!_connectSemaphore) {
        _connectSemaphore = dispatch_semaphore_create(0);
    }
    return _connectSemaphore;
}

@end
