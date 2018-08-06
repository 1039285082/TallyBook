//
//  MyView.m
//  Jisuanqi
//
//  Created by mac on 2018/7/11.
//  Copyright © 2018年 mac. All rights reserved.
//
//
//  MyView.m
//  弹出动画_demo2
//
//  Created by liman on 11/26/15.
//  Copyright © 2015 apple. All rights reserved.
//
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#import "MyView.h"
#import "UIViewExt.h"

//#import "MyViewTableViewHeadView.h"
@interface MyView()

@end
@implementation MyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    
        self.popType = PopTypeMove;
        self.moveAppearCenterY = SCREEN_HEIGHT - self.height/2;
        self.moveAppearDirection = MoveAppearDirectionFromBottom;
        self.moveDisappearDirection = MoveDisappearDirectionToBottom;
        self.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.animateDuration = 0.5;
        self.radius = 0;
        self.backgroundColor = [UIColor purpleColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapped)]];
        
    }
 
    return self;
}

#pragma mark - 重写父类
- (void)PopViewShadowTapped:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(myView:didSelectedShadow:)]) {
        [_delegate myView:self didSelectedShadow:nil];
    }
}

#pragma mark - target action
- (void)selfTapped
{
    if ([_delegate respondsToSelector:@selector(myView:didSelectedSelf:)]) {
        [_delegate myView:self didSelectedSelf:nil];
    }
}

@end
