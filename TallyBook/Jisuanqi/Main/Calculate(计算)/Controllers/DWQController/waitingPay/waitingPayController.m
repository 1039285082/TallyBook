//
//  allOrderViewController.m
//  DWQListOfDifferentOrderStatus
//
//  Created by 杜文全 on 15/11/1.
//  Copyright © 2015年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import "waitingPayController.h"
#import "PopView.h"
#import "MyView.h"
#import "HouseLoanPopHeadView.h"
#import "RepaymentScheduleViewController.h"



@interface waitingPayController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,MyViewDelegate>

@property (strong,nonatomic)UITableView * tableView;        //
@property (strong,nonatomic)NSArray  * dataArr;        //tableview每行显示
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong,nonatomic)NSArray * yearArr;        //年限数组
@property (strong,nonatomic)NSArray * repaymentModeArr;        //还款方式

@property (strong,nonatomic)UILabel * syRateLabel;        //商业利率label
@property (strong,nonatomic)UILabel * gjjRateLabel;        //公积金利率label
@property (strong,nonatomic)UITextField *syTextFiled;        //商业总额
@property (strong,nonatomic)UITextField *gjjTextFiled;        //公积金总额

/**XYKCalculator计算参数 */
@property (assign,nonatomic) double year;

@property (assign,nonatomic) double totalMoney;

@property (assign,nonatomic) double syRate;

@property (strong,nonatomic)NSString * repayMentType;        //还款方式

@property (strong,nonatomic)XYKCaclulateModel * resultModel;        //计算结果模型

/**pickerView  */
@property (strong,nonatomic)UIPickerView * pickerView;        //商业利率pickerView
//@property (strong,nonatomic)UIPickerView * gjjPickerView;        //公积金利率pickerView
@property (strong,nonatomic)NSArray * pcikerDataArr;        //popView数据源
@property (strong,nonatomic)NSArray * syPickerDataArr;        //商业pickerview数据源
@property (strong,nonatomic)NSArray * gjjPickerDataArr;        //公积金pickerview数据源
@property (strong,nonatomic)NSDictionary * gjjPickerDataBelowFiveDic;        //公积金pickerview字典5年以下
@property (strong,nonatomic)NSDictionary * gjjPickerDataUptenDic;        //公积金pickerview字典10年以上
@property (strong,nonatomic)NSDictionary * syPickerDataBelowFiveDic;        //商业pickerview字典5年以下
@property (strong,nonatomic)NSDictionary * syPickerDataUptenDic;        //商业pickerview字典10年以上
//@property (strong,nonatomic)NSString  * selectPicerViewStr;        //pickerView选择的值
@property (strong,nonatomic)NSString  * selectSyPicerViewStr;        //pickerView选择的值
@property (strong,nonatomic)NSString  * selectGjjPicerViewStr;        //pickerView选择的值
/** popView*/
@property (strong,nonatomic)PopView *popView;
/** popView*/
@property (strong,nonatomic)MyView * myView;


@end

