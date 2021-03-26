//
//  MKLBUplinkPayloadController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBUplinkPayloadController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKMixedChoiceCell.h"

#import "MKLBUplinkPayloadModel.h"

static CGFloat const sectionHeaderHeight = 55.f;

@interface MKLBUplinkPayloadController ()
<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKMixedChoiceCellDelegate,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)MKLBUplinkPayloadModel *dataModel;

@end

@implementation MKLBUplinkPayloadController

- (void)dealloc {
    NSLog(@"MKLBUplinkPayloadController销毁");
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
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MKMixedChoiceCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 2) {
        MKTextButtonCellModel *cellModel = self.section2List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 60.f;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, sectionHeaderHeight)];
        headerView.backgroundColor = RGBCOLOR(242, 242, 242);
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f,
                                                                      (sectionHeaderHeight - MKFont(20.f).lineHeight) / 2,
                                                                      kViewWidth - 30.f,
                                                                      MKFont(20.f).lineHeight)];
        msgLabel.textColor = NAVBAR_COLOR_MACROS;
        msgLabel.textAlignment = NSTextAlignmentLeft;
        if (section == 0) {
            msgLabel.text = @"Device Info Payload";
        }else if (section == 1) {
            msgLabel.text = @"Beacon Payload";
        }
        [headerView addSubview:msgLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.f,
                                                                    sectionHeaderHeight - CUTTING_LINE_HEIGHT,
                                                                    kViewWidth - 30.f,
                                                                    CUTTING_LINE_HEIGHT)];
        lineView.backgroundColor = CUTTING_LINE_COLOR;
        [headerView addSubview:lineView];
        
        return headerView;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 0.01)];
    headerView.backgroundColor = COLOR_WHITE_MACROS;
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
    if (section == 3) {
        return self.section3List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKMixedChoiceCell *cell = [MKMixedChoiceCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section3List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //devie info payload里面的输入框
        self.dataModel.deviceInfoInterval = value;
        return;
    }
    if (index == 1) {
        //Beacon Payload里面的输入框
        self.dataModel.beaconReportInterval = value;
        return;
    }
}

