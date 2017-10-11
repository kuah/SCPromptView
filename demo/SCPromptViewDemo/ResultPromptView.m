//
//  ResultPromptView.m
//  SCPromptViewDemo
//
//  Created by 陈世翰 on 17/3/10.
//  Copyright © 2017年 Coder Chan. All rights reserved.
//

#import "ResultPromptView.h"

@interface ResultPromptView()
/**
 *   <#decr#>
 */
@property (nonatomic,strong)UILabel *textLabel;
/**
 *   <#decr#>
 */
@property (nonatomic,strong)UIImageView *imageView;
;
@end

@implementation ResultPromptView
-(void)sc_setUpCustomSubViews{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:(CGRect){22,SC_SUGGEST_TOP_PADDING+(self.contentView.bounds.size.height-20-SC_SUGGEST_TOP_PADDING)/2,20,20}];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    self.backgroundColor = [UIColor whiteColor];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:(CGRect){50,topPadding,self.contentView.bounds.size.width-50,self.contentView.bounds.size.height-topPadding}];
    textLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:textLabel];
    self.textLabel = textLabel;
    
}
-(void)sc_loadParam:(id)param{
    NSDictionary *dict = param;
    self.textLabel.text = dict[@"text"];
    self.imageView.image = [dict[@"isSuccess"] boolValue]?[UIImage imageNamed:@"success"]:[UIImage imageNamed:@"error"];
}


@end
