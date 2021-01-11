//
//  MKLBLoRaSettingController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBLoRaSettingController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"
#import "MKLoRaAdvancedSettingCell.h"
#import "MKLoRaSettingCHCell.h"

#import "MKLBLoRaSettingModel.h"

@interface MKLBLoRaSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate,
MKLoRaAdvancedSettingCellDelegate,
MKLoRaSettingCHCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *otaaDataList;

@property (nonatomic, strong)NSMutableArray *abpDataList;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *advSection0List;

@property (nonatomic, strong)NSMutableArray *advSection1List;

@property (nonatomic, strong)NSMutableArray *advSection2List;

@property (nonatomic, strong)NSMutableArray *advSection3List;

@property (nonatomic, strong)MKLBLoRaSettingModel *dataModel;

@end

@implementation MKLBLoRaSettingController

- (void)dealloc {
    NSLog(@"MKLBLoRaSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataModel.needAdvanceSetting = YES;
    self.dataModel.modem = 1;
    self.dataModel.advancedStatus = YES;
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        return 44.f;
    }
    //底部需要高级设置
    if (indexPath.section == 3 || indexPath.section == 4) {
        //Advanced Setting
        return 80.f;
    }
    if (indexPath.section == 5) {
        MKTextSwitchCellModel *cellModel = self.advSection2List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 6) {
        MKTextButtonCellModel *cellModel = self.advSection3List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 0.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.dataModel.needAdvanceSetting) {
        //底部不需要高级设置
        return 3;
    }
    //底部需要高级设置
    if (!self.dataModel.advancedStatus) {
        //高级设置开关状态关闭
        return 4;
    }
    //高级设置开关状态打开
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        if (self.dataModel.modem == 1) {
            //ABP
            return self.abpDataList.count;
        }
        if (self.dataModel.modem == 2) {
            //OTAA
            return self.otaaDataList.count;
        }
    }
    if (section == 2) {
        return self.section2List.count;
    }
    //存在高级设置选项
    if (section == 3) {
        return self.advSection0List.count;
    }
    if (!self.dataModel.advancedStatus) {
        //高级选项开关关闭状态
        return 0;
    }
    if (section == 4) {
        return self.advSection1List.count;
    }
    if (section == 5) {
        return self.advSection2List.count;
    }
    if (section == 6) {
        return self.advSection3List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        MKTextFieldCellModel *model = (self.dataModel.modem == 1) ? self.abpDataList[indexPath.row] : self.otaaDataList[indexPath.row];
        cell.dataModel = model;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKLoRaAdvancedSettingCell *cell = [MKLoRaAdvancedSettingCell initCellWithTableView:tableView];
        cell.dataModel = self.advSection0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKLoRaSettingCHCell *cell = [MKLoRaSettingCHCell initCellWithTableView:tableView];
        cell.dataModel = self.advSection1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.advSection2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.advSection3List[indexPath.row];
    cell.delegate = self;
    return cell;
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
        //modem
        self.dataModel.modem = (dataListIndex + 1);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 1) {
        //region
        self.dataModel.region = index;
        return;
    }
    if (index == 2) {
        //message type
        self.dataModel.messageType = index;
        return;
    }
    if (index == 3) {
        //DR
        return;
    }
    if (index == 4) {
        //UplinkDellTime
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //DevEUI
        self.dataModel.devEUI = value;
        return;
    }
    if (index == 1) {
        //AppEUI
        self.dataModel.appEUI = value;
        return;
    }
    if (index == 2) {
        //DevAddr
        self.dataModel.devAddr = value;
        return;
    }
    if (index == 3) {
        //AppSkey
        self.dataModel.appSKey = value;
        return;
    }
    if (index == 4) {
        //NwkSkey
        self.dataModel.nwkSKey = value;
        return;
    }
    if (index == 5) {
        //AppKey
        self.dataModel.appKey = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Duty-cycle
        return;
    }
    if (index == 1) {
        //ADR
        return;
    }
}

#pragma mark - MKLoRaSettingCHCellDelegate

/// 选择了右侧高位的列表
/// @param value 当前选中的值
/// @param chHighIndex 当前值在高位列表里面的index
/// @param index 当前cell所在的index
- (void)mk_loraSetting_chHighValueChanged:(NSString *)value
                              chHighIndex:(NSInteger)chHighIndex
                                cellIndex:(NSInteger)index {
    
}

/// 选择了左侧高\低位的列表
/// @param value 当前选中的值
/// @param chLowIndex 当前值在低位列表里面的index
/// @param index 当前cell所在的index
- (void)mk_loraSetting_chLowValueChanged:(NSString *)value
                              chLowIndex:(NSInteger)chLowIndex
                               cellIndex:(NSInteger)index {
    
}

