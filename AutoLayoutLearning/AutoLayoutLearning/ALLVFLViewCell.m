//
//  ALLVFLViewCell.m
//  AutoLayoutLearning
//
//  Created by txooo on 2019/3/21.
//  Copyright © 2019 txooo. All rights reserved.
//

/*
 说明                 表达式
 水平方向               H:
 垂直方向               V:
 SuperView             |
 Views                [view]
 关系                  >=,==,<=
 空间,间隙              -
 优先级                @value
 */

/*
 示例
 == 表示视图间距,宽度或高度必须等于某个值
 >= 表示视图间距,宽度或高度必须大于或等于某个值
 <= 表示试图间距,宽度或高度必须小于或等于某个值
 @  表示数值为多少
 |-[view]-| 视图处在父视图的左右或上下边缘m内
 |-[view]   视图在父视图左边缘
 |[view]    视图和父视图左边对齐
 -[view]-   设置视图的宽高
 |-margin-[view]-margin-|   设置离父视图左右或上下边距为margin
 [view(value)]  设置视图的宽或高为value
 |-[view(view1)]-[view1]-|   表示视图宽度或高度一样,并且在父视图内
 V:|-[view(value)]  视图高度为value
 H:|-[view(value)]  视图宽度为value
 V:|-(==padding)-[view1]->=0-[view2]-(==padding)-|
    表示离父视图的距离为padding,这两个视图间距必须大于或等于0并且跟底部父视图距离为padding
 [view(>=60@700)]   视图宽度为至少60且不能超过700
 注意:如果没有声明方向,默认为水平 H:
 
 metrics    表达式中用到的变量进行赋值
 如:
 表达式    |-margin-[view]
 metrics  metrics = @{ margin : @10 }
 表示view距父视图左边距为10
 */

#import "ALLVFLViewCell.h"

@interface ALLVFLViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation ALLVFLViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubviews];
    }
    return self;
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
    
    [self addConstraintsForIconView:_iconView titleLabel:_titleLabel dateLabel:_dateLabel updateButton:_updateButton messageLabel:_messageLabel versionLabel:_versionLabel];
}

- (void)addConstraintsForIconView:(UIImageView *)iconView
                       titleLabel:(UILabel *)titleLabel
                        dateLabel:(UILabel *)dateLabel
                     updateButton:(UIButton *)updateButton
                     messageLabel:(UILabel *)messageLabel
                     versionLabel:(UILabel *)versionLabel {
    
    NSDictionary *metrics = @{ @"margin" : @10,
                               @"pidding" : @5
                               };
    NSDictionary *views = NSDictionaryOfVariableBindings(iconView, titleLabel, dateLabel, updateButton, messageLabel, versionLabel);
    // 水平 icon + title + update
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-margin-[iconView]-pidding-[titleLabel(==dateLabel)]-pidding-[updateButton]-margin-|"
                                      options:0
                                      metrics:metrics
                                      views:views]];
    // 竖直 title
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-margin-[titleLabel]"
                                      options:0
                                      metrics:metrics
                                      views:views]];
    // 竖直 update
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-margin-[updateButton]"
                                      options:0
                                      metrics:metrics
                                      views:views]];
    // 水平 date
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-margin-[iconView]-pidding-[dateLabel]"
                                      options:0
                                      metrics:metrics
                                      views:views]];
//     竖直date
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-margin-[titleLabel]-pidding-[dateLabel]"
                                      options:0
                                      metrics:metrics
                                      views:views]];
    // 水平 message
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-margin-[messageLabel]-margin-|"
                                      options:0
                                      metrics:metrics
                                      views:views]];
    // 水平 version
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-margin-[versionLabel]-margin-|"
                                      options:0
                                      metrics:metrics
                                      views:views]];
    // 竖直 icon + message + version
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-margin-[iconView]-pidding-[messageLabel]-pidding-[versionLabel]-margin-|"
                                      options:0
                                      metrics:metrics
                                      views:views]];
}

- (void)updateAction:(UIButton *)button {
    NSLog(@"更新");
}

- (void)setMessage:(NSString *)message {
    _messageLabel.text = message;
}

@end
