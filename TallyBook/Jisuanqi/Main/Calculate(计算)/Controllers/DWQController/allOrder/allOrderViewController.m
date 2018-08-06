//
//  allOrderViewController.m
//  DWQListOfDifferentOrderStatus
//
//  Created by 杜文全 on 15/11/1.
//  Copyright © 2015年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import "allOrderViewController.h"
#import "PopView.h"
#import "MyView.h"
#import "LiCaiViewController.h"
@interface allOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,MyViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSArray  * dataArr;        //tableview每行显示
@property (strong,nonatomic)UITextField * ckTextField;        //存款金额输入

@property (strong,nonatomic)UITextField * lcTextField;        //理财金额输入
@property (strong,nonatomic)UITextField * lcMonthTextField;   //理财月数出入框

@property (strong,nonatomic)NSArray * depositingModeArr;        //存款方式

@property (strong,nonatomic)NSString * lcRepayType;                //理财还款方式
@property (strong,nonatomic)NSArray * lcRepayTypeArr;               //理财还款数组
@property (strong,nonatomic)UILabel * lcRepayTypeLabel;              //理财还款label



@property (strong,nonatomic)UITextField * yearRateTextField;        //年利率输入框
@property (strong,nonatomic)UITextField * lcRateTextField;        //理财年利率输入框
//@property (strong,nonatomic)NSArray * yearRateDataArr;        //年利率
@property (strong,nonatomic)NSDictionary * yearRateDataDic;        //年利率字典



/** pickerView */
/** 存款期限期限 */
@property (strong,nonatomic)UIPickerView * pickerView;        //存款期限pickerView
@property (strong,nonatomic)NSArray * pickerViewDataArr;        //pickerView数据源
@property (strong,nonatomic)NSString  * selectPicerViewStr;        //pickerView选择的值
@property (strong,nonatomic)NSArray * ckRateArr;                      //存款利率数据源
//计算参数

@property (strong,nonatomic)NSString * depositingType;        //存款方式
@property (strong,nonatomic)UILabel * yearLabel;        //存款期限label
@property (strong,nonatomic)XYKCaclulateModel * resultModel;        //计算结果模型
/** popView*/
@property (strong,nonatomic)PopView *popView;
@property (strong,nonatomic)MyView * myView;      


@end

@implementation allOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.segmentControl.frame.size.height+self.segmentControl.frame.origin.y, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
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
    
    
    
    [self.segmentControl setSelectedSegmentIndex:0];
     [self.segmentControl addTarget:self action:@selector(didClickLCSegmentControl) forControlEvents:UIControlEventValueChanged];
    
    _dataArr=@[@"存款金额(元)",@"存款类型",@"存款期限",@"年利率(%)"];
    _depositingModeArr=@[@"活期",@"定期"];
    
    _ckRateArr=@[@"3个月",@"6个月",@"1年",@"2年",@"3年",@"5年"];
