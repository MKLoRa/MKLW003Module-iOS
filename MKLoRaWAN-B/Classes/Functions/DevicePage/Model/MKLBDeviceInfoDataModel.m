//
//  MKLBDeviceInfoDataModel.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBDeviceInfoDataModel.h"

@interface MKLBDeviceInfoDataModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLBDeviceInfoDataModel

- (void)startLoadSystemInformation:(BOOL)onlyBattery
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    
}

@end
