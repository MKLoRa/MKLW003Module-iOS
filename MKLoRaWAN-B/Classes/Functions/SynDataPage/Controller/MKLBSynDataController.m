//
//  MKLBSynDataController.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/11.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBSynDataController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextField.h"

#import "MKLBSynTableHeaderView.h"
#import "MKLBSynDataCell.h"

@interface MKLBSynDataController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKLBSynTableHeaderView *headerView;

@end

@implementation MKLBSynDataController

- (void)dealloc {
    NSLog(@"MKLBSynDataController销毁");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
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

#pragma mark - event method
- (void)startButtonPressed {
    
}

- (void)synButtonPressed {
    
}

- (void)emptyButtonPressed {
    
}

- (void)exportButtonPressed {
    
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
