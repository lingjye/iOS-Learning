//
//  ALLMasonryViewCell.m
//  AutoLayoutLearning
//
//  Created by txooo on 2019/3/22.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ALLMasonryViewCell.h"
#import "Masonry.h"

@interface ALLMasonryViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation ALLMasonryViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubviews];
    }
    return self;
}

- (void)updateConstraints {
    CGFloat margin = 10, pidding = 5;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(margin);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(pidding);
        make.right.equalTo(self.updateButton.mas_left).offset(pidding);
        make.top.mas_equalTo(self.iconView);
    }];
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView);
        make.right.mas_offset(-margin);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(pidding);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView);
        make.right.mas_offset(-margin);
        make.top.equalTo(self.iconView.mas_bottom).offset(pidding);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.messageLabel);
        make.bottom.mas_offset(-margin);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(pidding);
    }];
    [super updateConstraints];
}

- (void)configSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _iconView = ({
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"icon"];
        [iconView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [iconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [iconView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        iconView.translatesAutoresizingMaskIntoConstraints = false;
        iconView;
    });
    _titleLabel = ({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"名称名称名称名称名称名称名称名称名称名称名称名称名称名称名称";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = UIColor.redColor;
        titleLabel.numberOfLines = 2;
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel;
    });
    _dateLabel = ({
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.text = @"日期";
        dateLabel.textColor = UIColor.lightGrayColor;
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.backgroundColor = UIColor.orangeColor;
        dateLabel.translatesAutoresizingMaskIntoConstraints = false;
        dateLabel;
    });
    _updateButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [button setTitle:@"我是更新" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:UIColor.yellowColor];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        button.translatesAutoresizingMaskIntoConstraints = false;
        button;
    });
    _messageLabel = ({
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.text = @"更新内容:\n1.更新了一些功能.\n2.提升用户体验";
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = UIColor.cyanColor;
        messageLabel.translatesAutoresizingMaskIntoConstraints = false;
        messageLabel;
    });
    _versionLabel = ({
        UILabel *versionLabel = [[UILabel alloc] init];
        versionLabel.font = [UIFont systemFontOfSize:15];
        versionLabel.textColor = UIColor.lightGrayColor;
        versionLabel.backgroundColor = UIColor.greenColor;
        versionLabel.text = @"版本";
        versionLabel.translatesAutoresizingMaskIntoConstraints = false;
        versionLabel;
    });
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_dateLabel];
    [self.contentView addSubview:_updateButton];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_versionLabel];
    
    [self updateConstraintsIfNeeded];
}

- (void)updateAction:(UIButton *)button {
    NSLog(@"更新");
}

- (void)setMessage:(NSString *)message {
    _messageLabel.text = message;
}
@end
