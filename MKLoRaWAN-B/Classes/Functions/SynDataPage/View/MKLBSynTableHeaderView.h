//
//  MKLBSynTableHeaderView.h
//  MKLoRaWAN-B_Example
//
//  Created by aa on 2021/1/11.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MKCustomUIModule/MKTextField.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMsgIconButton : UIControl

@property (nonatomic, strong)UIImageView *topIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@interface MKLBSynTableHeaderView : UIView

@property (nonatomic, strong, readonly)MKTextField *textField;

@property (nonatomic, strong, readonly)UIButton *startButton;

@property (nonatomic, strong, readonly)MKMsgIconButton *synButton;

@property (nonatomic, strong, readonly)MKMsgIconButton *emptyButton;

@property (nonatomic, strong, readonly)MKMsgIconButton *exportButton;

@property (nonatomic, strong, readonly)UILabel *sumLabel;

@property (nonatomic, strong, readonly)UILabel *countLabel;

@end

NS_ASSUME_NONNULL_END