#pragma mark - MKLoRaAdvancedSettingCellDelegate
- (void)mk_loraSetting_advanceCell_switchStatusChanged:(BOOL)isOn {
    self.dataModel.advancedStatus = isOn;
    MKLoRaAdvancedSettingCellModel *cellModel = self.advSection0List[0];
    cellModel.isOn = isOn;
    [self.tableView reloadData];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadABPDatas];
    [self loadOTAADatas];
    [self loadSection2Datas];
    if (!self.dataModel.needAdvanceSetting) {
        [self.tableView reloadData];
        return;
    }
    [self loadAdvSection0List];
    [self loadAdvSection1List];
    [self loadAdvSection2List];
    [self loadAdvSection3List];
    [self.tableView reloadData];
}

#pragma mark - 加载上面那个列表

- (void)loadSection0Datas {
    MKTextButtonCellModel *modeModel = [[MKTextButtonCellModel alloc] init];
    modeModel.index = 0;
    modeModel.msg = @"LoRaWAN Mode";
    modeModel.dataList = @[@"ABP",@"OTAA"];
    modeModel.buttonLabelFont = MKFont(13.f);
    [self.section0List addObject:modeModel];
}

- (void)loadABPDatas {
    MKTextFieldCellModel *devEUIModel = [[MKTextFieldCellModel alloc] init];
    devEUIModel.index = 0;
    devEUIModel.msg = @"DevEUI";
    devEUIModel.textFieldTextFont = MKFont(13.f);
    devEUIModel.textFieldType = mk_hexCharOnly;
    devEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    devEUIModel.maxLength = 16;
    [self.abpDataList addObject:devEUIModel];
    
    MKTextFieldCellModel *appEUIModel = [[MKTextFieldCellModel alloc] init];
    appEUIModel.index = 1;
    appEUIModel.msg = @"AppEUI";
    appEUIModel.textFieldTextFont = MKFont(13.f);
    appEUIModel.textFieldType = mk_hexCharOnly;
    appEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    appEUIModel.maxLength = 16;
    [self.abpDataList addObject:appEUIModel];
    
    MKTextFieldCellModel *devAddrModel = [[MKTextFieldCellModel alloc] init];
    devAddrModel.index = 2;
    devAddrModel.msg = @"DevAddr";
    devAddrModel.textFieldTextFont = MKFont(13.f);
    devAddrModel.textFieldType = mk_hexCharOnly;
    devAddrModel.clearButtonMode = UITextFieldViewModeAlways;
    devAddrModel.maxLength = 8;
    [self.abpDataList addObject:devAddrModel];
    
    MKTextFieldCellModel *appSkeyModel = [[MKTextFieldCellModel alloc] init];
    appSkeyModel.index = 3;
    appSkeyModel.msg = @"AppSkey";
    appSkeyModel.textFieldTextFont = MKFont(13.f);
    appSkeyModel.textFieldType = mk_hexCharOnly;
    appSkeyModel.clearButtonMode = UITextFieldViewModeAlways;
    appSkeyModel.maxLength = 32;
    [self.abpDataList addObject:appSkeyModel];
    
    MKTextFieldCellModel *nwkSkeyModel = [[MKTextFieldCellModel alloc] init];
    nwkSkeyModel.index = 4;
    nwkSkeyModel.msg = @"NwkSkey";
    nwkSkeyModel.textFieldTextFont = MKFont(13.f);
    nwkSkeyModel.textFieldType = mk_hexCharOnly;
    nwkSkeyModel.clearButtonMode = UITextFieldViewModeAlways;
    nwkSkeyModel.maxLength = 32;
    [self.abpDataList addObject:nwkSkeyModel];
}

