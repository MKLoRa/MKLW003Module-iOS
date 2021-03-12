//
//  MKLBTabBarController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKLBTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKLBLoRaController.h"
#import "MKLBScannerController.h"
#import "MKLBSettingController.h"
#import "MKLBDeviceInfoController.h"

#import "MKLBCentralManager.h"

@interface MKLBTabBarController ()

/// 当触发
/// 01:表示连接成功后，1分钟内没有通过密码验证（未输入密码，或者连续输入密码错误）认为超时，返回结果， 然后断开连接
/// 02:修改密码成功后，返回结果，断开连接
/// 03:连续两分钟设备没有数据通信断开，返回结果，断开连接
/// 04:重启设备，就不需要显示断开连接的弹窗了，只需要显示对应的弹窗
@property (nonatomic, assign)BOOL disconnectType;

@end

@implementation MKLBTabBarController

- (void)dealloc {
    NSLog(@"MKLBTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKLBCentralManager shared] disconnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoScanPage)
                                                 name:@"mk_lb_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_lb_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_lb_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_lb_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_lb_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - notes
- (void)gotoScanPage {
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) sself = weakSelf;
        if ([sself.delegate respondsToSelector:@selector(mk_lb_needResetScanDelegate:)]) {
            [sself.delegate mk_lb_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) sself = weakSelf;
        if ([sself.delegate respondsToSelector:@selector(mk_lb_needResetScanDelegate:)]) {
            [sself.delegate mk_lb_needResetScanDelegate:YES];
        }
    }];
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //02:修改密码成功后，返回结果，断开连接
    //03:连续两分钟设备没有数据通信断开，返回结果，断开连接
    //04:重启设备
    self.disconnectType = YES;
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Password changed successfully! Please reconnect the device." title:@"Change Password"];
        return;
    }
    if ([type isEqualToString:@"03"]) {
        [self showAlertWithMsg:@"No data communication for 2 minutes, the device is disconnected." title:@""];
        return;
    }
    if ([type isEqualToString:@"04"]) {
        [self showAlertWithMsg:@"Factry reset successfully!Please reconnect the device." title:@"Dismiss"];
        return;
    }
}

- (void)centralManagerStateChanged{
    if (self.disconnectType) {
        return;
    }
    if ([MKLBCentralManager shared].centralStatus != mk_lb_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
    if (self.disconnectType) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

#pragma mark - private method
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf gotoScanPage];
    }];
    [alertController addAction:moreAction];
    
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_lb_settingPageNeedDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(presentAlert:) withObject:alertController afterDelay:1.2f];
}

- (void)presentAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadSubPages {
    MKLBLoRaController *loraPage = [[MKLBLoRaController alloc] init];
    loraPage.tabBarItem.title = @"LORA";
    loraPage.tabBarItem.image = LOADICON(@"MKLoRaWAN-B", @"MKLBTabBarController", @"lb_adv_tabBarUnselected.png");
    loraPage.tabBarItem.selectedImage = LOADICON(@"MKLoRaWAN-B", @"MKLBTabBarController", @"lb_adv_tabBarSelected.png");
    MKBaseNavigationController *advNav = [[MKBaseNavigationController alloc] initWithRootViewController:loraPage];

    MKLBScannerController *scannerPage = [[MKLBScannerController alloc] init];
    scannerPage.tabBarItem.title = @"SCANNER";
    scannerPage.tabBarItem.image = LOADICON(@"MKLoRaWAN-B", @"MKLBTabBarController", @"lb_scanner_tabBarUnselected.png");
    scannerPage.tabBarItem.selectedImage = LOADICON(@"MKLoRaWAN-B", @"MKLBTabBarController", @"lb_scanner_tabBarSelected.png");
    MKBaseNavigationController *scannerNav = [[MKBaseNavigationController alloc] initWithRootViewController:scannerPage];

    MKLBSettingController *setting = [[MKLBSettingController alloc] init];
    setting.tabBarItem.title = @"SETTINGS";
    setting.tabBarItem.image = LOADICON(@"MKLoRaWAN-B", @"MKLBTabBarController", @"lb_setting_taabBarUnselected.png");
    setting.tabBarItem.selectedImage = LOADICON(@"MKLoRaWAN-B", @"MKLBTabBarController", @"lb_setting_tabBarSelected.png");
    MKBaseNavigationController *settingPage = [[MKBaseNavigationController alloc] initWithRootViewController:setting];
    
    MKLBDeviceInfoController *deviceInfo = [[MKLBDeviceInfoController alloc] init];
    deviceInfo.tabBarItem.title = @"DEVICE";
    deviceInfo.tabBarItem.image = LOADICON(@"MKLoRaWAN-B", @"MKLBTabBarController", @"lb_device_tabBarUnselected.png");
    deviceInfo.tabBarItem.selectedImage = LOADICON(@"MKLoRaWAN-B", @"MKLBTabBarController", @"lb_device_tabBarSelected.png");
    MKBaseNavigationController *deviceInfoPage = [[MKBaseNavigationController alloc] initWithRootViewController:deviceInfo];
    
    self.viewControllers = @[advNav,scannerNav,settingPage,deviceInfoPage];
}

@end
