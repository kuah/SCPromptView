//
//  RootViewController.m
//  SCPromptViewDemo
//
//  Created by 陈世翰 on 17/3/10.
//  Copyright © 2017年 Coder Chan. All rights reserved.
//

#import "RootViewController.h"
#import "TestPromptView.h"
#import "ResultPromptView.h"
@interface RootViewController (){
    int _num;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpDemoBtn];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.f green:234/255.f blue:234/255.f alpha:1];
    SCPROMPT_REGISTER([TestPromptView class],@"test")
    SCPROMPT_REGISTER([ResultPromptView class], @"result")
}
///随机颜色显示
-(void)clickBtn:(id)sender{
    NSString * text =[NSString stringWithFormat:@"%d",_num];
    SCPROMPT_SHOW(@"test",text)
    _num++;
}
//成功
-(void)showSuccess:(id)sender{
    NSDictionary *param =@{@"text":@"操作成功",@"isSuccess":@(1)};
    SCPROMPT_SHOW(@"result",param)
}
//失败
-(void)showError:(id)sender{
    NSDictionary *param =@{@"text":@"操作失败",@"isSuccess":@(0)};
    SCPROMPT_SHOW(@"result",param)
}


/****************************** demo btn *********************************/

-(void)setUpDemoBtn{
    CGFloat margin = [UIScreen mainScreen].bounds.size.width;
    UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){((margin-100)/2.f),200,100,50}];
    [btn setTitle:@"提示" forState:UIControlStateNormal];    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:(CGRect){((margin-100)/2.f),300,100,50}];
    [btn1 setTitle:@"成功" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor yellowColor];
    [btn1 addTarget:self action:@selector(showSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:(CGRect){((margin-100)/2.f),400,100,50}];
    [btn2 setTitle:@"失败" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 addTarget:self action:@selector(showError:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