@implementation waitingPayController
-(NSArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSArray array];
    }
    
    
    
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
 
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.segmentControl.frame.size.height+self.segmentControl.frame.origin.y, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //滚动时收起键盘
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //点击tableview时隐藏键盘
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    
    tableViewGesture.numberOfTapsRequired = 1;
    
    tableViewGesture.cancelsTouchesInView = NO;
    
    [self.tableView addGestureRecognizer:tableViewGesture];
    
    [self.view addSubview:self.tableView];
    [self.segmentControl setSelectedSegmentIndex:0];

    
    _dataArr=@[@"贷款年限",@"还款方式",@"商业贷款金额(万)",@"商业贷款利率(%)"];
    _yearArr=@[@"5",@"10",@"15",@"20",@"25",@"30"];
    _repaymentModeArr=@[@"等额本息",@"等额本金"];
    _syPickerDataBelowFiveDic=@{@"基础利率":@"4.75",
                                @"9.5折":@"4.512",
                                @"9折":@"4.275",
                                @"8.8折":@"4.180",
                                @"8.5折":@"4.037",
                                @"8.3折":@"3.942",
                                @"8折":@"3.800",
                                @"7折":@"3.325",
                                @"1.05倍":@"4.987",
                                @"1.1倍":@"5.225",
                                @"1.15倍":@"5.463",
                                @"1.2倍":@"5.700",
                                @"1.3倍":@"6.175",
                       };
    _syPickerDataUptenDic=@{@"基础利率":@"4.90",
                            @"9.5折":@"4.655",
                            @"9折":@"4.410",
                            @"8.8折":@"4.312",
                            @"8.5折":@"4.165",
                            @"8.3折":@"4.067",
                            @"8折":@"3.920",
                            @"7折":@"3.430",
                            @"1.05倍":@"5.145",
                            @"1.1倍":@"5.390",
                            @"1.15倍":@"5.635",
                            @"1.2倍":@"5.880",
                            @"1.3倍":@"6.370",
                            
                            };
    
    _syPickerDataArr=@[@"基础利率", @"9.5折",@"9折", @"8.8折",@"8.5折", @"8.3折", @"8折",@"7折", @"1.05倍",@"1.1倍",@"1.15倍",@"1.2倍",@"1.3倍"];
    
    _gjjPickerDataArr=@[@"基础利率",@"1.1倍"];
    _gjjPickerDataBelowFiveDic=@{@"基础利率":@"2.75",
                                 @"1.1倍":@"3.025",
                                 };
    _gjjPickerDataUptenDic=@{@"基础利率":@"3.25",
                                 @"1.1倍":@"3.575",
                                 };
    
    [self.segmentControl addTarget:self action:@selector(didClickDKSegmentControl) forControlEvents:UIControlEventValueChanged];
    
    _tableView.sectionHeaderHeight = 0.01;
    _tableView.sectionFooterHeight = 0.01;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    UILabel *label=[[UILabel alloc]init];
    label.text=@"请输入贷款信息";
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.mas_equalTo(20);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
     _pcikerDataArr=[NSArray new];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - mark tableview代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
  

    UITableViewCell *cell=[UITableViewCell new];
    cell.textLabel.text=_dataArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([cell.textLabel.text isEqualToString:@"贷款年限"]) {
        UISegmentedControl *seg=[[UISegmentedControl alloc]initWithItems:_yearArr];
        [seg setSelectedSegmentIndex:0];
        NSString *yearStr=[NSString stringWithFormat:@"%@",_yearArr[seg.selectedSegmentIndex]];
        _year=[yearStr floatValue];
        [seg addTarget:self action:@selector(didClickYearSeg:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:seg];
    
        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
             make.right.mas_equalTo(-10);
            make.width.equalTo(@200);
            make.height.equalTo(@30);
            
           
        }];
        
    }
    if ([cell.textLabel.text isEqualToString:@"还款方式"]) {
        UISegmentedControl *seg=[[UISegmentedControl alloc]initWithItems:_repaymentModeArr];
        [seg setSelectedSegmentIndex:0];
        [seg addTarget:self action:@selector(didClickRepaymentModeSeg:) forControlEvents:UIControlEventValueChanged];
        UIFont *font = [UIFont systemFontOfSize:14.0f];   // 设置字体大小
        _repayMentType=_repaymentModeArr[seg.selectedSegmentIndex];
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
    if ([cell.textLabel.text isEqualToString:@"商业贷款金额(万)"]){
//        UILabel *label=[[UILabel alloc]init];
        _syTextFiled=[[UITextField alloc]init];
        _syTextFiled.placeholder=@"请输入金额";
        _syTextFiled.font=[UIFont systemFontOfSize:14];
        _syTextFiled.keyboardType=UIKeyboardTypeNumberPad;
        _syTextFiled.textAlignment=NSTextAlignmentRight;
  
        [cell.contentView addSubview:_syTextFiled];
        [_syTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            make.width.equalTo(@75);
            make.height.equalTo(@30);
        }];
        
        
    }
    if ([cell.textLabel.text isEqualToString:@"公积金贷款金额(万)"]){
        _gjjTextFiled=[[UITextField alloc]init];
        _gjjTextFiled.placeholder=@"请输入金额";
        _gjjTextFiled.font=[UIFont systemFontOfSize:14];
        _gjjTextFiled.keyboardType=UIKeyboardTypeNumberPad;
        _gjjTextFiled.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:_gjjTextFiled];
        [_gjjTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
            make.width.equalTo(@75);
            make.height.equalTo(@30);
        }];
        
        
    }
    if ([cell.textLabel.text isEqualToString:@"商业贷款利率(%)"]){
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        _syRateLabel=[[UILabel alloc]init];
        NSString *value=[NSString new];
        if (_selectSyPicerViewStr!=nil) {
           
            if (_year<=5) {
               value=_syPickerDataBelowFiveDic[_selectSyPicerViewStr];
            }else{
                
                 value=_syPickerDataUptenDic[_selectSyPicerViewStr];
            }
        }else{
            _selectSyPicerViewStr=[_syPickerDataArr objectAtIndex:0];
            if (_year<=5) {
                
                 value=_syPickerDataBelowFiveDic[_selectSyPicerViewStr];
            }else{
                value=_syPickerDataUptenDic[_syPickerDataArr[0]];
            }
           
        }
        
        _syRateLabel.text=value;
        _syRateLabel.font=[UIFont systemFontOfSize:14];
        _syRateLabel.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:_syRateLabel];
        [_syRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(0);
            make.width.equalTo(@75);
            make.height.equalTo(@30);
        }];
        
    }
    if ([cell.textLabel.text isEqualToString:@"公积金贷款利率(%)"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        _gjjRateLabel=[[UILabel alloc]init];
        NSString *value=[NSString new];
        if (_selectGjjPicerViewStr!=nil) {
            
            if (_year<=5) {
                value=_gjjPickerDataBelowFiveDic[_selectGjjPicerViewStr];
            }else{
                
                value=_gjjPickerDataUptenDic[_selectGjjPicerViewStr];
            }
        }else{
            _selectGjjPicerViewStr=[_gjjPickerDataArr objectAtIndex:0];
            if (_year<=5) {
                
                value=_gjjPickerDataBelowFiveDic[_selectGjjPicerViewStr];
            }else{
                value=_gjjPickerDataUptenDic[_syPickerDataArr[0]];
            }
            
        }
        
        _gjjRateLabel.text=value;
        _gjjRateLabel.font=[UIFont systemFontOfSize:14];
        _gjjRateLabel.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:_gjjRateLabel];
        [_gjjRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(0);
            make.width.equalTo(@75);
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
   
    if ([_dataArr[indexPath.row] isEqualToString:@"商业贷款利率(%)"]) {
        _pcikerDataArr=_syPickerDataArr;
       
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,40, KScreenWidth, 200)];
        self.pickerView.backgroundColor=[UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        if (_selectSyPicerViewStr!=nil) {
            long a=[_pcikerDataArr indexOfObject:_selectSyPicerViewStr];
            [self.pickerView selectRow:a inComponent:0 animated:NO];
        }
      
        
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:KBackgroundColor forState:UIControlStateNormal];
        [button setFrame:CGRectMake(KScreenWidth-50,5, 50, 30)];
        [button addTarget:self action:@selector(didClickOkBtn:) forControlEvents:UIControlEventTouchUpInside];
        long index=indexPath.row;
        [button setTag:index];
        
        UIButton * cancelbutton = [[UIButton alloc]init];
        [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbutton setTitleColor:KBackgroundColor forState:UIControlStateNormal];
        [cancelbutton setFrame:CGRectMake(0,5, 50, 30)];
        [cancelbutton addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
        view.backgroundColor=RGBA(235, 235, 240, 1);
        [view addSubview:self.pickerView];
        [view addSubview:button];
        [view addSubview:cancelbutton];
        _popView=[PopView popSideContentView:view direct:PopViewDirection_SlideFromBottom];
       
        _popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

        
      
      
    }if ([_dataArr[indexPath.row] isEqualToString:@"公积金贷款利率(%)"]) {
        
         _pcikerDataArr=_gjjPickerDataArr;
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,40, KScreenWidth, 200)];
        self.pickerView.backgroundColor=[UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        if (_selectGjjPicerViewStr!=nil) {
            long b=[_pcikerDataArr indexOfObject:_selectGjjPicerViewStr];
            [self.pickerView selectRow:b inComponent:0 animated:NO];
        }
        
        
        //        [self.pickerView reloadAllComponents];
        
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:KBackgroundColor forState:UIControlStateNormal];
        [button setFrame:CGRectMake(KScreenWidth-50,5, 50, 30)];
        [button addTarget:self action:@selector(didClickOkBtn:) forControlEvents:UIControlEventTouchUpInside];
        long index=indexPath.row;
        [button setTag:index];
        
        UIButton * cancelbutton = [[UIButton alloc]init];
        [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbutton setTitleColor:KBackgroundColor forState:UIControlStateNormal];
        [cancelbutton setFrame:CGRectMake(0,5, 50, 30)];
        [cancelbutton addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
        view.backgroundColor=RGBA(235, 235, 240, 1);
        [view addSubview:self.pickerView];
        [view addSubview:button];
        [view addSubview:cancelbutton];
        _popView=[PopView popSideContentView:view direct:PopViewDirection_SlideFromBottom];
        
        _popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        
        
        
    }
    
}
#pragma - mark pickerview代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _pcikerDataArr.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str=[_pcikerDataArr objectAtIndex:row];

    return  str;
}
////////
-(void)didClickDKSegmentControl{
    if (self.segmentControl.selectedSegmentIndex==0) {
         _dataArr=@[@"贷款年限",@"还款方式",@"商业贷款金额(万)",@"商业贷款利率(%)"];
        [self.tableView reloadData];
    }else if(self.segmentControl.selectedSegmentIndex==1){
        _dataArr=@[@"贷款年限",@"还款方式",@"公积金贷款金额(万)",@"公积金贷款利率(%)"];
        [self.tableView reloadData];
    }else if(self.segmentControl.selectedSegmentIndex==2){
        _dataArr=@[@"贷款年限",@"还款方式",@"商业贷款金额(万)",@"公积金贷款金额(万)",@"商业贷款利率(%)",@"公积金贷款利率(%)"];
         [self.tableView reloadData];
    }
    
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(pickerView.frame.size.width/2-100, 0, 200, 32);
    label.textAlignment=NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:22];
   
    label.text=self.pcikerDataArr[row];

    //  设置横线的颜色，实现显示或者隐藏
    ([pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor lightGrayColor];
    
    ([pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor lightGrayColor];
    
    return label;
}


//点击年份
-(void)didClickYearSeg:(UISegmentedControl*)seg{
    
    NSLog(@"%ld",seg.selectedSegmentIndex);
    NSLog(@"%@",_yearArr[seg.selectedSegmentIndex]);
    NSString *yearStr=[NSString stringWithFormat:@"%@",_yearArr[seg.selectedSegmentIndex]];
    _year=[yearStr floatValue];
//    long a=0,b=0;
    for (int i=0; i<_dataArr.count; i++) {
        if ([_dataArr[i] isEqualToString:@"商业贷款利率(%)"]) {
        
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            
            NSArray <NSIndexPath *>*indexPathArray=@[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            
        }
        if ([_dataArr[i] isEqualToString:@"公积金贷款利率(%)"]) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            
            NSArray <NSIndexPath *>*indexPathArray=@[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    
}
//点击还款方式
-(void)didClickRepaymentModeSeg:(UISegmentedControl*)seg{
//    
//    NSLog(@"%ld",seg.selectedSegmentIndex);
//    NSLog(@"%@",_repaymentModeArr[seg.selectedSegmentIndex]);
    _repayMentType=_repaymentModeArr[seg.selectedSegmentIndex];
}
//点击确定
-(void)didClickOkBtn:(id)sender{

    long index=[sender tag];
    
    if ([_dataArr[index] isEqualToString:@"商业贷款利率(%)"]) {
        NSInteger row=[_pickerView selectedRowInComponent:0];
        _selectSyPicerViewStr=[_pcikerDataArr objectAtIndex:row];
        NSLog(@"%@",_selectSyPicerViewStr);
        [_popView removeFromSuperview];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        NSArray <NSIndexPath *>*indexPathArray=@[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if ([_dataArr[index] isEqualToString:@"公积金贷款利率(%)"]) {
        NSInteger row=[_pickerView selectedRowInComponent:0];
        _selectGjjPicerViewStr=[_pcikerDataArr objectAtIndex:row];
        NSLog(@"%@",_selectGjjPicerViewStr);
        [_popView removeFromSuperview];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        NSArray <NSIndexPath *>*indexPathArray=@[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    

    
}
//点击取消
-(void)didClickCancelBtn{
    
    [_popView removeFromSuperview];
    
}
-(void)didClickCalcBtn{
    //键盘消除第一响应者
    [self.syTextFiled resignFirstResponder];
    [self.gjjTextFiled resignFirstResponder];
    
//    NSLog(@"%@",_syTextFiled.text);
                                                                    ;
    XYKCaclulateModel *model=[XYKCaclulateModel new];
    model.Year=_year;
   
    if (self.segmentControl.selectedSegmentIndex==0) {
        model.businessRate=[_syRateLabel.text doubleValue];
        model.businessTotalPrice=[_syTextFiled.text doubleValue]*10000.0;
        
        if ([self.repayMentType isEqualToString:@"等额本息"]) {
            _resultModel=[XYKCalculator calculateBusinessAsInterestWithCalModel:model];
//            NSLog(@"每月还款%.2f-还款总额%.2f %@ ",_resultModel.mouthRepayment,_resultModel.totalRepayment,_resultModel.mouthRateArr);
            
            
        }else{
           
            _resultModel=[XYKCalculator calculateBusinessAsEqualPriceWithCalModel:model];
            NSLog(@"%.2f",_resultModel.topMouthRepayment);
        }
        
        
    }else if (self.segmentControl.selectedSegmentIndex==1) {
        model.businessRate=[_gjjRateLabel.text doubleValue];
        model.businessTotalPrice=[_gjjTextFiled.text floatValue]*10000.0;
        if ([self.repayMentType isEqualToString:@"等额本息"]) {
            _resultModel=[XYKCalculator calculateBusinessAsInterestWithCalModel:model];
         
        }else{
            _resultModel=[XYKCalculator calculateBusinessAsEqualPriceWithCalModel:model];
        }
    }else{
        model.businessRate=[_syRateLabel.text doubleValue];
        model.fundRate=[_gjjRateLabel.text doubleValue];
        model.fundTotalPrice=[_gjjTextFiled.text doubleValue]*10000.0;
        model.businessTotalPrice=[_syTextFiled.text doubleValue]*10000.0;
        
        if ([self.repayMentType isEqualToString:@"等额本息"]) {
            
            _resultModel=[XYKCalculator calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:model];
//               NSLog(@"%@",_resultModel.mouthRepaymentArr);
        }else{
             _resultModel=[XYKCalculator calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel:model];
        }
       
        
    }
    
    
    
    
    //点击开始计算弹出界面
    
    
        _myView = [[MyView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, KScreenHeight/3*2)];
        _myView.model=[XYKCaclulateModel new];
        _myView.delegate = self;
        
        UINib *nib2=[UINib nibWithNibName:@"HouseLoanPopHeadView" bundle:nil];
        HouseLoanPopHeadView * headView=[nib2 instantiateWithOwner:nil options:nil][0];
        headView.topMonthPriceLabel.text=[NSString stringWithFormat:@"%.2f",_resultModel.topMouthRepayment];
        headView.topInterestLabel.text=[NSString stringWithFormat:@"%.2f",_resultModel.interestPayment];
        headView.totalRepaymentLabel.text=[NSString stringWithFormat:@"%.2f",_resultModel.totalRepayment];
        headView.eachMonthReleasePriceLabel.text=[NSString stringWithFormat:@"%.2f",_resultModel.decreaseRepayment];
        headView.frame=CGRectMake(0, 0, KScreenWidth, _myView.frame.size.height) ;
        
        UIButton *button=[[UIButton alloc]init];
        
        [button setTitle:@"查看还款计划" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
        
        button.backgroundColor=[UIColor orangeColor];
        
        button.layer.cornerRadius=5.0;
        button.layer.masksToBounds=YES;
        
        [button addTarget:self action:@selector(didClickRepaymentBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.totalRepaymentLabel.mas_bottom).offset(10);
            make.centerX.equalTo(headView.mas_centerX);
            make.width.equalTo(@200);
            make.height.equalTo(@44);
        }];
        [_myView addSubview:headView];
        
        
        [_myView showIn:self.view];
//    [_myView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.width.mas_equalTo(KScreenWidth);
//        
//    }];
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.syTextFiled resignFirstResponder];
    [self.gjjTextFiled resignFirstResponder];
}

#pragma - mark 点击查看还款计划按钮
-(void)didClickRepaymentBtn{
    
         RepaymentScheduleViewController*vc=[[RepaymentScheduleViewController alloc]init];
        vc.model=_resultModel;
    
        [self.navigationController pushViewController:vc animated:YES];
    
    
   
    
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
    
    [self.syTextFiled resignFirstResponder];
    [self.gjjTextFiled resignFirstResponder];
//    [self.jkRateTextFiled resignFirstResponder];
}


@end

