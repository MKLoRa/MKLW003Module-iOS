//
//  MKLBNetworkStatusCell.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBNetworkStatusCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *statusMsg;

@end

@interface MKLBNetworkStatusCell : MKBaseCell

@property (nonatomic, strong)MKLBNetworkStatusCellModel *dataModel;

+ (MKLBNetworkStatusCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
