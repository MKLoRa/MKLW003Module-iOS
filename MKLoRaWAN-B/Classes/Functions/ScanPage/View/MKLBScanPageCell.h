//
//  MKLBScanPageCell.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2020/12/31.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLBScanPageCellDelegate <NSObject>

/// 连接按钮点击事件
/// @param index 当前cell的row
- (void)lb_scanCellConnectButtonPressed:(NSInteger)index;

@end

@class MKLBScanPageModel;
@interface MKLBScanPageCell : MKBaseCell

@property (nonatomic, strong)MKLBScanPageModel *dataModel;

@property (nonatomic, weak)id <MKLBScanPageCellDelegate>delegate;

+ (MKLBScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
