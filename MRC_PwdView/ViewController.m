//
//  ViewController.m
//  MRC_PwdView
//
//  Created by Mr.陈 on 2017/8/31.
//  Copyright © 2017年 MR.C. All rights reserved.
//

#import "ViewController.h"
#import "IKS_PayView.h"
@interface ViewController ()<IKS_Pwd_Delegate>
@property (strong, nonatomic) IBOutlet UITextField *tf_Pwd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    IKS_PayView *pwd = [[IKS_PayView instance]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.width)];
    pwd.delegate = self;
    [pwd showInView:self.view];
}
- (void)currentInputPwd:(NSString *)pwd{
    NSLog(@"current input pwd :--->%@",pwd);
    self.tf_Pwd.text = pwd;
}
- (void)finishPwd:(NSString *)pwd{
    NSLog(@"finish pwd --> %@",pwd);
}
- (void)forgotPwd{
    NSLog(@"forgot pwd");
}
- (void)otherClick{
    NSLog(@"other click ");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
