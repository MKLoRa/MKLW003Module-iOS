//
//  MKLBSynDataParser.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBSynDataParser : NSObject

+ (NSArray *)parseScannerTrackedData:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
