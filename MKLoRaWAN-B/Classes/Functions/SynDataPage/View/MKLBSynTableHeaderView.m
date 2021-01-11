//
//  MKLBSynTableHeaderView.m
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/11.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLBSynTableHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

static CGFloat const buttonWidth = 40.f;
static CGFloat const buttonHeight = 50.f;
static CGFloat const offset_X = 15.f;
static CGFloat const buttonSpace = 10.f;

@implementation MKMsgIconButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topIcon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat iconWidth = 5.f;
    CGFloat iconHeight = 5.f;
    if (self.topIcon.image) {
        iconWidth = self.topIcon.image.size.width;
        iconHeight = self.topIcon.image.size.height;
    }
    [self.topIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(iconWidth);
        make.top.mas_equalTo(1.f);
        make.height.mas_equalTo(iconHeight);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1.f);
        make.right.mas_equalTo(-1.f);
        make.top.mas_equalTo(self.topIcon.mas_bottom).mas_offset(2.f);
        make.bottom.mas_equalTo(-1.f);
    }];
}

- (UIImageView *)topIcon {
    if (!_topIcon) {
        _topIcon = [[UIImageView alloc] init];
    }
    return _topIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(12.f);
    }
    return _msgLabel;
}

@end

@interface MKLBSynTableHeaderView ()

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *dayLabel;

@property (nonatomic, strong)UIButton *startButton;

@property (nonatomic, strong)MKMsgIconButton *synButton;

@property (nonatomic, strong)MKMsgIconButton *emptyButton;

@property (nonatomic, strong)MKMsgIconButton *exportButton;

@property (nonatomic, strong)UILabel *sumLabel;

@property (nonatomic, strong)UILabel *countLabel;

@property (nonatomic, strong)UIView *lineView;

@end

@implementation MKLBSynTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.timeLabel];
        [self addSubview:self.textField];
        [self addSubview:self.dayLabel];
        [self addSubview:self.startButton];
        [self addSubview:self.synButton];
        [self addSubview:self.emptyButton];
        [self addSubview:self.exportButton];
        [self addSubview:self.sumLabel];
        [self addSubview:self.countLabel];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.exportButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(offset_X);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.emptyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.exportButton.mas_left).mas_offset(-buttonSpace);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.synButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.emptyButton.mas_left).mas_offset(-buttonSpace);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.emptyButton.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.startButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.synButton.mas_left).mas_offset(-buttonSpace);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.synButton.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.dayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.startButton.mas_left).mas_offset(-buttonSpace);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(self.dayLabel.mas_left).mas_offset(-2.f);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.sumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(self.mas_centerX).mas_offset(-5.f);
        make.top.mas_equalTo(self.exportButton.mas_bottom).mas_offset(offset_X);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.left.mas_equalTo(self.mas_centerX).mas_offset(5.f);
        make.top.mas_equalTo(self.exportButton.mas_bottom).mas_offset(offset_X);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

#pragma mark - event method

#pragma mark - getter
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = DEFAULT_TEXT_COLOR;
        _timeLabel.font = MKFont(15.f);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.text = @"Time";
    }
    return _timeLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly textChangedBlock:^(NSString * _Nonnull text) {
            
        }];
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.maxLength = 5;
        _textField.placeholder = @"1~65535";
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = MKFont(12.f);
        _textField.textColor = DEFAULT_TEXT_COLOR;
    }
    return _textField;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textColor = DEFAULT_TEXT_COLOR;
        _dayLabel.textAlignment = NSTextAlignmentLeft;
        _dayLabel.font = MKFont(12.f);
        _dayLabel.text = @"Days";
    }
    return _dayLabel;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_startButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_startButton setBackgroundColor:UIColorFromRGB(0x2F84D0)];
        [_startButton.layer setMasksToBounds:YES];
        [_startButton.layer setCornerRadius:6.f];
        _startButton.titleLabel.font = MKFont(13.f);
    }
    return _startButton;
}

- (MKMsgIconButton *)synButton {
    if (!_synButton) {
        _synButton = [[MKMsgIconButton alloc] init];
        _synButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynTableHeaderView", @"lb_threeAxisAcceLoadingIcon.png");
        _synButton.msgLabel.text = @"Sync";
    }
    return _synButton;
}

- (MKMsgIconButton *)emptyButton {
    if (!_emptyButton) {
        _emptyButton = [[MKMsgIconButton alloc] init];
        _emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynTableHeaderView", @"lb_slot_export_deleteIcon.png");
        _emptyButton.msgLabel.text = @"Empty";
    }
    return _emptyButton;
}

- (MKMsgIconButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [[MKMsgIconButton alloc] init];
        _exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-B", @"MKLBSynTableHeaderView", @"lb_slot_export_enableIcon.png");
        _exportButton.msgLabel.text = @"Export";
    }
    return _exportButton;
}

- (UILabel *)sumLabel {
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] init];
        _sumLabel.textColor = DEFAULT_TEXT_COLOR;
        _sumLabel.textAlignment = NSTextAlignmentLeft;
        _sumLabel.font = MKFont(13.f);
        _sumLabel.text = @"Sum:N/A";
    }
    return _sumLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = DEFAULT_TEXT_COLOR;
        _countLabel.textAlignment = NSTextAlignmentLeft;
        _countLabel.font = MKFont(13.f);
        _countLabel.text = @"Count:50";
    }
    return _countLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView;
}

@end
