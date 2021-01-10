//
//  MKLBOverLimitRssiCell.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBOverLimitRssiCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKSlider.h"

@implementation MKLBOverLimitRssiCellModel
@end

@interface MKLBOverLimitRssiCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *wifiIcon;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)MKSlider *sliderView;

@property (nonatomic, strong)UILabel *valueLabel;

@end

@implementation MKLBOverLimitRssiCell

+ (MKLBOverLimitRssiCell *)initCellWithTableView:(UITableView *)tableView {
    MKLBOverLimitRssiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLBOverLimitRssiCellIdenty"];
    if (!cell) {
        cell = [[MKLBOverLimitRssiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLBOverLimitRssiCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.wifiIcon];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.sliderView];
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(10.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.wifiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(17.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(15.f);
    }];
    [self.rssiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wifiIcon.mas_right).mas_offset(3.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.wifiIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.wifiIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.valueLabel.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.wifiIcon.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
}

#pragma mark - event method
- (void)sliderViewValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.sliderView.value];
    if ([value isEqualToString:@"-0"]) {
        value = @"0";
    }
    self.valueLabel.text = [value stringByAppendingString:@"dBm"];
    if ([self.delegate respondsToSelector:@selector(mk_overLimitRssiValueChanged:)]) {
        [self.delegate mk_overLimitRssiValueChanged:[value integerValue]];
    }
}

- (void)setDataModel:(MKLBOverLimitRssiCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.sliderView.value = _dataModel.sliderValue;
    self.valueLabel.text = [NSString stringWithFormat:@"%lddBm",(long)_dataModel.sliderValue];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Over-limit RSSI";
    }
    return _msgLabel;
}

- (UIImageView *)wifiIcon {
    if (!_wifiIcon) {
        _wifiIcon = [[UIImageView alloc] init];
        _wifiIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBOverLimitRssiCell", @"lb_wifisignalIcon.png");
    }
    return _wifiIcon;
}

- (MKSlider *)sliderView {
    if (!_sliderView) {
        _sliderView = [[MKSlider alloc] init];
        _sliderView.maximumValue = 0;
        _sliderView.minimumValue = -127;
        [_sliderView addTarget:self
                        action:@selector(sliderViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}

- (UILabel *)rssiLabel {
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc] init];
        _rssiLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiLabel.textAlignment = NSTextAlignmentLeft;
        _rssiLabel.font = MKFont(13.f);
        _rssiLabel.text = @"RSSI:";
    }
    return _rssiLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.font = MKFont(11.f);
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.text = @"-127dBm";
    }
    return _valueLabel;
}

@end
