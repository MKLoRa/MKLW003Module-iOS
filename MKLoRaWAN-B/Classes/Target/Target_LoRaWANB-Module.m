//
//  Target_LoRaWANB-Module.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "Target_LoRaWANB-Module.h"

#import "MKLBScanController.h"

@implementation Target_LoRaWANB_Module

/// 扫描页面
- (UIViewController *)Action_LoRaWANB_Module_ScanController:(NSDictionary *)params {
    return [[MKLBScanController alloc] init];
}

@end
