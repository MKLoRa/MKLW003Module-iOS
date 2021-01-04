//
//  CBPeripheral+MKLBAdd.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKLBAdd.h"

#import <objc/runtime.h>

static const char *lb_batteryPowerKey = "lb_batteryPowerKey";
static const char *lb_manufacturerKey = "lb_manufacturerKey";
static const char *lb_deviceModelKey = "lb_deviceModelKey";
static const char *lb_hardwareKey = "lb_hardwareKey";
static const char *lb_softwareKey = "lb_softwareKey";
static const char *lb_firmwareKey = "lb_firmwareKey";

static const char *lb_passwordKey = "lb_passwordKey";
static const char *lb_disconnectTypeKey = "lb_disconnectTypeKey";
static const char *lb_customKey = "lb_customKey";
static const char *lb_storageDataKey = "lb_storageDataKey";

static const char *lb_passwordNotifySuccessKey = "lb_passwordNotifySuccessKey";
static const char *lb_disconnectTypeNotifySuccessKey = "lb_disconnectTypeNotifySuccessKey";
static const char *lb_customNotifySuccessKey = "lb_customNotifySuccessKey";
static const char *lb_storageDataNotifySuccessKey = "lb_storageDataNotifySuccessKey";

@implementation CBPeripheral (MKLBAdd)

- (void)lb_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180F"]]) {
        //电池电量
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
                objc_setAssociatedObject(self, &lb_batteryPowerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                break;
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &lb_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &lb_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &lb_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &lb_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &lb_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &lb_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &lb_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &lb_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &lb_storageDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)lb_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &lb_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &lb_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        objc_setAssociatedObject(self, &lb_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &lb_storageDataNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)lb_connectSuccess {
    if (![objc_getAssociatedObject(self, &lb_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &lb_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &lb_disconnectTypeNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &lb_storageDataNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.lb_batteryPower || !self.lb_manufacturer || !self.lb_deviceModel || !self.lb_hardware || !self.lb_sofeware || !self.lb_firmware) {
        return NO;
    }
    if (!self.lb_password || !self.lb_disconnectType || !self.lb_custom || !self.lb_storageData) {
        return NO;
    }
    return YES;
}

- (void)lb_setNil {
    objc_setAssociatedObject(self, &lb_batteryPowerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &lb_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_storageDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &lb_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lb_storageDataNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)lb_batteryPower {
    return objc_getAssociatedObject(self, &lb_batteryPowerKey);
}

- (CBCharacteristic *)lb_manufacturer {
    return objc_getAssociatedObject(self, &lb_manufacturerKey);
}

- (CBCharacteristic *)lb_deviceModel {
    return objc_getAssociatedObject(self, &lb_deviceModelKey);
}

- (CBCharacteristic *)lb_hardware {
    return objc_getAssociatedObject(self, &lb_hardwareKey);
}

- (CBCharacteristic *)lb_sofeware {
    return objc_getAssociatedObject(self, &lb_softwareKey);
}

- (CBCharacteristic *)lb_firmware {
    return objc_getAssociatedObject(self, &lb_firmwareKey);
}

- (CBCharacteristic *)lb_password {
    return objc_getAssociatedObject(self, &lb_passwordKey);
}

- (CBCharacteristic *)lb_disconnectType {
    return objc_getAssociatedObject(self, &lb_disconnectTypeKey);
}

- (CBCharacteristic *)lb_custom {
    return objc_getAssociatedObject(self, &lb_customKey);
}

- (CBCharacteristic *)lb_storageData {
    return objc_getAssociatedObject(self, &lb_storageDataKey);
}

@end
