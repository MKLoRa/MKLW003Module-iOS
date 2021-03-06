//
//  MKLBLoRaSettingModel.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBLoRaSettingModel.h"

#import "MKMacroDefines.h"

#import "MKLBInterface.h"
#import "MKLBInterface+MKLBConfig.h"

@interface MKLBLoRaSettingModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLBLoRaSettingModel
- (instancetype)init {
    if (self = [super init]) {
        self.needAdvanceSetting = YES;
    }
    return self;
}

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError * error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readModem]) {
            [self operationFailedBlockWithMsg:@"Read Modem Error" block:failedBlock];
            return;
        }
        if (![self readRegion]) {
            [self operationFailedBlockWithMsg:@"Read Region Error" block:failedBlock];
            return;
        }
        if (![self readDevEUI]) {
            [self operationFailedBlockWithMsg:@"Read DevEUI Error" block:failedBlock];
            return;
        }
        if (![self readAppEUI]) {
            [self operationFailedBlockWithMsg:@"Read AppEUI Error" block:failedBlock];
            return;
        }
        if (![self readAppKey]) {
            [self operationFailedBlockWithMsg:@"Read AppKey Error" block:failedBlock];
            return;
        }
        if (![self readDevAddr]) {
            [self operationFailedBlockWithMsg:@"Read Region Error" block:failedBlock];
            return;
        }
        if (![self readAppSkey]) {
            [self operationFailedBlockWithMsg:@"Read AppSKEY Error" block:failedBlock];
            return;
        }
        if (![self readNwkSkey]) {
            [self operationFailedBlockWithMsg:@"Read NWKSKEY Error" block:failedBlock];
            return;
        }
        if (![self readMessageType]) {
            [self operationFailedBlockWithMsg:@"Read Message Type Error" block:failedBlock];
            return;
        }
        if (![self readClassType]) {
            [self operationFailedBlockWithMsg:@"Read Class Type Error" block:failedBlock];
            return;
        }
        if (!self.needAdvanceSetting) {
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        if (self.region == 1 || self.region == 2 || self.region == 8) {
            //US915、AU915、CN470
            if (![self readCHValue]) {
                [self operationFailedBlockWithMsg:@"Read CH Error" block:failedBlock];
                return;
            }
        }
        //Duty-cycle
        if (self.region == 3 || self.region == 4 || self.region == 5 || self.region == 9) {
            //EU868,CN779, EU433,RU864
            if (![self readDutyStatus]) {
                [self operationFailedBlockWithMsg:@"Read Duty Cycle Error" block:failedBlock];
                return;
            }
        }
        if (![self readADRStatus]) {
            [self operationFailedBlockWithMsg:@"Read ADR Error" block:failedBlock];
            return;
        }
        if (![self readDRValue]) {
            [self operationFailedBlockWithMsg:@"Read DR Error" block:failedBlock];
            return;
        }
        //UplinkDellTime
        if (self.region == 0 || self.region == 1) {
            //AS923、AU915
            if (![self readDellTime]) {
                [self operationFailedBlockWithMsg:@"Read Uplink Dell Time Error" block:failedBlock];
                return;
            }
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError * error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self checkParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configModem]) {
            [self operationFailedBlockWithMsg:@"Config Modem Error" block:failedBlock];
            return;
        }
        if (![self configRegion]) {
            [self operationFailedBlockWithMsg:@"Config Region Error" block:failedBlock];
            return;
        }
        if (![self configDevEUI]) {
            [self operationFailedBlockWithMsg:@"Config DevEUI Error" block:failedBlock];
            return;
        }
        if (![self configAppEUI]) {
            [self operationFailedBlockWithMsg:@"Config AppEUI Error" block:failedBlock];
            return;
        }
        if (self.modem == 1) {
            //ABP
            if (![self configDevAddr]) {
                [self operationFailedBlockWithMsg:@"Config Region Error" block:failedBlock];
                return;
            }
            if (![self configAppSkey]) {
                [self operationFailedBlockWithMsg:@"Config AppSKEY Error" block:failedBlock];
                return;
            }
            if (![self configNwkSkey]) {
                [self operationFailedBlockWithMsg:@"Config NWKSKEY Error" block:failedBlock];
                return;
            }
        }else if (self.modem == 2) {
            //OTAA
            if (![self configAppKey]) {
                [self operationFailedBlockWithMsg:@"Config AppKey Error" block:failedBlock];
                return;
            }
        }
        
        if (![self configMessageType]) {
            [self operationFailedBlockWithMsg:@"Config Message Type Error" block:failedBlock];
            return;
        }
        if (![self configClassType]) {
            [self operationFailedBlockWithMsg:@"Config Class Type Error" block:failedBlock];
            return;
        }
        if (!self.needAdvanceSetting) {
            if (![self connectCommand]) {
                [self operationFailedBlockWithMsg:@"Connect network error" block:failedBlock];
                return;
            }
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        if (self.region == 1 || self.region == 2 || self.region == 8) {
            if (![self configCHValue]) {
                [self operationFailedBlockWithMsg:@"Config CH Error" block:failedBlock];
                return;
            }
        }
        if (self.region == 3 || self.region == 4 || self.region == 5 || self.region == 9) {
            //EU868,CN779, EU433,RU864
            if (![self configDutyStatus]) {
                [self operationFailedBlockWithMsg:@"Config Duty Cycle Error" block:failedBlock];
                return;
            }
        }
        
        if (![self configADRStatus]) {
            [self operationFailedBlockWithMsg:@"Config ADR Error" block:failedBlock];
            return;
        }
        if (self.region == 0 || self.region == 1) {
            //AS923、AU915
            if (![self configDellTime]) {
                [self operationFailedBlockWithMsg:@"Config Uplink Dell Time Error" block:failedBlock];
                return;
            }
        }
        if (!self.adrIsOn) {
            if (![self configDRValue]) {
                [self operationFailedBlockWithMsg:@"Config DR Error" block:failedBlock];
                return;
            }
        }
        if (![self connectCommand]) {
            [self operationFailedBlockWithMsg:@"Connect network error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configAdvanceSettingDefaultParams {
    self.CHL = 0;
    if (self.region == 1 || self.region == 2 || self.region == 8) {
        //AU915、CN470、US915
        self.CHH = 7;
    }else if (self.region == 3) {
        //CN779
        self.CHH = 5;
    }else if (self.region == 4 || self.region == 5 || self.region == 6 || self.region == 7) {
        //EU433、EU868、KR920、IN865
        self.CHH = 2;
    }else if (self.region == 0 || self.region == 9) {
        //RU864、AS923
        self.CHH = 1;
    }
    self.dutyIsOn = NO;
    self.adrIsOn = YES;
    self.DR = 0;
    self.dellTime = 1;
}

- (NSArray <NSString *>*)CHLValueList {
    if (self.region == 1 || self.region == 8) {
        //AU915、US915
        return [self loadStringWithMaxValue:63];
    }
    if (self.region == 2) {
        //CN470
        return [self loadStringWithMaxValue:95];
    }
    if (self.region == 3) {
        //CN779
        return [self loadStringWithMaxValue:5];
    }
    if (self.region == 4 || self.region == 5 || self.region == 6 || self.region == 7) {
        //EU433、EU868、KR920、IN865
        return [self loadStringWithMaxValue:2];
    }
    //RU864、AS923
    return [self loadStringWithMaxValue:1];
}

- (NSArray <NSString *>*)CHHValueList {
    NSArray *chlList = [self CHLValueList];
    return [chlList subarrayWithRange:NSMakeRange(self.CHL, chlList.count - self.CHL)];
}

- (NSArray<NSString *> *)DRValueList {
    if (self.region == 8) {
        //US915
        return [self loadStringWithMaxValue:4];
    }
    if (self.region == 1) {
        //AU915
        return [self loadStringWithMaxValue:6];
    }
    return [self loadStringWithMaxValue:5];
}

#pragma mark - interface

- (BOOL)readModem {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanModemWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.modem = [returnData[@"result"][@"modem"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configModem {
    __block BOOL success = NO;
    [MKLBInterface lb_configModem:(self.modem - 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRegion {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanRegionWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.region = [returnData[@"result"][@"region"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRegion {
    __block BOOL success = NO;
    [MKLBInterface lb_configRegion:self.region sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDevEUI {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanDEVEUIWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.devEUI = returnData[@"result"][@"devEUI"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDevEUI {
    __block BOOL success = NO;
    [MKLBInterface lb_configDEVEUI:self.devEUI sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAppEUI {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanAPPEUIWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.appEUI = returnData[@"result"][@"appEUI"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAppEUI {
    __block BOOL success = NO;
    [MKLBInterface lb_configAPPEUI:self.appEUI sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAppKey {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanAPPKEYWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.appKey = returnData[@"result"][@"appKey"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAppKey {
    __block BOOL success = NO;
    [MKLBInterface lb_configAPPKEY:self.appKey sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDevAddr {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanDEVADDRWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.devAddr = returnData[@"result"][@"devAddr"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDevAddr {
    __block BOOL success = NO;
    [MKLBInterface lb_configDEVADDR:self.devAddr sucBlock:^{
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
    [MKLBInterface lb_readLorawanAPPSKEYWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.appSKey = returnData[@"result"][@"appSkey"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAppSkey {
    __block BOOL success = NO;
    [MKLBInterface lb_configAPPSKEY:self.appSKey sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMessageType {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanMessageTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.messageType = [returnData[@"result"][@"messageType"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMessageType {
    __block BOOL success = NO;
    [MKLBInterface lb_configMessageType:self.messageType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readClassType {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanClassTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger type = [returnData[@"result"][@"classType"] integerValue];
        if (type == 0) {
            self.classType = 0;
        }else {
            self.classType = 1;
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configClassType {
    __block BOOL success = NO;
    mk_lb_loraWanClassType type = mk_lb_loraWanClassTypeA;
    if (self.classType == 1) {
        type = mk_lb_loraWanClassTypeC;
    }
    [MKLBInterface lb_configClassType:type sucBlock:^{
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
    [MKLBInterface lb_readLorawanNWKSKEYWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.nwkSKey = returnData[@"result"][@"nwkSkey"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNwkSkey {
    __block BOOL success = NO;
    [MKLBInterface lb_configNWKSKEY:self.nwkSKey sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readCHValue {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanCHWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.CHL = [returnData[@"result"][@"CHL"] integerValue];
        self.CHH = [returnData[@"result"][@"CHH"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configCHValue {
    __block BOOL success = NO;
    [MKLBInterface lb_configCHL:self.CHL CHH:self.CHH sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDutyStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanDutyCycleStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dutyIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDutyStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_configDutyCycleStatus:self.dutyIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readADRStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanADRWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.adrIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configADRStatus {
    __block BOOL success = NO;
    [MKLBInterface lb_configADRStatus:self.adrIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDRValue {
    __block BOOL success = NO;
    [MKLBInterface lb_readLorawanDRWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.DR = [returnData[@"result"][@"DR"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDRValue {
    __block BOOL success = NO;
    [MKLBInterface lb_configDR:self.DR sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDellTime {
    __block BOOL success = NO;
    [MKLBInterface lb_readUplinkDellTimeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dellTime = [returnData[@"result"][@"time"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDellTime {
    __block BOOL success = NO;
    [MKLBInterface lb_configUpLinkeDellTime:self.dellTime sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)connectCommand {
    __block BOOL success = NO;
    [MKLBInterface lb_connectNetworkWithSucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"loraParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    //0:ABP,1:OTAA
    if (self.modem != 1 && self.modem != 2) {
        return NO;
    }
    if (!ValidStr(self.devEUI) || self.devEUI.length != 16) {
        return NO;
    }
    if (!ValidStr(self.appEUI) || self.appEUI.length != 16) {
        return NO;
    }
    if (self.modem == 1) {
        //ABP
        if (!ValidStr(self.devAddr) || self.devAddr.length != 8) {
            return NO;
        }
        if (!ValidStr(self.nwkSKey) || self.nwkSKey.length != 32) {
            return NO;
        }
        if (!ValidStr(self.appSKey) || self.appSKey.length != 32) {
            return NO;
        }
    }else {
        //OTAA
        if (!ValidStr(self.appKey) || self.appKey.length != 32) {
            return NO;
        }
    }
    if (self.region < 0 || self.region > 9) {
        return NO;
    }
    if (self.region == 1 || self.region == 2 || self.region == 8) {
        if (self.CHL < 0 || self.CHL > 95 || self.CHH < self.CHL || self.CHH > 95) {
            return NO;
        }
    }
    if (self.messageType != 0 && self.messageType != 1) {
        return NO;
    }
    return YES;
}

- (NSDictionary *)RegionDic {
    return @{
        @"0":@"AS923",
        @"1":@"AU915",
        @"2":@"CN470",
        @"3":@"CN779",
        @"4":@"EU433",
        @"5":@"EU868",
        @"6":@"KR920",
        @"7":@"IN865",
        @"8":@"US915",
        @"9":@"RU864"
    };
}

- (NSArray *)loadStringWithMaxValue:(NSInteger)max {
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i <= max; i ++) {
        [list addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    return list;
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
        _readQueue = dispatch_queue_create("loraParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
