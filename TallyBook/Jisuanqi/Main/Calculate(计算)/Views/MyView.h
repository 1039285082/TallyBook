//
//  MyView.h
//  Jisuanqi
//
//  Created by mac on 2018/7/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CalculatorPopView.h"

@class MyView;
@protocol MyViewDelegate <NSObject>

- (void)myView:(MyView *)myView didSelectedSelf:(id)sender;
- (void)myView:(MyView *)myView didSelectedShadow:(id)sender;
- (void)myView:(MyView *)myView;

@end

@interface MyView : CalculatorPopView

@property (strong,nonatomic)NSString * price;
@property (weak, nonatomic) id <MyViewDelegate> delegate;
@property (strong,nonatomic)UITableView * table;        //
@property (strong,nonatomic) XYKCaclulateModel * model;        //
//@property (strong,nonatomic)HouseLoanPopHeadView*headView;
//
@end
