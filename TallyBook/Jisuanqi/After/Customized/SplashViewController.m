//
//  SplashViewController.m
//  白卡回收
//
//  Created by WuShan on 2018/4/3.
//  Copyright © 2018年 Maideed. All rights reserved.
//

#import "SplashViewController.h"
#import "SessionData.h"
#import "TabbarController.h"
#import "ViewControllerAnchorSet.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setNavigationBarHidden:YES];
    
    [self setupMainViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void) setupMainViewControllers {
    SessionData* session = [SessionData getInstance];
    if(session.config.isNewsMode) {
        TabbarController *tVc=[[TabbarController alloc]init];
        UIViewController* vc = tVc;

        [self setViewControllers:@[vc]];
    } else {
        UITabBarController* tabVc = [ViewControllerAnchorSet mainTabVcAfterLoad];
        [self setViewControllers:@[tabVc]];
    }
}


@end
