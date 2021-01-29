//
//  MKLBFilterConditionController.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lb_conditionType) {
    mk_lb_conditionType_A,
    mk_lb_conditionType_B,
};

@interface MKLBFilterConditionController : MKBaseViewController

@property (nonatomic, assign)mk_lb_conditionType conditionType;

@end

NS_ASSUME_NONNULL_END
