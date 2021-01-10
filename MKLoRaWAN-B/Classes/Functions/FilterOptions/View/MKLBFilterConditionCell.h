//
//  MKLBFilterConditionCell.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLBFilterConditionCellModel : NSObject

@property (nonatomic, assign)NSInteger conditionIndex;

@end

@protocol MKLBFilterConditionCellDelegate <NSObject>

/// 关于发生改变
/// @param conditionIndex 0:And,1:Or
- (void)mk_filterConditionsChanged:(NSInteger)conditionIndex;

@end

@interface MKLBFilterConditionCell : MKBaseCell

@property (nonatomic, strong)MKLBFilterConditionCellModel *dataModel;

@property (nonatomic, weak)id <MKLBFilterConditionCellDelegate>delegate;

+ (MKLBFilterConditionCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
