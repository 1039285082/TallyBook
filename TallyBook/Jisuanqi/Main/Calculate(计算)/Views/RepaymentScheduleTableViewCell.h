//
//  RepaymentScheduleTableViewCell.h
//  HaiLuoQianBao
//
//  Created by mac on 2018/7/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepaymentScheduleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *periodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *benLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *repayLabel;

@end
