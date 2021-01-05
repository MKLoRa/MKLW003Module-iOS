//
//  MKLBNetworkStatusCell.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBNetworkStatusCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKLBNetworkStatusCellModel
@end

@interface MKLBNetworkStatusCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKLBNetworkStatusCell

+ (MKLBNetworkStatusCell *)initCellWithTableView:(UITableView *)tableView {
    MKLBNetworkStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLBNetworkStatusCellIdenty"];
    if (!cell) {
        cell = [[MKLBNetworkStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLBNetworkStatusCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-3.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(2.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(self.msgLabel.mas_height);
    }];
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-3.f);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKLBNetworkStatusCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.statusLabel.text = SafeStr(_dataModel.statusMsg);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _msgLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = DEFAULT_TEXT_COLOR;
        _statusLabel.font = MKFont(15.f);
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = RGBCOLOR(102, 102, 102);
        _noteLabel.font = MKFont(13.f);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = @"*If Networkcheck function off, the Network status will only be valid on OTAA mode when the device in the process of join the network.";
    }
    return _noteLabel;
}

@end