#pragma mark - MKMixedChoiceCellDelegate
/// 按钮的点击事件
/// @param selected YES:选中，NO:取消选中
/// @param cellIndex 当前cell所在index
/// @param buttonIndex 点击事件button所在的index
- (void)mk_mixedChoiceSubButtonEventMethod:(BOOL)selected
                                 cellIndex:(NSInteger)cellIndex
                               buttonIndex:(NSInteger)buttonIndex {
    if (cellIndex == 0) {
        //Report Data Type
        if (buttonIndex == 0) {
            //iBeacon
            self.dataModel.iBeaconIsOn = selected;
            return;
        }
        if (buttonIndex == 1) {
            //eddystone
            self.dataModel.eddystoneIsOn = selected;
            return;
        }
        if (buttonIndex == 2) {
            //unknown
            self.dataModel.unknownIsOn = selected;
            return;
        }
        return;
    }
    if (cellIndex == 1) {
        //Report Data Content
        if (buttonIndex == 0) {
            //Timestamp
            self.dataModel.timestampIsOn = selected;
            return;
        }
        if (buttonIndex == 1) {
            //MAC
            self.dataModel.macIsOn = selected;
            return;
        }
        if (buttonIndex == 2) {
            //RSSI
            self.dataModel.rssiIsOn = selected;
            return;
        }
        if (buttonIndex == 3) {
            //Broadcast Raw Data
            self.dataModel.broadcastIsOn = selected;
            return;
        }
        if (buttonIndex == 4) {
            //Response Raw Data
            self.dataModel.responseIsOn = selected;
            return;
        }
        return;
    }
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
        //Report Data Max Length
        self.dataModel.maxLenType = dataListIndex;
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Report Interval";
    cellModel.textPlaceholder = @"1~14400";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textFieldTextFont = MKFont(13.f);
    cellModel.textFieldValue = self.dataModel.deviceInfoInterval;
    cellModel.maxLength = 5;
    cellModel.unit = @"Min";
    cellModel.unitFont = MKFont(13.f);
    cellModel.unitColor = DEFAULT_TEXT_COLOR;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKMixedChoiceCellModel *typeModel = [[MKMixedChoiceCellModel alloc] init];
    typeModel.index = 0;
    typeModel.msg = @"Report Data Type";
    typeModel.dataList = [self loadTypeModelSubList];
    [self.section1List addObject:typeModel];
    
    MKMixedChoiceCellModel *contentModel = [[MKMixedChoiceCellModel alloc] init];
    contentModel.index = 1;
    contentModel.msg = @"Report Data Content";
    contentModel.dataList = [self loadContentModelSubList];
    [self.section1List addObject:contentModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.msg = @"Report Data Max Length";
    cellModel.index = 0;
    cellModel.dataList = @[@"1",@"2"];
    cellModel.dataListIndex = self.dataModel.maxLenType;
    cellModel.noteMsg = @"*Max length for one report data packet. 1: max 242 bytes; 2: max 115 bytes";
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Report Interval";
    cellModel.textPlaceholder = @"10-65535";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textFieldTextFont = MKFont(13.f);
    cellModel.textFieldValue = self.dataModel.beaconReportInterval;
    cellModel.maxLength = 5;
    cellModel.unit = @"S";
    cellModel.unitFont = MKFont(13.f);
    cellModel.unitColor = DEFAULT_TEXT_COLOR;
    [self.section3List addObject:cellModel];
}

- (NSArray <MKMixedChoiceCellButtonModel *>*)loadTypeModelSubList {
    MKMixedChoiceCellButtonModel *iBeaconModel = [[MKMixedChoiceCellButtonModel alloc] init];
    iBeaconModel.buttonIndex = 0;
    iBeaconModel.buttonMsg = @"iBeacon";
    iBeaconModel.selected = self.dataModel.iBeaconIsOn;
    
    MKMixedChoiceCellButtonModel *eddModel = [[MKMixedChoiceCellButtonModel alloc] init];
    eddModel.buttonIndex = 1;
    eddModel.buttonMsg = @"eddystone";
    eddModel.selected = self.dataModel.eddystoneIsOn;
    
    MKMixedChoiceCellButtonModel *unknownModel = [[MKMixedChoiceCellButtonModel alloc] init];
    unknownModel.buttonIndex = 2;
    unknownModel.buttonMsg = @"unknown";
    unknownModel.selected = self.dataModel.unknownIsOn;
    
    return @[iBeaconModel,eddModel,unknownModel];
}

- (NSArray <MKMixedChoiceCellButtonModel *>*)loadContentModelSubList {
    MKMixedChoiceCellButtonModel *stampModel = [[MKMixedChoiceCellButtonModel alloc] init];
    stampModel.buttonIndex = 0;
    stampModel.buttonMsg = @"Timestamp";
    stampModel.selected = self.dataModel.timestampIsOn;
    
    MKMixedChoiceCellButtonModel *macModel = [[MKMixedChoiceCellButtonModel alloc] init];
    macModel.buttonIndex = 1;
    macModel.buttonMsg = @"MAC";
    macModel.selected = self.dataModel.macIsOn;
    
    MKMixedChoiceCellButtonModel *rssiModel = [[MKMixedChoiceCellButtonModel alloc] init];
    rssiModel.buttonIndex = 2;
    rssiModel.buttonMsg = @"RSSI";
    rssiModel.selected = self.dataModel.rssiIsOn;
    
    MKMixedChoiceCellButtonModel *rawDataModel = [[MKMixedChoiceCellButtonModel alloc] init];
    rawDataModel.buttonIndex = 3;
    rawDataModel.buttonMsg = @"Broadcast Raw Data";
    rawDataModel.selected = self.dataModel.broadcastIsOn;
    
    MKMixedChoiceCellButtonModel *responseModel = [[MKMixedChoiceCellButtonModel alloc] init];
    responseModel.buttonIndex = 4;
    responseModel.buttonMsg = @"Response Raw Data";
    responseModel.selected = self.dataModel.responseIsOn;
    
    return @[stampModel,macModel,rssiModel,rawDataModel,responseModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Uplink Payload";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-B", @"MKLBUplinkPayloadController", @"lb_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKLBUplinkPayloadModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLBUplinkPayloadModel alloc] init];
    }
    return _dataModel;
}

@end
