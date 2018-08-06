//
//  waitingDeliveryController.m
//  DWQListOfDifferentOrderStatus
//
//  Created by 杜文全 on 15/11/1.
//  Copyright © 2015年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import "waitingDeliveryController.h"
#import "FenqiViewController.h"

@interface waitingDeliveryController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSArray  * dataArr;        //tableview每行显示
@property (strong,nonatomic)UITextField * jkTextFiled;  //借款输入框
@property (strong,nonatomic)UITextField * jkMonthTextFiled;  //借款月数输入框
@property (strong,nonatomic)UITextField * jkRateTextFiled;  //借款利率输入框

@property (strong,nonatomic)XYKCaclulateModel * resultModel;        //计算结果模型
@end

@implementation waitingDeliveryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    //滚动时收起键盘
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //点击tableview时隐藏键盘
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    
    tableViewGesture.numberOfTapsRequired = 1;
    
    tableViewGesture.cancelsTouchesInView = NO;
    
    [self.tableView addGestureRecognizer:tableViewGesture];
    
     _dataArr=@[@"借款金额(元)",@"借款期限",@"年利率",@"还款方式"];
 
    
   
   
    
    
    
    
    _tableView.sectionHeaderHeight = 0.01;
    _tableView.sectionFooterHeight = 0.01;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    UILabel *label=[[UILabel alloc]init];
    label.text=@"请输入分期信息";
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.mas_equalTo(20);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
    _tableView.tableHeaderView =view;
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    UIButton *button=[[UIButton alloc]init];
    //    button.frame=CGRectMake(0, 0,self.tableView.frame.size.width-40, 44);
    [button setTitle:@"开始计算" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickCalcBtn) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:KBackgroundColor];
    button.layer.cornerRadius=5;
    button.layer.masksToBounds=YES;
    [view1 addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view1.mas_centerX);
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.width.equalTo(@(KScreenWidth-40));
        make.height.equalTo(@44);
        
    }];
    
    self.tableView.tableFooterView=view1;
   
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    
    UITableViewCell *cell=[UITableViewCell new];
    cell.textLabel.text=_dataArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([cell.textLabel.text isEqualToString:@"借款金额(元)"]) {
        _jkTextFiled=[[UITextField alloc]init];
        _jkTextFiled.placeholder=@"请输入借款金额";
        _jkTextFiled.font=[UIFont systemFontOfSize:14];
        _jkTextFiled.keyboardType=UIKeyboardTypeNumberPad;
        _jkTextFiled.textAlignment=NSTextAlignmentRight;
        
        [cell.contentView addSubview:_jkTextFiled];
        [_jkTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
        
        
    }
    if ([cell.textLabel.text isEqualToString:@"借款期限"]) {
        _jkMonthTextFiled=[[UITextField alloc]init];
        //        _lcMonthTextField.placeholder=@"请输入金额";
        _jkMonthTextFiled.font=[UIFont systemFontOfSize:14];
        _jkMonthTextFiled.keyboardType=UIKeyboardTypeNumberPad;
        _jkMonthTextFiled.textAlignment=NSTextAlignmentRight;
        _jkMonthTextFiled.borderStyle=UITextBorderStyleLine;
        _jkMonthTextFiled.layer.borderColor=[RGBA(19, 99, 254, 1) CGColor];
        _jkMonthTextFiled.layer.borderWidth=1.0;
        _jkMonthTextFiled.layer.masksToBounds=YES;
        
        [cell.contentView addSubview:_jkMonthTextFiled];
        [_jkMonthTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-40);
            make.width.equalTo(@50);
            make.height.equalTo(@25);
        }];
        
        UILabel *label=[[UILabel alloc]init];
        label.text=@"个月";
        label.font=[UIFont systemFontOfSize:14];
        [label sizeToFit];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            
            
        }];
        
    }
    if ([cell.textLabel.text isEqualToString:@"年利率"]) {
        _jkRateTextFiled=[[UITextField alloc]init];
        //        _lcMonthTextField.placeholder=@"请输入金额";
        _jkRateTextFiled.font=[UIFont systemFontOfSize:14];
        _jkRateTextFiled.keyboardType=UIKeyboardTypeNumberPad;
        _jkRateTextFiled.textAlignment=NSTextAlignmentRight;
        _jkRateTextFiled.borderStyle=UITextBorderStyleLine;
        _jkRateTextFiled.layer.borderColor=[RGBA(19, 99, 254, 1) CGColor];
        _jkRateTextFiled.layer.borderWidth=1.0;
        _jkRateTextFiled.layer.masksToBounds=YES;
        
        [cell.contentView addSubview:_jkRateTextFiled];
        [_jkRateTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-40);
            make.width.equalTo(@50);
            make.height.equalTo(@25);
        }];
        
        UILabel *label=[[UILabel alloc]init];
        label.text=@"%";
        label.font=[UIFont systemFontOfSize:14];
        [label sizeToFit];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            
            
        }];
        
    }
    if ([cell.textLabel.text isEqualToString:@"还款方式"]){
        UILabel *label=[[UILabel alloc]init];
      
        label.font=[UIFont systemFontOfSize:14];
        label.textAlignment=NSTextAlignmentRight;
        label.text=@"每月还款";
        
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            make.width.equalTo(@100);
            make.height.equalTo(@25);
        }];
        
        
    }
    

    
    
    
    
    return  cell;
    
    
    
    
    
    
}
//model.businessRate=[_syRateLabel.text doubleValue];
//model.businessTotalPrice=[_syTextFiled.text doubleValue]*10000.0;
//_resultModel=[XYKCalculator calculateBusinessAsEqualPriceWithCalModel:model];




- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
//
-(void)didClickCalcBtn{
    
    _resultModel=[XYKCaclulateModel new];
    XYKCaclulateModel *model=[XYKCaclulateModel new];
    
    model.businessRate=[_jkRateTextFiled.text doubleValue];
    model.businessTotalPrice=[_jkTextFiled.text doubleValue];
    model.Year=[_jkMonthTextFiled.text doubleValue]/12;
    
    _resultModel=[XYKCalculator calculateBusinessAsInterestWithCalModel:model];
    FenqiViewController *vc=[[FenqiViewController alloc]init];
    vc.model=_resultModel;
    
    [self.navigationController pushViewController:vc animated:YES];
    
 
}
//收起键盘
- (void)commentTableViewTouchInSide{
    
    [self.jkTextFiled resignFirstResponder];
    [self.jkMonthTextFiled resignFirstResponder];
    [self.jkRateTextFiled resignFirstResponder];
}
@end
