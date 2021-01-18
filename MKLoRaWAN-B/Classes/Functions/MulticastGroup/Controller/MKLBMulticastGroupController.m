//
//  MKLBMulticastGroupController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBMulticastGroupController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextFieldCell.h"

#import "MKLBMulticastGroupModel.h"

@interface MKLBMulticastGroupController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)MKLBMulticastGroupModel *dataModel;

@end

@implementation MKLBMulticastGroupController

- (void)dealloc {
    NSLog(@"MKLBMulticastGroupController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
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
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return (self.dataModel.isOn ? self.section1List.count : 0);
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
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.isOn = isOn;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        self.dataModel.mcAddr = value;
        MKTextFieldCellModel *mcAddrModel = self.section1List[0];
        mcAddrModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        self.dataModel.mcAppSkey = value;
        MKTextFieldCellModel *mcAppSkeyModel = self.section1List[1];
        mcAppSkeyModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        self.dataModel.mcNwkSkey = value;
        MKTextFieldCellModel *mcNwkSkeyModel = self.section1List[2];
        mcNwkSkeyModel.textFieldValue = value;
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel readWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    [self.section0List removeAllObjects];
    MKTextSwitchCellModel *groupModel = [[MKTextSwitchCellModel alloc] init];
    groupModel.msg = @"Multicast Group";
    groupModel.msgFont = MKFont(18.f);
    groupModel.msgColor = UIColorFromRGB(0x2F84D0);
    groupModel.index = 0;
    groupModel.isOn = self.dataModel.isOn;
    [self.section0List addObject:groupModel];
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    
    MKTextFieldCellModel *mcAddrModel = [[MKTextFieldCellModel alloc] init];
    mcAddrModel.index = 0;
    mcAddrModel.msg = @"McAddr";
    mcAddrModel.textFieldType = mk_hexCharOnly;
    mcAddrModel.textFieldTextFont = MKFont(13.f);
    mcAddrModel.maxLength = 8;
    mcAddrModel.textFieldValue = self.dataModel.mcAddr;
    [self.section1List addObject:mcAddrModel];
    
    MKTextFieldCellModel *mcAppSkeyModel = [[MKTextFieldCellModel alloc] init];
    mcAppSkeyModel.index = 1;
    mcAppSkeyModel.msg = @"McAppSkey";
    mcAppSkeyModel.textFieldType = mk_hexCharOnly;
    mcAppSkeyModel.textFieldTextFont = MKFont(13.f);
    mcAppSkeyModel.maxLength = 32;
    mcAppSkeyModel.textFieldValue = self.dataModel.mcAppSkey;
    [self.section1List addObject:mcAppSkeyModel];
    
    MKTextFieldCellModel *mcNwkSkeyModel = [[MKTextFieldCellModel alloc] init];
    mcNwkSkeyModel.index = 2;
    mcNwkSkeyModel.msg = @"McNwkSkey";
    mcNwkSkeyModel.textFieldType = mk_hexCharOnly;
    mcNwkSkeyModel.textFieldTextFont = MKFont(13.f);
    mcNwkSkeyModel.maxLength = 32;
    mcNwkSkeyModel.textFieldValue = self.dataModel.mcNwkSkey;
    [self.section1List addObject:mcNwkSkeyModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Multicast Group";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-B", @"MKLBMulticastGroupController", @"lb_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
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

- (MKLBMulticastGroupModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLBMulticastGroupModel alloc] init];
    }
    return _dataModel;
}

@end
