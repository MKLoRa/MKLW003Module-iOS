//
//  MKLBFilterRssiCell.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBFilterRssiCellModel : NSObject

@property (nonatomic, assign)NSInteger rssi;

@end

@protocol MKLBFilterRssiCellDelegate <NSObject>

- (void)mk_fliterRssiValueChanged:(NSInteger)rssi;

@end

@interface MKLBFilterRssiCell : MKBaseCell

@property (nonatomic, strong)MKLBFilterRssiCellModel *dataModel;

@property (nonatomic, weak)id <MKLBFilterRssiCellDelegate>delegate;

+ (MKLBFilterRssiCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
