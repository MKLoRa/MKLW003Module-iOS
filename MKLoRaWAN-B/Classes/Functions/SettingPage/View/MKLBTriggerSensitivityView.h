//
//  MKLBTriggerSensitivityView.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBTriggerSensitivityView : UIView

- (void)showViewWithValue:(NSInteger)value completeBlock:(void (^)(NSInteger resultValue))block;

@end

NS_ASSUME_NONNULL_END
