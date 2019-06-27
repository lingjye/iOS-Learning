//
//  AWSPaintSelectColorEasyViewDelegate.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/30.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "AWSPaintSelectColorEasyView.h"
#import "UIColor+Hex.h"

@implementation AWSPaintSelectColorEasyView
{
    NSMutableArray *colors;
    UIButton *btnClose;
    
    UIButton *lastBtnSelected;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        //最好不要超过7个，不然要重新布局
        colors = [NSMutableArray arrayWithObjects:@"#000000",@"#555555",@"#7788ee",@"#fff444",@"#3ef888", nil];
        
        [self initViews];
    }
    return self;
}


-(void)initViews{
    for (int i = 0; i<colors.count; i++) {
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.backgroundColor = [UIColor ColorWithHex:colors[i]];
        view.center = CGPointMake(20 + i*(30+15)+15, 22);
        [self addSubview:view];
        view.tag = i + 1000;
        [view addTarget:self action:@selector(colorSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    [btnClose setTitle:@"×" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:40];
    [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    
}

-(void)closeView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1.0;
    }];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    btnClose.frame = CGRectMake(self.bounds.size.width - self.bounds.size.height, 0, self.bounds.size.height, self.bounds.size.height);
}

-(void)colorSelect:(UIButton *)sender{
    UIColor *color = [UIColor ColorWithHex:colors[sender.tag-1000]];
    
    
    //选中效果
    sender.layer.borderColor = [UIColor redColor].CGColor;
    sender.layer.borderWidth = 2;
    
    if (lastBtnSelected) {
        lastBtnSelected.layer.borderWidth = 0;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(selectColorEasyViewDidSelectColor:)]) {
        [self.delegate selectColorEasyViewDidSelectColor:color];
    }
    
    lastBtnSelected = sender;
}
@end
