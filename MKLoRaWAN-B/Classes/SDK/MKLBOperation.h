//
//  MKLBOperation.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKLBOperationID.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const mk_lb_additionalInformation;
extern NSString *const mk_lb_dataInformation;
extern NSString *const mk_lb_dataStatusLev;

@interface MKLBOperation : NSOperation<MKBLEBaseOperationProtocol>

/**
 初始化通信线程
 
 @param operationID 当前线程的任务ID
 @param resetNum 是否需要根据外设返回的数据总条数来修改任务需要接受的数据总条数，YES需要，NO不需要
 @param commandBlock 发送命令回调
 @param completeBlock 数据通信完成回调
 @return operation
 */
- (instancetype)initOperationWithID:(mk_lb_taskOperationID)operationID
                           resetNum:(BOOL)resetNum
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, mk_lb_taskOperationID operationID, id returnData))completeBlock;

@end

NS_ASSUME_NONNULL_END
