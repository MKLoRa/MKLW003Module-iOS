//
//  MKLBFirmwareCell.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBFirmwareCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *rightMsg;

@end

@protocol MKLBFirmwareCellDelegate <NSObject>

- (void)mk_firmwareButtonMethod;

@end

@interface MKLBFirmwareCell : MKBaseCell

@property (nonatomic, strong)MKLBFirmwareCellModel *dataModel;

@property (nonatomic, weak)id <MKLBFirmwareCellDelegate>delegate;

+ (MKLBFirmwareCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
