//
//  MKLBFilterOptionsController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBFilterOptionsController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextButtonCell.h"

#import "MKLBInterface+MKLBConfig.h"

#import "MKLBFilterOptionsModel.h"

#import "MKLBFilterConditionCell.h"

#import "MKLBFilterConditionController.h"

@interface MKLBFilterOptionsController ()<UITableViewDelegate,
UITableViewDataSource,
MKLBFilterConditionCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKLBFilterOptionsModel *dataModel;

@end

@implementation MKLBFilterOptionsController

- (void)dealloc {
    NSLog(@"MKLBFilterOptionsController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDataFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKLBFilterConditionController *vc = [[MKLBFilterConditionController alloc] init];
        vc.conditionType = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKLBFilterConditionCell *cell = [MKLBFilterConditionCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKLBFilterConditionCellDelegate
- (void)mk_filterConditionsChanged:(NSInteger)conditionIndex {
    self.dataModel.ABIsOr = (conditionIndex == 1);
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKLBInterface lb_configBLELogicalRelationship:(self.dataModel.ABIsOr ? mk_lb_BLELogicalRelationshipOR : mk_lb_BLELogicalRelationshipAND) sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Filter Repeating Data
        self.dataModel.filterRepeatingDataType = dataListIndex;
        [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
        [MKLBInterface lb_configFilterRepeatingDataType:dataListIndex sucBlock:^{
            [[MKHudManager share] hide];
            [self.view showCentralToast:@"Success"];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellState];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellState {
    MKNormalTextCellModel *conditionAModel = self.section0List[0];
    conditionAModel.rightMsg = (self.dataModel.conditionAIsOn ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *conditionBModel = self.section0List[1];
    conditionBModel.rightMsg = (self.dataModel.conditionBIsOn ? @"ON" : @"OFF");
    
    MKLBFilterConditionCellModel *cellModel = self.section1List[0];
    cellModel.enable = (self.dataModel.conditionAIsOn && self.dataModel.conditionBIsOn);
    cellModel.conditionIndex = (self.dataModel.ABIsOr ? 1 : 0);
    
    MKTextButtonCellModel *repeatModel = self.section2List[0];
    repeatModel.dataListIndex = self.dataModel.filterRepeatingDataType;
    
    [self.tableView reloadData];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Filter Condition A";
    cellModel1.rightMsg = @"ON";
    cellModel1.showRightIcon = YES;
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Filter Condition B";
    cellModel2.rightMsg = @"ON";
    cellModel2.showRightIcon = YES;
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKLBFilterConditionCellModel *cellModel = [[MKLBFilterConditionCellModel alloc] init];
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.msg = @"Filter Repeating Data";
    cellModel.index = 0;
    cellModel.dataList = @[@"No",@"MAC",@"MAC+Data Type",@"MAC+Raw Data"];
    [self.section2List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Filter Options";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (MKLBFilterOptionsModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLBFilterOptionsModel alloc] init];
    }
    return _dataModel;
}

@end
