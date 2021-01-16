//
//  MKLBFilterOptionsModel.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBFilterOptionsModel : NSObject

@property (nonatomic, assign)BOOL conditionAIsOn;

@property (nonatomic, assign)BOOL conditionBIsOn;

/// 两组规则关系，YES:OR ,NO:AND
@property (nonatomic, assign)BOOL ABIsOr;

/*
 0：无规则
 1：重复MAC过滤
 2：重复MAC以及data type过滤
 3：重复MAC以及RAW DATA过滤
 */
@property (nonatomic, assign)NSInteger filterRepeatingDataType;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
