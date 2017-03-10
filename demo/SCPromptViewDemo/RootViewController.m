//
//  RootViewController.m
//  SCPromptViewDemo
//
//  Created by 陈世翰 on 17/3/10.
//  Copyright © 2017年 Coder Chan. All rights reserved.
//

#import "RootViewController.h"
#import "TestPromptView.h"
@interface RootViewController (){
    int _num;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    SCPROMPT_REGISTER([TestPromptView class],@"test")
    
    UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){0,100,100,100}];
    [btn setTitle:@"提示" forState:UIControlStateNormal];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)clickBtn:(id)sender{
    NSString * text =[NSString stringWithFormat:@"%d",_num];
    SCPROMPT_SHOW(@"test",text)
    _num++;
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