- (void)loadOTAADatas {
    MKTextFieldCellModel *devEUIModel = [[MKTextFieldCellModel alloc] init];
    devEUIModel.index = 0;
    devEUIModel.msg = @"DevEUI";
    devEUIModel.textFieldTextFont = MKFont(13.f);
    devEUIModel.textFieldType = mk_hexCharOnly;
    devEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    devEUIModel.maxLength = 16;
    [self.otaaDataList addObject:devEUIModel];
    
    MKTextFieldCellModel *appEUIModel = [[MKTextFieldCellModel alloc] init];
    appEUIModel.index = 1;
    appEUIModel.msg = @"AppEUI";
    appEUIModel.textFieldTextFont = MKFont(13.f);
    appEUIModel.textFieldType = mk_hexCharOnly;
    appEUIModel.clearButtonMode = UITextFieldViewModeAlways;
    appEUIModel.maxLength = 16;
    [self.otaaDataList addObject:appEUIModel];
    
    MKTextFieldCellModel *appKeyModel = [[MKTextFieldCellModel alloc] init];
    appKeyModel.index = 5;
    appKeyModel.msg = @"AppKey";
    appKeyModel.textFieldTextFont = MKFont(13.f);
    appKeyModel.textFieldType = mk_hexCharOnly;
    appKeyModel.clearButtonMode = UITextFieldViewModeAlways;
    appKeyModel.maxLength = 32;
    [self.otaaDataList addObject:appKeyModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *regionModel = [[MKTextButtonCellModel alloc] init];
    regionModel.index = 1;
    regionModel.msg = @"Region/Subnet";
    regionModel.dataList = @[@"AS923",@"AU915",@"CN470",@"CN778",@"EU433",@"EU868",@"KR920",@"IN865",@"US915",@"RU864"];
    regionModel.buttonLabelFont = MKFont(13.f);
    [self.section2List addObject:regionModel];
    
    MKTextButtonCellModel *messageModel = [[MKTextButtonCellModel alloc] init];
    messageModel.index = 2;
    messageModel.msg = @"Message Type";
    messageModel.dataList = @[@"Unconfirmed",@"Confirmed"];
    messageModel.buttonLabelFont = MKFont(13.f);
    [self.section2List addObject:messageModel];
}

#pragma mark - 加载底部列表
- (void)loadAdvSection0List {
    MKLoRaAdvancedSettingCellModel *cellModel = [[MKLoRaAdvancedSettingCellModel alloc] init];
    [self.advSection0List addObject:cellModel];
}

- (void)loadAdvSection1List {
    MKLoRaSettingCHCellModel *cellModel = [[MKLoRaSettingCHCellModel alloc] init];
    cellModel.msg = @"CH";
    cellModel.noteMsg = @"*It is only used for US915,AU915,CN470";
    cellModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    cellModel.chLowValueList = @[@"0",@"1",@"2"];
    cellModel.chHighValueList = @[@"3",@"4",@"5"];
    [self.advSection1List addObject:cellModel];
}

- (void)loadAdvSection2List {
    MKTextSwitchCellModel *dutyModel = [[MKTextSwitchCellModel alloc] init];
    dutyModel.msg = @"Duty-cycle";
    dutyModel.noteMsg = @"*It is only used for EU868,CN779, EU433,AS923,KR920,IN865,and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.";
    dutyModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    dutyModel.index = 0;
    [self.advSection2List addObject:dutyModel];
    
    MKTextSwitchCellModel *adrModel = [[MKTextSwitchCellModel alloc] init];
    adrModel.msg = @"ADR";
    adrModel.index = 1;
    [self.advSection2List addObject:adrModel];
}

- (void)loadAdvSection3List {
    MKTextButtonCellModel *drModel = [[MKTextButtonCellModel alloc] init];
    drModel.msg = @"DR";
    drModel.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    drModel.index = 3;
    drModel.noteMsg = @"*DR only can be changed after the ADR off.";
    drModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    [self.advSection3List addObject:drModel];
    
    MKTextButtonCellModel *dellTimeModel = [[MKTextButtonCellModel alloc] init];
    dellTimeModel.msg = @"UplinkDellTime";
    dellTimeModel.dataList = @[@"0",@"1"];
    dellTimeModel.index = 4;
    dellTimeModel.noteMsg = @"*It is only used for AS923 and AU915.0: Dell Time no limit,1:Dell Time 400ms.";
    dellTimeModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    [self.advSection3List addObject:dellTimeModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"LoRa Setting";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-B", @"MKLBLoRaSettingController", @"lb_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)otaaDataList {
    if (!_otaaDataList) {
        _otaaDataList = [NSMutableArray array];
    }
    return _otaaDataList;
}

- (NSMutableArray *)abpDataList {
    if (!_abpDataList) {
        _abpDataList = [NSMutableArray array];
    }
    return _abpDataList;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (MKLBLoRaSettingModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLBLoRaSettingModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray *)advSection0List {
    if (!_advSection0List) {
        _advSection0List = [NSMutableArray array];
    }
    return _advSection0List;
}

- (NSMutableArray *)advSection1List {
    if (!_advSection1List) {
        _advSection1List = [NSMutableArray array];
    }
    return _advSection1List;
}

- (NSMutableArray *)advSection2List {
    if (!_advSection2List) {
        _advSection2List = [NSMutableArray array];
    }
    return _advSection2List;
}

- (NSMutableArray *)advSection3List {
    if (!_advSection3List) {
        _advSection3List = [NSMutableArray array];
    }
    return _advSection3List;
}

@end