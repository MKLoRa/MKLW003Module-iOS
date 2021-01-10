//
//  MKLBOverLimitRssiCell.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBOverLimitRssiCellModel : NSObject

@property (nonatomic, assign)NSInteger sliderValue;

@end

@protocol MKLBOverLimitRssiCellDelegate <NSObject>

- (void)mk_overLimitRssiValueChanged:(NSInteger)sliderValue;

@end

@interface MKLBOverLimitRssiCell : MKBaseCell

@property (nonatomic, strong)MKLBOverLimitRssiCellModel *dataModel;

@property (nonatomic, weak)id <MKLBOverLimitRssiCellDelegate>delegate;

+ (MKLBOverLimitRssiCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
