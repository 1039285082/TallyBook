//
//  TabbarController.m
//  Jisuanqi
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TabbarController.h"
//#import "CalculateViewController.h"
#import "DWQOrderListViewController.h"
#import "BWWMyViewController.h"
@interface TabbarController ()

@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DWQOrderListViewController *cVC=[[DWQOrderListViewController alloc]init];
   
    
    BWWMyViewController *bVC=[[BWWMyViewController alloc]init];
  
    
    UINavigationController *NV1=[[UINavigationController alloc]initWithRootViewController:cVC];
     UINavigationController *NV2=[[UINavigationController alloc]initWithRootViewController:bVC];
    NV1.tabBarItem.title=@"计算";
     NV2.tabBarItem.title=@"精品推荐";

    
    [NV1.navigationBar lt_setBackgroundColor:KBackgroundColor];
    [NV1.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [NV1.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    [NV2.navigationBar lt_setBackgroundColor:KBackgroundColor];
    [NV2.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [NV2.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    
//    NSDictionary
    NV1.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    NV1.tabBarItem.image=[[UIImage imageNamed:@"jisuanqi"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    NV1.tabBarItem.selectedImage=[[UIImage imageNamed:@"jisuanqixhuanzgong"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *dictHome1 = [NSDictionary dictionaryWithObject:KBackgroundColor forKey:NSForegroundColorAttributeName];
    [NV1.tabBarItem setTitleTextAttributes:dictHome1 forState:UIControlStateSelected];
    
    NV2.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    NV2.tabBarItem.image=[[UIImage imageNamed:@"jingpin"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    NV2.tabBarItem.selectedImage=[[UIImage imageNamed:@"jingpinSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *dictHome2 = [NSDictionary dictionaryWithObject:KBackgroundColor forKey:NSForegroundColorAttributeName];
    [NV2.tabBarItem setTitleTextAttributes:dictHome2 forState:UIControlStateSelected];
    
    self.viewControllers=@[NV1,NV2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