//    _yearRateDataArr=@[@"1.10",@"1.30",@"1.50",@"2.10",@"2.75",@"2.75"];
    _yearRateDataDic=@{@"3个月":@"1.10",
                       @"6个月":@"1.30",
                        @"1年":@"1.50",
                        @"2年":@"2.10",
                        @"3年":@"2.75",
                        @"5年":@"2.75",
                       };
    _lcRepayTypeArr=@[@"按月付息到期还本",@"一次性还本付息"];
    
    
    
    _tableView.sectionHeaderHeight = 0.01;
    _tableView.sectionFooterHeight = 0.01;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    UILabel *label=[[UILabel alloc]init];
    label.text=@"请输入理财信息";
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
#pragma - mark tableview代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    
    UITableViewCell *cell=[UITableViewCell new];
    cell.textLabel.text=_dataArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    if ([cell.textLabel.text isEqualToString:@"贷款年限"]) {
//        UISegmentedControl *seg=[[UISegmentedControl alloc]initWithItems:_yearArr];
//        [seg setSelectedSegmentIndex:0];
//        NSString *yearStr=[NSString stringWithFormat:@"%@",_yearArr[seg.selectedSegmentIndex]];
//        _year=[yearStr floatValue];
//        [seg addTarget:self action:@selector(didClickYearSeg:) forControlEvents:UIControlEventValueChanged];
//        
//        [cell.contentView addSubview:seg];
//        
//        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(cell.contentView.mas_centerY);
//            make.right.mas_equalTo(-10);
//            make.width.equalTo(@200);
//            make.height.equalTo(@30);
//            
//            
//        }];
//        
//    }
    if ([cell.textLabel.text isEqualToString:@"存款类型"]) {
        UISegmentedControl *seg=[[UISegmentedControl alloc]initWithItems:_depositingModeArr];
        [seg setSelectedSegmentIndex:0];
        [seg addTarget:self action:@selector(didClickRepaymentModeSeg:) forControlEvents:UIControlEventValueChanged];
        UIFont *font = [UIFont systemFontOfSize:14.0f];   // 设置字体大小
        _depositingType=_depositingModeArr[seg.selectedSegmentIndex];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        [seg setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        [cell.contentView addSubview:seg];
        
        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            make.width.equalTo(@150);
            make.height.equalTo(@30);
        }];
        
    }
    if ([cell.textLabel.text isEqualToString:@"存款金额(元)"]){
        _ckTextField=[[UITextField alloc]init];
        _ckTextField.placeholder=@"请输入金额";
        _ckTextField.font=[UIFont systemFontOfSize:14];
        _ckTextField.keyboardType=UIKeyboardTypeNumberPad;
        _ckTextField.textAlignment=NSTextAlignmentRight;
        
        [cell.contentView addSubview:_ckTextField];
        [_ckTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            make.width.equalTo(@75);
            make.height.equalTo(@30);
        }];
        
        
    }

    if ([cell.textLabel.text isEqualToString:@"存款期限"]){
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        _yearLabel=[[UILabel alloc]init];

        if (_selectPicerViewStr==nil) {
            _selectPicerViewStr=[_ckRateArr objectAtIndex:0];
        }
        
        _yearLabel.text=_selectPicerViewStr;
        _yearLabel.font=[UIFont systemFontOfSize:14];
        _yearLabel.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:_yearLabel];
        [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(0);
            make.width.equalTo(@75);
            make.height.equalTo(@30);
        }];
        
    }
    if ([cell.textLabel.text isEqualToString:@"年利率(%)"]) {
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        _yearRateTextField=[[UITextField alloc]init];
        
        if ([_depositingType isEqualToString:@"活期"]) {
            _yearRateTextField.text=@"0.35";
            
        }
        if ([_depositingType isEqualToString:@"定期"]){
            _yearRateTextField.text=_yearRateDataDic[_selectPicerViewStr];
        }
            
           
        
       
        _yearRateTextField.font=[UIFont systemFontOfSize:14];
        _yearRateTextField.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:_yearRateTextField];
        [_yearRateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-20);
            make.width.equalTo(@75);
            make.height.equalTo(@30);
        }];
        
    
    }
    if ([cell.textLabel.text isEqualToString:@"理财金额(元)"]) {
        _lcTextField=[[UITextField alloc]init];
        _lcTextField.placeholder=@"请输入实际本金";
        _lcTextField.font=[UIFont systemFontOfSize:14];
        _lcTextField.keyboardType=UIKeyboardTypeNumberPad;
        _lcTextField.textAlignment=NSTextAlignmentRight;
        
        [cell.contentView addSubview:_lcTextField];
        [_lcTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
        
        
    }
    if ([cell.textLabel.text isEqualToString:@"理财期限"]) {
        _lcMonthTextField=[[UITextField alloc]init];
//        _lcMonthTextField.placeholder=@"请输入金额";
        _lcMonthTextField.font=[UIFont systemFontOfSize:14];
        _lcMonthTextField.keyboardType=UIKeyboardTypeNumberPad;
        _lcMonthTextField.textAlignment=NSTextAlignmentRight;
        _lcMonthTextField.borderStyle=UITextBorderStyleLine;
        _lcMonthTextField.layer.borderColor=[RGBA(19, 99, 254, 1) CGColor];
        _lcMonthTextField.layer.borderWidth=1.0;
        _lcMonthTextField.layer.masksToBounds=YES;
        
        [cell.contentView addSubview:_lcMonthTextField];
        [_lcMonthTextField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _lcRateTextField=[[UITextField alloc]init];
        //        _lcMonthTextField.placeholder=@"请输入金额";
        _lcRateTextField.font=[UIFont systemFontOfSize:14];
        _lcRateTextField.keyboardType=UIKeyboardTypeNumberPad;
        _lcRateTextField.textAlignment=NSTextAlignmentRight;
        _lcRateTextField.borderStyle=UITextBorderStyleLine;
        _lcRateTextField.layer.borderColor=[RGBA(19, 99, 254, 1) CGColor];
        _lcRateTextField.layer.borderWidth=1.0;
        _lcRateTextField.layer.masksToBounds=YES;
        
        [cell.contentView addSubview:_lcRateTextField];
        [_lcRateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        _lcRepayTypeLabel=[[UILabel alloc]init];
        
        if (_lcRepayType==nil) {
            _lcRepayType=[_lcRepayTypeArr objectAtIndex:0];
        }
        
        _lcRepayTypeLabel.text=_lcRepayType;
        _lcRepayTypeLabel.font=[UIFont systemFontOfSize:14];
        _lcRepayTypeLabel.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:_lcRepayTypeLabel];
        [_lcRepayTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(0);
            make.width.equalTo(@200);
            make.height.equalTo(@30);
        }];
        
    }
    
    
    
    
    return  cell;
    
    
    
    
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dataArr[indexPath.row] isEqualToString:@"存款期限"]) {
       
       _pickerViewDataArr=_ckRateArr;
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,40, KScreenWidth, 200)];
        self.pickerView.backgroundColor=[UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        if (_selectPicerViewStr!=nil) {
            long a=[_pickerViewDataArr indexOfObject:_selectPicerViewStr];
            [self.pickerView selectRow:a inComponent:0 animated:NO];
        }
        
        
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:KBackgroundColor forState:UIControlStateNormal];
        [button setFrame:CGRectMake(KScreenWidth-50,5, 50, 30)];
        [button addTarget:self action:@selector(didClickOkBtn:) forControlEvents:UIControlEventTouchUpInside];
        long index=indexPath.row;
        [button setTag:index];
        
        UILabel *label=[[UILabel alloc]init];
        label.text=@"还款方式";
        label.textAlignment=NSTextAlignmentCenter;
        
        
        UIButton * cancelbutton = [[UIButton alloc]init];
        [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbutton setTitleColor:KBackgroundColor forState:UIControlStateNormal];
        [cancelbutton setFrame:CGRectMake(0,5, 50, 30)];
        [cancelbutton addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
        view.backgroundColor=RGBA(235, 235, 240, 1);
        [view addSubview:_pickerView];
        [view addSubview:button];
        [view addSubview:cancelbutton];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.height.equalTo(@21);
            make.width.equalTo(@100);
            make.top.equalTo(view.mas_top).offset(10);
            
            
        }];
        
        
        _popView=[PopView popSideContentView:view direct:PopViewDirection_SlideFromBottom];
        
        _popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        
        
        
    }
    if ([_dataArr[indexPath.row] isEqualToString:@"还款方式"]) {
        
        _pickerViewDataArr=_lcRepayTypeArr;
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,40, KScreenWidth, 200)];
        self.pickerView.backgroundColor=[UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        if (_lcRepayType!=nil) {
            long a=[_lcRepayTypeArr indexOfObject:_lcRepayType];
            [self.pickerView selectRow:a inComponent:0 animated:NO];
        }
        
        
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:KBackgroundColor forState:UIControlStateNormal];
        [button setFrame:CGRectMake(KScreenWidth-50,5, 50, 30)];
        [button addTarget:self action:@selector(didClickOkBtn:) forControlEvents:UIControlEventTouchUpInside];
        long index=indexPath.row;
        [button setTag:index];
        
        UILabel *label=[[UILabel alloc]init];
        label.text=@"存款期限";
        label.textAlignment=NSTextAlignmentCenter;
        
        
        UIButton * cancelbutton = [[UIButton alloc]init];
        [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbutton setTitleColor:KBackgroundColor forState:UIControlStateNormal];
        [cancelbutton setFrame:CGRectMake(0,5, 50, 30)];
        [cancelbutton addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
        view.backgroundColor=RGBA(235, 235, 240, 1);
        [view addSubview:_pickerView];
        [view addSubview:button];
        [view addSubview:cancelbutton];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.height.equalTo(@21);
            make.width.equalTo(@100);
            make.top.equalTo(view.mas_top).offset(10);
            
            
        }];
        
        
        _popView=[PopView popSideContentView:view direct:PopViewDirection_SlideFromBottom];
        
        _popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        
        
        
    }
    
}

