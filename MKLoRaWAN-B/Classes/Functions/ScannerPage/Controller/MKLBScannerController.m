//
//  MKLBScannerController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBScannerController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKNormalTextCell.h"
#import "MKTextSwitchCell.h"

#import "MKLBOverLimitRssiCell.h"

#import "MKLBScannerDataModel.h"

#import "MKLBFilterOptionsController.h"

@interface MKLBScannerController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate,
MKLBOverLimitRssiCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)MKLBScannerDataModel *dataModel;

@end

@implementation MKLBScannerController

- (void)dealloc {
    NSLog(@"MKLBScannerController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    [self readDataFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_lb_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel configWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MKTextFieldCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 3) {
        return 70.f;
    }
    if (indexPath.section == 4) {
        MKTextFieldCellModel *cellModel = self.section4List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 5 && indexPath.row == 0) {
        MKLBFilterOptionsController *vc = [[MKLBFilterOptionsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return (self.dataModel.scanStatus ? self.section1List.count : 0);
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return (self.dataModel.overLimitStatus ? self.section3List.count : 0);
    }
    if (section == 4) {
        return (self.dataModel.overLimitStatus ? self.section4List.count : 0);
    }
    if (section == 5) {
        return self.section5List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKLBOverLimitRssiCell *cell = [MKLBOverLimitRssiCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section5List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Scan Switch
        self.dataModel.scanStatus = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 1) {
        //Over-limit Indication
        self.dataModel.overLimitStatus = isOn;
        MKTextSwitchCellModel *cellModel = self.section2List[0];
        cellModel.isOn = isOn;
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 1) {
        //scan window
        self.dataModel.scanWindow = value;
        return;
    }
    if (index == 2) {
        //Over-limit MAC Quantities
        self.dataModel.quantities = value;
        return;
    }
    if (index == 3) {
        //Duration
        self.dataModel.duration = value;
        return;
    }
}

#pragma mark - MKLBOverLimitRssiCellDelegate
- (void)mk_overLimitRssiValueChanged:(NSInteger)sliderValue {
    self.dataModel.rssi = sliderValue;
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel readWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf updateCellState];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellState {
    MKTextSwitchCellModel *scanSwitchModel = self.section0List[0];
    scanSwitchModel.isOn = self.dataModel.scanStatus;
    
    MKTextFieldCellModel *scanWindowModel = self.section1List[0];
    scanWindowModel.textFieldValue = self.dataModel.scanWindow;
    
    MKTextSwitchCellModel *overLimitStatusModel = self.section2List[0];
    overLimitStatusModel.isOn = self.dataModel.overLimitStatus;
    
    MKLBOverLimitRssiCellModel *rssiModel = self.section3List[0];
    rssiModel.sliderValue = self.dataModel.rssi;
    
    MKTextFieldCellModel *quanModel = self.section4List[0];
    quanModel.textFieldValue = self.dataModel.quantities;
    
    MKTextFieldCellModel *durationModel = self.section4List[1];
    durationModel.textFieldValue = self.dataModel.duration;
    
    [self.tableView reloadData];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.msg = @"Scan Switch";
    cellModel.index = 0;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Scan Window";
    cellModel2.unit = @"x 5ms";
    cellModel2.textPlaceholder = @"1~16";
    cellModel2.maxLength = 2;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.noteMsgColor = RGBCOLOR(102, 102, 102);
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.msg = @"Over-limit Indication";
    cellModel.index = 1;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKLBOverLimitRssiCellModel *cellModel = [[MKLBOverLimitRssiCellModel alloc] init];
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 2;
    cellModel1.msg = @"Over-limit MAC Quantities";
    cellModel1.textPlaceholder = @"1~255";
    cellModel1.maxLength = 3;
    cellModel1.textFieldType = mk_realNumberOnly;
    [self.section4List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 3;
    cellModel2.msg = @"Duration";
    cellModel2.unit = @"s";
    cellModel2.textPlaceholder = @"1~600";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 3;
    cellModel2.noteMsg = @"*The duration for trigger MAC and RSSI.";
    cellModel2.noteMsgColor = RGBCOLOR(102, 102, 102);
    [self.section4List addObject:cellModel2];
}

- (void)loadSection5Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Filter Options";
    cellModel.showRightIcon = YES;
    [self.section5List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"SCANNER";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-B", @"MKLBScannerController", @"lb_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
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

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (MKLBScannerDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLBScannerDataModel alloc] init];
    }
    return _dataModel;
}

@end
