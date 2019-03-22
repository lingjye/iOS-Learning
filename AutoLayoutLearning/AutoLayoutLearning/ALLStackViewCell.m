//
//  ALLStackViewCell.m
//  AutoLayoutLearning
//
//  Created by txooo on 2019/3/21.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ALLStackViewCell.h"

@interface ALLStackViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation ALLStackViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat margin = 10, pidding = 5;
    
    _iconView = ({
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"icon"];
        // 设置抗压缩 水平+竖直
        [iconView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [iconView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        // 设置抗拉伸
        [iconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [iconView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        iconView;
    });
    _titleLabel = ({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"名称名称名称名称名称名称名称名称名称名称名称名称名称名称名称";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = UIColor.redColor;
        titleLabel.numberOfLines = 2;
        titleLabel;
    });
    _dateLabel = ({
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.text = @"日期";
        dateLabel.textColor = UIColor.lightGrayColor;
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.backgroundColor = UIColor.orangeColor;
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
        button;
    });
    _messageLabel = ({
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.text = @"更新内容:\n1.更新了一些功能.\n2.提升用户体验";
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = UIColor.cyanColor;
        messageLabel;
    });
    _versionLabel = ({
        UILabel *versionLabel = [[UILabel alloc] init];
        versionLabel.font = [UIFont systemFontOfSize:15];
        versionLabel.textColor = UIColor.lightGrayColor;
        versionLabel.backgroundColor = UIColor.greenColor;
        versionLabel.text = @"版本";
        versionLabel;
    });

    // 最外层stackview
    UIStackView *backStackView = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        // 使用AutoLayout需要设置为false, iOS系统会自动将frame位置转换为约束布局，否则添加的约束无效
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.spacing = pidding;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView;
    });

    // 第一部分 (icon + (title,date) + update)
    UIStackView *topStackView = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.alignment = UIStackViewAlignmentTop;
        stackView.distribution = UIStackViewDistributionFill;
        stackView.spacing = pidding;
        stackView;
    });

    UIStackView *titleStackView = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.spacing = pidding;
        stackView;
    });

    [titleStackView addArrangedSubview:_titleLabel];
    [titleStackView addArrangedSubview:_dateLabel];

    [topStackView addArrangedSubview:_iconView];
    [topStackView addArrangedSubview:titleStackView];
    [topStackView addArrangedSubview:_updateButton];

    [backStackView addArrangedSubview:topStackView];
    // 第二部分 (message + version)
    UIStackView *bottomStack = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionFillProportionally;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.spacing = pidding;
        stackView;
    });
    [backStackView addArrangedSubview:bottomStack];

    [bottomStack addArrangedSubview:_messageLabel];
    [bottomStack addArrangedSubview:_versionLabel];

    [self.contentView addSubview:backStackView];

    // 为添加backStackView约束 上下左右距父视图边距都为10
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint
        constraintWithItem:backStackView
                 attribute:NSLayoutAttributeTop
                 relatedBy:NSLayoutRelationEqual
                    toItem:self.contentView
                 attribute:NSLayoutAttributeTop
                multiplier:1
                  constant:margin];
    NSLayoutConstraint *constraintLeading = [NSLayoutConstraint
        constraintWithItem:backStackView
                 attribute:NSLayoutAttributeLeading
                 relatedBy:NSLayoutRelationEqual
                    toItem:self.contentView
                 attribute:NSLayoutAttributeLeading
                multiplier:1
                  constant:margin];
    NSLayoutConstraint *constraintTrailing = [NSLayoutConstraint
        constraintWithItem:backStackView
                 attribute:NSLayoutAttributeTrailing
                 relatedBy:NSLayoutRelationEqual
                    toItem:self.contentView
                 attribute:NSLayoutAttributeTrailing
                multiplier:1
                  constant:-margin];
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint
        constraintWithItem:backStackView
                 attribute:NSLayoutAttributeBottom
                 relatedBy:NSLayoutRelationEqual
                    toItem:self.contentView
                 attribute:NSLayoutAttributeBottom
                multiplier:1
                  constant:-margin];
    // 必须添加到superview(self.contentView)上, 而不是subview(此处的backStackView)
    [self.contentView addConstraints:@[ constraintTop,
                                        constraintLeading,
                                        constraintTrailing,
                                        constraintBottom ]];
    
    /*
     // VFL实现
     // 为添加backStackView约束, 上下左右边距为10
     NSString *hvfl = @"|-margin-[backStackView]-margin-|";
     NSString *vvfl = @"V:|-margin-[backStackView]-margin-|";
     NSDictionary *metrics = @{ @"margin" : @10 };
     // NSDictionaryOfVariableBindings(v1, v2, v3) 等同于 @{ @"v1" : v1, @"v2" : v2 }
     NSDictionary *views = NSDictionaryOfVariableBindings(backStackView);
     NSArray *hConstraints = [NSLayoutConstraint
     constraintsWithVisualFormat:hvfl
     options:NSLayoutFormatAlignAllLeft
     metrics:metrics
     views:views];
     NSArray *vConstraints = [NSLayoutConstraint
     constraintsWithVisualFormat:vvfl
     options:NSLayoutFormatAlignAllTop
     metrics:metrics
     views:views];
     
     [self.contentView addConstraints:hConstraints];
     [self.contentView addConstraints:vConstraints];
     */
}

- (void)updateAction:(UIButton *)button {
    NSLog(@"更新");
}

- (void)setMessage:(NSString *)message {
    _messageLabel.text = message;
}

@end