#pragma - mark pickerview代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _pickerViewDataArr.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str=[_pickerViewDataArr objectAtIndex:row];
    
    return  str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击
-(void)didClickLCSegmentControl{
    
    if (self.segmentControl.selectedSegmentIndex==1) {
        _dataArr=@[@"理财金额(元)",@"理财期限",@"年利率",@"还款方式"];
        
         [self.tableView reloadData];
    }else{
        _dataArr=@[@"存款金额(元)",@"存款类型",@"存款期限",@"年利率(%)"];
        
         [self.tableView reloadData];
    }
    
}
//点击还款方式
-(void)didClickRepaymentModeSeg:(UISegmentedControl*)seg{
  
    _depositingType=_depositingModeArr[seg.selectedSegmentIndex];
//    [self.tableView reloadData];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    NSArray <NSIndexPath *>*indexPathArray=@[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}
//点击确定
-(void)didClickOkBtn:(id)sender{
    
    long index=[sender tag];
    
    
  
    
    for (int i=0; i<_dataArr.count; i++) {
        if ([_dataArr[i] isEqualToString:@"年利率(%)"]) {
            NSInteger row=[_pickerView selectedRowInComponent:0];
            _selectPicerViewStr=[_pickerViewDataArr objectAtIndex:row];
            NSLog(@"%@",_selectPicerViewStr);
            [_popView removeFromSuperview];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
            NSArray <NSIndexPath *>*indexPathArray=@[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            
            _yearRateTextField.text=_yearRateDataDic[_selectPicerViewStr];
            
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:i inSection:0];
            NSArray <NSIndexPath *>*indexPathArray1=@[indexPath1];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray1 withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if ([_dataArr[i] isEqualToString:@"还款方式"]) {
            NSInteger row=[_pickerView selectedRowInComponent:0];
            _lcRepayType=[_lcRepayTypeArr objectAtIndex:row];
            NSLog(@"%@",_lcRepayType);
            [_popView removeFromSuperview];
//            _lcRepayTypeLabel.text=[_lcRepayTypeArr objectAtIndex:row];;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            NSArray <NSIndexPath *>*indexPathArray=@[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            
            
    
        }
    }

    
}
//点击取消
-(void)didClickCancelBtn{
    
    [_popView removeFromSuperview];
    
}
-(void)didClickCalcBtn{
//    //键盘消除第一响应者
    [self.ckTextField resignFirstResponder];
    [self.lcTextField resignFirstResponder];
    [self.lcRateTextField resignFirstResponder];
    [self.lcMonthTextField resignFirstResponder];

    //点击开始计算弹出界面
    if (self.segmentControl.selectedSegmentIndex==0) {
        double time;
        if ([_selectPicerViewStr isEqualToString:@"3个月"]) {
            time=0.25;
            
        }else if([_selectPicerViewStr isEqualToString:@"6个月"]){
            time=0.5;
        }else if([_selectPicerViewStr isEqualToString:@"1年"]){
            time=1;
        }else if([_selectPicerViewStr isEqualToString:@"2年"]){
            time=2;
        }else if([_selectPicerViewStr isEqualToString:@"3年"]){
            time=3;
        }else{
            time=5;
        }
        
        
        
        _resultModel=[XYKCaclulateModel new];
        XYKCaclulateModel *model=[XYKCaclulateModel new];
        model.depositTime=time;
        model.bankRate=[_yearRateTextField.text doubleValue];
        model.totalDepositMoney=[_ckTextField.text doubleValue];
        
        _resultModel=[XYKCalculator calculateBankMoneywithCalcModel:model];
        
        
        _myView = [[MyView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth,KScreenHeight/3*2)];
        //    _myView.model=[XYKCaclulateModel new];
        _myView.delegate = self;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, _myView.frame.size.height)];
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel *label1=[[UILabel alloc]init];
        label1.text=@"利息(元)";
        label1.font=[UIFont systemFontOfSize:14];
        label1.textAlignment=NSTextAlignmentCenter;
        
        
        [view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@21);
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(view.mas_top).offset(20);
        }];
        
        UILabel*label2=[[UILabel alloc]init];
        label2.text=[NSString stringWithFormat:@"%.2f",_resultModel.bankInterest];
        label2.font=[UIFont boldSystemFontOfSize:21];
        label2.textColor=[UIColor orangeColor];
        label2.textAlignment=NSTextAlignmentCenter;
        
        [view addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@200);
            make.height.equalTo(@30);
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(label1.mas_bottom).offset(10);
        }];
        
        UILabel *label3=[[UILabel alloc]init];
        label3.text=@"本息(元)";
        label3.font=[UIFont systemFontOfSize:14];
        label3.textAlignment=NSTextAlignmentCenter;
        
        
        [view addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@21);
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(label2.mas_bottom).offset(20);
        }];
        
        UILabel*label4=[[UILabel alloc]init];
        label4.text=[NSString stringWithFormat:@"%.2f",_resultModel.bankInterest+[_ckTextField.text doubleValue]];
        label4.font=[UIFont boldSystemFontOfSize:21];
        label4.textColor=[UIColor orangeColor];
        label4.textAlignment=NSTextAlignmentCenter;
        
        [view addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@200);
            make.height.equalTo(@30);
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(label3.mas_bottom).offset(10);
        }];
        
        
        [_myView addSubview:view];
        
        [_myView showIn:self.view];
    } if (self.segmentControl.selectedSegmentIndex==1){
        
        _resultModel=[XYKCaclulateModel new];
        XYKCaclulateModel *model=[XYKCaclulateModel new];
        model.depositTime=[_lcMonthTextField.text doubleValue];
        model.bankRate=[_lcRateTextField.text doubleValue];
        model.totalDepositMoney=[_lcTextField.text doubleValue];
        
        _resultModel=[XYKCalculator calculatePtPwithCalcModel:model];
        
        
        
        LiCaiViewController*vc=[[LiCaiViewController alloc]init];
        vc.model=[XYKCaclulateModel new];
        vc.model=_resultModel;
        vc.repayType=_lcRepayType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
}

#pragma mark - MyViewDelegate
// 点击了自己
- (void)myView:(MyView *)myView didSelectedSelf:(id)sender
{
    [myView hide];
}

// 点击了阴影
- (void)myView:(MyView *)myView didSelectedShadow:(id)sender
{
    [myView hide];
}

- (void)myView:(MyView *)myView {
    
}

//收起键盘
- (void)commentTableViewTouchInSide{
    
    [self.ckTextField resignFirstResponder];
    [self.lcTextField resignFirstResponder];
    [self.lcMonthTextField resignFirstResponder];
     [self.lcRateTextField resignFirstResponder];
}
@end
