//
//  MKLBScannerDataModel.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBScannerDataModel : NSObject

@property (nonatomic, assign)BOOL scanStatus;

@property (nonatomic, copy)NSString *scanInterval;

@property (nonatomic, copy)NSString *scanWindow;

@property (nonatomic, assign)BOOL overLimitStatus;

@property (nonatomic, assign)NSInteger rssi;

@property (nonatomic, copy)NSString *quantities;

@property (nonatomic, copy)NSString *duration;

@end

NS_ASSUME_NONNULL_END
