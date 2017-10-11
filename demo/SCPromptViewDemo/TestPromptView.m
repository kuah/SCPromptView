//
//  TestPromptView.m
//  SCPromptViewDemo
//
//  Created by 陈世翰 on 17/3/10.
//  Copyright © 2017年 Coder Chan. All rights reserved.
//

#import "TestPromptView.h"

@interface TestPromptView()
/**
 *   <#decr#>
 */
@property (nonatomic,strong)UILabel *textLabel;
@end

@implementation TestPromptView
-(void)sc_setUpCustomSubViews{
    UILabel *textLabel = [[UILabel alloc]initWithFrame:(CGRect){0,SC_SUGGEST_TOP_PADDING,self.contentView.bounds.size.width,self.contentView.bounds.size.height-SC_SUGGEST_TOP_PADDING}];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [self.contentView addSubview:textLabel];
    self.textLabel = textLabel;
}
-(void)sc_loadParam:(id)param{
    NSString *text = param;
    self.textLabel.text = text;
    UIColor *color = [UIColor colorWithRed:(arc4random()%255)/255.f green:(arc4random()%255)/255.f blue:(arc4random()%255)/255.f alpha:1];
    self.backgroundColor=color;
    self.contentView.backgroundColor=color;
}

@end
