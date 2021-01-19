//
//  MKLBDatabaseManager.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBDatabaseManager : NSObject

+ (BOOL)initDataBase;

+ (void)insertDataList:(NSArray <NSDictionary *>*)dataList
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)readDataListWithSucBlock:(void (^)(NSArray <NSDictionary *>*dataList))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

+ (BOOL)clearDataTable;

@end

NS_ASSUME_NONNULL_END
