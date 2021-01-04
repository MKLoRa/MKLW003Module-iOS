//
//  MKLBLoRaController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBLoRaController.h"

@interface MKLBLoRaController ()

@end

@implementation MKLBLoRaController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_lb_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"LoRa";
}

@end
