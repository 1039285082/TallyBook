//
//  LiCaiViewController.m
//  HaiLuoQianBao
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LiCaiViewController.h"
#import "LiCaiTableViewCell.h"
#import "LiCaiHeadView.h"
@interface LiCaiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView * tableView;        //
@end

@implementation LiCaiViewController

//隐藏底部bottombar
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"理财计划";
       [self.navigationItem setHidesBackButton:YES];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib2=[UINib nibWithNibName:@"LiCaiTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"LiCaiTableViewCell"];
    
   

//
//    LiCaiHeadView*headview=[[LiCaiHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    LiCaiHeadView *headview=[[LiCaiHeadView alloc]init];
    NSArray *apparray= [[NSBundle mainBundle]loadNibNamed:@"LiCaiHeadView" owner:nil options:nil];
    headview = [apparray firstObject];
    headview.frame = CGRectMake(0, 0, KScreenWidth, 100);
    headview.benjinLabel.text=[NSString stringWithFormat:@"%.f",_model.totalDepositMoney];
    headview.lixiLabel.text=[NSString stringWithFormat:@"%.2f",_model.bankInterest];
    headview.shouyiLabel.text=[NSString stringWithFormat:@"%.f",_model.depositTime];
    if ([_repayType isEqualToString:@"一次性还本付息"]){
        headview.shouyiLabel.text=@"1";
        
    }
    headview.nianhuaLabel.text=[NSString stringWithFormat:@"%.2f%%",_model.bankRate*100];
//    headview.lixiLabel.text=[NSString stringWithFormat:@"%.2f",_model.]
    
//    model.depositTime=[_lcMonthTextField.text doubleValue];
//    model.bankRate=[_lcRateTextField.text doubleValue];
//    model.totalDepositMoney=[_lcTextField.text doubleValue];
   
    self.tableView.tableHeaderView=headview;
//    UINib *nib3=[UINib nibWithNibName:@"RepaymentScheduleTableViewCell" bundle:nil];
//    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"RepaymentScheduleTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    UIButton *button=[[UIButton alloc]init];
    //    button.frame=CGRectMake(0, KScreenHeight-44, KScreenWidth, 44);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setBackgroundColor:KBackgroundColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_repayType isEqualToString:@"一次性还本付息"]) {
        return 2;
    }else{
        return _model.depositTime+1;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    long  index=indexPath.row;

    LiCaiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LiCaiTableViewCell"];
        if (index==0) {
            
            cell.monthLable.text=@"期数";
            cell.benjinLabel.text=@"本金";
            cell.lixiLabel.text=@"利息";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    cell.monthLable.text=[NSString stringWithFormat:@"第%ld期",indexPath.row];
    cell.benjinLabel.text=@"0";
   
    
    cell.lixiLabel.text=[NSString stringWithFormat:@"%.2f",_model.bankInterest/_model.depositTime];
    if (index==_model.depositTime) {
        cell.benjinLabel.text=[NSString stringWithFormat:@"%.f",_model.totalDepositMoney];
    }
    if ([_repayType isEqualToString:@"一次性还本付息"]){
        cell.benjinLabel.text=[NSString stringWithFormat:@"%.f",_model.totalDepositMoney];
        cell.lixiLabel.text=[NSString stringWithFormat:@"%.2f",_model.bankInterest];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //    cell.textLabel.text=[NSString stringWithFormat:@"%.2f",[_model.mouthRateArr[index-1] floatValue]];
    
    return cell;
    
}

-(void)dissMiss{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
