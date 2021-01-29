//
//  MKLBSynDataController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/11.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBSynDataController.h"

#import <MessageUI/MessageUI.h>

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

#import "MKBLEBaseSDKAdopter.h"

#import "MKLBDatabaseManager.h"

#import "MKLBInterface+MKLBConfig.h"
#import "MKLBCentralManager.h"

#import "MKLBSynTableHeaderView.h"
#import "MKLBSynDataCell.h"

#import "MKLBSynDataParser.h"

static NSTimeInterval const parseDataInterval = 0.10;

static NSString *synIconAnimationKey = @"synIconAnimationKey";

@interface MKLBSynDataController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKLBSynTableHeaderView *headerView;

@property (nonatomic, strong)NSMutableArray *contentList;

/// 定时解析数据
@property (nonatomic, strong)dispatch_source_t parseTimer;

/// 返回延时定时器
@property (nonatomic, strong)dispatch_source_t backTimer;

/// 是否解析完成
@property (nonatomic, assign)BOOL parseComplete;

/// 点击了返回按钮，先发送暂停命令给设备，然后2s中没有需要解析的数据了，认为可用返回了
@property (nonatomic, assign)NSInteger backCount;

@end

@implementation MKLBSynDataController

- (void)dealloc {
    NSLog(@"MKLBSynDataController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
    if (self.backTimer) {
        dispatch_cancel(self.backTimer);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromLocal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTrackerDatas:)
                                                 name:mk_lb_receiveStorageDataNotification
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    self.headerView.synButton.msgLabel.text = @"SYNC";
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKLBInterface lb_pauseSendLocalData:YES sucBlock:^{
        [self startBackTimer];
    } failedBlock:^(NSError * _Nonnull error) {
        [self startBackTimer];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *pageModel = self.dataList[indexPath.row];
    return [MKLBSynDataCell fetchCellHeight:pageModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKLBSynDataCell *cell = [MKLBSynDataCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - note
- (void)receiveTrackerDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSString *content = dic[@"content"];
    if (!ValidStr(content)) {
        return;
    }
    NSInteger number = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(8, 2)];
    if (number == 0) {
        //最后一条数据
        self.headerView.sumLabel.text = [NSString stringWithFormat:@"Sum:%@",[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)]];
        return;
    }
    [self.contentList addObject:content];
}

#pragma mark - event method
- (void)startButtonPressed {
    if (!ValidStr(self.headerView.textField.text)
        || [self.headerView.textField.text integerValue] < 1
        || [self.headerView.textField.text integerValue] > 65535) {
        [self.view showCentralToast:@"Time must be 1 ~ 65535"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKLBInterface lb_readNumberOfDaysStoredData:[self.headerView.textField.text integerValue] sucBlock:^{
        [[MKHudManager share] hide];
        [self startButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)synButtonPressed {
    [self syncButtonStateUpdate];
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKLBInterface lb_pauseSendLocalData:!self.headerView.synButton.selected sucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)emptyButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKLBInterface lb_clearAllDatasWithSucBlock:^{
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        [self.contentList removeAllObjects];
        if (self.parseTimer) {
            dispatch_cancel(self.parseTimer);
        }
        self.headerView.sumLabel.text = @"Sum:0";
        self.headerView.countLabel.text = @"Count:0";
        [MKLBDatabaseManager clearDataTable];
        [self.tableView reloadData];
        [self emptyButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)exportButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
        return;
    }
    if (!ValidArray(self.dataList)) {
        [self.view showCentralToast:@"No data to send"];
        return;
    }
    NSArray *list = [self.dataList mutableCopy];
    NSMutableData *emailData = [NSMutableData data];
    for (NSDictionary *dic in list) {
        NSString *timeString = @"Time: N/A";
        NSString *macString = @"MAC: N/A";
        NSString *rssi = @"RSSI: N/A";
        NSString *rawData = @"Raw Data: N/A";
        if (ValidDict(dic[@"dateDic"])) {
            NSString *time = [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@",dic[@"dateDic"][@"year"],dic[@"dateDic"][@"month"],dic[@"dateDic"][@"day"],dic[@"dateDic"][@"hour"],dic[@"dateDic"][@"minute"],dic[@"dateDic"][@"second"]];
            timeString = [@"Time: " stringByAppendingString:time];
        }
        if (ValidStr(dic[@"macAddress"])) {
            macString = [@"MAC: " stringByAppendingString:dic[@"macAddress"]];
        }
        if (ValidNum(dic[@"rssi"])) {
            NSString *tempRssi = [NSString stringWithFormat:@"%ld",(long)[dic[@"rssi"] integerValue]];
            rssi = [NSString stringWithFormat:@"%@%@%@",@"RSSI: ",tempRssi,@"dBm"];
        }
        if (ValidStr(dic[@"rawData"])) {
            rawData = [@"Raw Data: " stringByAppendingString:dic[@"rawData"]];
        }
        NSString *stringToWrite = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@",timeString,macString,rssi,rawData];
        NSData *stringData = [stringToWrite dataUsingEncoding:NSUTF8StringEncoding];
        [emailData appendData:stringData];
    }
    if (!ValidData(emailData)) {
        [self.view showCentralToast:@"Log data error"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:emailData
                           mimeType:@"application/txt"
                           fileName:@"LoRaWAN-B Data.txt"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - 数据库
- (void)readDataFromLocal {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKLBDatabaseManager readDataListWithSucBlock:^(NSArray<NSDictionary *> * _Nonnull dataList) {
        [[MKHudManager share] hide];
        [self.dataList addObjectsFromArray:dataList];
        [self processStatus];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)processStatus {
    self.headerView.countLabel.text = [NSString stringWithFormat:@"%@ %ld",@"Count:",(long)self.dataList.count];
    
    if (self.dataList.count > 0) {
        //如果本地有数据存储，则start按钮不可用,sync按钮和empty、export按钮可用
        self.headerView.startButton.enabled = NO;
        [self.headerView.startButton setBackgroundColor:[UIColor grayColor]];
        [self.headerView.startButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        
    }else {
        //本地没有存储数据，则start、empty和export可用，sync不可用
        [self.headerView.startButton setBackgroundColor:UIColorFromRGB(0x2F84D0)];
        [self.headerView.startButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        self.headerView.synButton.enabled = NO;
        self.headerView.synButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_sync_disableIcon.png");
    }
    
    [self.tableView reloadData];
}

#pragma mark - 按钮刷新UI事件

- (void)startButtonMethod {
    //用户发送给设备开始读取数据了
    //start按钮置灰、empty、export都不可用
    self.headerView.startButton.enabled = NO;
    [self.headerView.startButton setBackgroundColor:[UIColor grayColor]];
    [self.headerView.startButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    
    self.headerView.emptyButton.enabled = NO;
    self.headerView.emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_delete_disableIcon.png");
    
    self.headerView.exportButton.enabled = NO;
    self.headerView.exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_export_disableIcon.png");
    
    //sync按钮可用，选中状态，开启动画
    self.headerView.synButton.enabled = YES;
    self.headerView.synButton.selected = YES;
    self.headerView.synButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_sync_enableIcon.png");
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    //开始旋转
    [self.headerView.synButton.topIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:synIconAnimationKey];
    self.headerView.synButton.msgLabel.text = @"STOP";
    [self addTimerForRefresh];
}

- (void)syncButtonStateUpdate {
    self.headerView.synButton.selected = !self.headerView.synButton.selected;
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    if (self.headerView.synButton.selected) {
        //如果监听数据，start按钮置灰、empty、export都不可用
        self.headerView.emptyButton.enabled = NO;
        self.headerView.emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_delete_disableIcon.png");
        
        self.headerView.exportButton.enabled = NO;
        self.headerView.exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_export_disableIcon.png");
        
        //开始旋转
        [self.headerView.synButton.topIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:synIconAnimationKey];
        self.headerView.synButton.msgLabel.text = @"STOP";
        [self addTimerForRefresh];
    }else {
        //停止监听数据，empty、export都可用
        self.headerView.emptyButton.enabled = YES;
        self.headerView.emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_delete_enableIcon.png");
        
        self.headerView.exportButton.enabled = YES;
        self.headerView.exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_export_enableIcon.png");
        
        self.headerView.synButton.msgLabel.text = @"SYNC";
        if (self.parseTimer) {
            dispatch_cancel(self.parseTimer);
            self.parseTimer = nil;
        }
    }
}

- (void)emptyButtonMethod {
    
    [self.headerView.startButton setBackgroundColor:UIColorFromRGB(0x2F84D0)];
    [self.headerView.startButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
    self.headerView.startButton.enabled = YES;
    
    self.headerView.synButton.enabled = NO;
    self.headerView.synButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_sync_disableIcon.png");
    
    self.headerView.emptyButton.enabled = YES;
    self.headerView.emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_delete_enableIcon.png");
    
    self.headerView.exportButton.enabled = YES;
    self.headerView.exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynDataController", @"lb_export_enableIcon.png");
}

- (void)startBackTimer {
    self.backTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.backTimer, dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),  0.5 * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.backTimer, ^{
        __strong typeof(self) sself = weakSelf;
        sself.backCount ++;
        if (sself.backCount == 4) {
            //数据全部解析完成,把所有数据缓存到本地
            moko_dispatch_main_safe(^{
                dispatch_cancel(sself.backTimer);
                [sself saveDataToLocal];
            });
            return;
        }
    });
    dispatch_resume(self.backTimer);
}

- (void)saveDataToLocal {
    [MKLBDatabaseManager clearDataTable];
    if (self.dataList.count == 0) {
        [[MKHudManager share] hide];
        [super leftButtonMethod];
        return;
    }
    [MKLBDatabaseManager insertDataList:self.dataList sucBlock:^{
        [[MKHudManager share] hide];
        [super leftButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 刷新
- (void)addTimerForRefresh {
    self.parseTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.parseTimer, dispatch_time(DISPATCH_TIME_NOW, parseDataInterval * NSEC_PER_SEC),  parseDataInterval * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.parseTimer, ^{
        __strong typeof(self) sself = weakSelf;
        moko_dispatch_main_safe(^{
            [sself parseContentDatas];
        });
    });
    dispatch_resume(self.parseTimer);
}

- (void)parseContentDatas {
    if (self.contentList.count == 0) {
        self.parseComplete = YES;
        return;
    }
    self.parseComplete = NO;
    self.backCount = 0;
    NSString *firstContent = self.contentList[0];
    NSArray *tempList = [MKLBSynDataParser parseScannerTrackedData:firstContent];
    [self.contentList removeObjectAtIndex:0];
    if (self.dataList.count == 0) {
        [self.dataList addObjectsFromArray:tempList];
    }else {
        for (NSDictionary *dic in tempList) {
            [self.dataList insertObject:dic atIndex:0];
        }
    }
    self.headerView.countLabel.text = [NSString stringWithFormat:@"Count: %ld",(long)self.dataList.count];
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Local Data Sync";
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
        
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray array];
    }
    return _contentList;
}

- (MKLBSynTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKLBSynTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100.f)];
        [_headerView.startButton addTarget:self
                                    action:@selector(startButtonPressed)
                          forControlEvents:UIControlEventTouchUpInside];
        [_headerView.synButton addTarget:self
                                  action:@selector(synButtonPressed)
                        forControlEvents:UIControlEventTouchUpInside];
        [_headerView.emptyButton addTarget:self
                                    action:@selector(emptyButtonPressed)
                          forControlEvents:UIControlEventTouchUpInside];
        [_headerView.exportButton addTarget:self
                                     action:@selector(exportButtonPressed)
                           forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

@end
