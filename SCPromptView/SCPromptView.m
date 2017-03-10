//
//  SCPromptView.m
//  SCPromptViewDemo
//
//  Created by 陈世翰 on 17/3/9.
//  Copyright © 2017年 Coder Chan. All rights reserved.
//

#import "SCPromptView.h"
#define SC_SLIDE_DISTANCE 8
#define SC_SHAKE_DISTANCE 3
#define SC_DEFAULT_SHOW_TIME 2
#define SC_SHOW_ANIMATION_DURATION 0.35
#define SC_HIDE_ANIMATION_DURATION 0.2

@interface SCPromptView ()
/**
 *   <#decr#>
 */
@property (nonatomic,strong)NSString *showComand;
@end

@implementation SCPromptView
-(instancetype)init{
    self = [super init];
    [self addSubview:self.contentView];
    self.frame = (CGRect){0,0,[UIScreen mainScreen].bounds.size.width,64+SC_SLIDE_DISTANCE};
    self.contentView.frame = (CGRect){0,0,[UIScreen mainScreen].bounds.size.width,64};
    return self;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
    }
    return _contentView;
}
/**
 *  @brief 添加自定义的子空间
 */
-(void)sc_setUpCustomSubViews{
    
}
/**
 *  @brief 子控件读取数据
 */
-(void)sc_loadParam:(id)param{
    
}
/**
 *  @brief 显示时间
 */
-(NSTimeInterval)sc_showTime{
    return SC_DEFAULT_SHOW_TIME;
}
/**
 *  @brief 滑动距离
 */
-(CGFloat)sc_slideDistance{
    return SC_SLIDE_DISTANCE;
}
/**
 *  @brief 震动距离
 */
-(CGFloat)sc_shakeDistance{
    return SC_SHAKE_DISTANCE;
}
/**
 *  @brief 出现动画时间
 */
-(NSTimeInterval)sc_showAnimationDuration{
    return SC_SHOW_ANIMATION_DURATION;
}
/**
 *  @brief 隐藏动画时间
 */
-(NSTimeInterval)sc_hideAnimationDuration{
    return SC_HIDE_ANIMATION_DURATION;
}

@end

@interface SCPromptManager()
/**
 *   注册信息
 */
@property (nonatomic,strong)NSMutableDictionary *registerInfo;
/**
 *   重用池
 */
@property (nonatomic,strong)NSMutableDictionary *reusableViewPool;
/**
 *   当前显示的view
 */
@property (nonatomic,strong)SCPromptView *showingView;
@end

@implementation SCPromptManager

-(NSMutableDictionary *)registerInfo{
    if (!_registerInfo) {
        _registerInfo = [NSMutableDictionary dictionary];
    }
    return _registerInfo;
}
-(NSMutableDictionary *)reusableViewPool{
    if (!_reusableViewPool) {
        _reusableViewPool = [NSMutableDictionary dictionary];
    }
    return _reusableViewPool;
}
+(instancetype)sharedManager{
    static SCPromptManager *_coreManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coreManager = [[SCPromptManager alloc] init];
        [_coreManager setUp];
    });
    return _coreManager;
}
/**
 *  @brief 初始化
 */
-(void)setUp{
    //添加接受命令观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedShowCommand:) name:SCPROMPT_SHOW_COMMAND object:nil];
}
/**
 *  @brief 注册视图类 必须为SCPromptView或子类
 *  @param viewClass 视图类别
 *  @param showCommand 显示命令
 */
-(void)registerPromptViewWithClass:(Class)viewClass forShowCommand:(NSString *)showCommand{
    NSAssert([viewClass isSubclassOfClass:[SCPromptView class]], @"注册的classs必须为SCPromptView的子类");
    [self.registerInfo setObject:NSStringFromClass(viewClass) forKey:showCommand];
}
/**
 *  @brief 通知显示promptView
 *  @param showCommand 绑定的显示命令
 *  @param param 参数
 */
-(void)showPromptViewWithCommand:(NSString *)showCommand param:(id)param{
    [[NSNotificationCenter defaultCenter] postNotificationName:SCPROMPT_SHOW_COMMAND object:param userInfo:@{SCPROMPT_SHOW_COMMAND:showCommand}];
}
/**
 *  @brief 接收到显示命令
 *  @param notification 命令通知
 */
-(void)didReceivedShowCommand:(NSNotification *)notification{
    NSString *showCommand = notification.userInfo[SCPROMPT_SHOW_COMMAND];
    id param = notification.object;
    NSString *className = self.registerInfo[showCommand];
    if (!className) {
        NSCAssert(0, @"showCommand:%@ 没有被注册",showCommand);
    }else{
        //生成
        SCPromptView *promptView = [self getReusableView:showCommand];
        if ([promptView respondsToSelector:@selector(sc_loadParam:)]) {
            [promptView sc_loadParam:param];
        }
        //显示
        promptView.frame = (CGRect){0,-64-SC_SLIDE_DISTANCE,[UIScreen mainScreen].bounds.size.width,64+SC_SLIDE_DISTANCE};
        promptView.contentView.frame = (CGRect){0,SC_SLIDE_DISTANCE,[UIScreen mainScreen].bounds.size.width,64+SC_SLIDE_DISTANCE};
        [self showInWindow:promptView];
    }
    
}
/**
 *  @brief 获取重用的view
 *  @param showCommand 唯一的显示命令
 *  @return SCPromptView
 */
-(SCPromptView *)getReusableView:(NSString *)showCommand{
    NSMutableArray *queueForCommand = self.reusableViewPool[showCommand];
    NSLog(@"%@",queueForCommand);
    if (queueForCommand && queueForCommand.count>0) {
        SCPromptView *reusableView = queueForCommand.firstObject;
        [queueForCommand removeObject:reusableView];
        self.reusableViewPool[showCommand] = queueForCommand;
        return reusableView;
    }else{
        NSString *className = self.registerInfo[showCommand];
        Class viewClass = NSClassFromString(className);
        //生成
        SCPromptView *promptView = [[viewClass alloc]init];
        if ([promptView respondsToSelector:@selector(sc_setUpCustomSubViews)]) {
            [promptView sc_setUpCustomSubViews];
        }
        promptView.showComand = showCommand;
        return promptView;
    }
}
/**
 *  @brief 显示
 *  @param promptView 显示的视图
 */
-(void)showInWindow:(SCPromptView *)promptView{
    [[[UIApplication sharedApplication].delegate window] addSubview:promptView];
    [UIView animateWithDuration:[promptView sc_showAnimationDuration] animations:^{
       promptView.frame = (CGRect){0,0,promptView.bounds.size};
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            promptView.frame = (CGRect){0,-[promptView sc_slideDistance]-3,promptView.bounds.size};
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                promptView.frame = (CGRect){0,-[promptView sc_slideDistance],promptView.bounds.size};
            } completion:^(BOOL finished) {
                self.showingView = promptView;
                [self delayhideInWindow:promptView];
            }];
        }];
    }];
}
/**
 *  @brief 动画式隐藏
 *  @param promptView 隐藏的视图
 */
-(void)delayhideInWindow:(SCPromptView *)promptView{
    if(!promptView.superview) return;
    [UIView animateWithDuration:[promptView sc_hideAnimationDuration] delay:[promptView sc_showTime] options:0 animations:^{
        promptView.frame = (CGRect){0,-64-[promptView sc_slideDistance],promptView.bounds.size};
    } completion:^(BOOL finished) {
        [self hideInWindowDirectly:promptView];
    }];
}
/**
 *  @brief 直接隐藏
 *  @param promptView 隐藏的视图
 */
-(void)hideInWindowDirectly:(SCPromptView *)promptView{
    if(!promptView.superview) return;
    [promptView removeFromSuperview];
    NSMutableArray *queueForCommand = self.reusableViewPool[promptView.showComand];
    if (!queueForCommand)queueForCommand = [NSMutableArray array];
    [queueForCommand addObject:promptView];
    [self.reusableViewPool setObject:queueForCommand forKey:promptView.showComand];
}
/**
 *  @brief 设置当前正在显示的视图
 *  @param showingView 正在显示的视图
 */
-(void)setShowingView:(SCPromptView *)showingView{
    SCPromptView *currentShowingView = _showingView;
    if (currentShowingView) {
        [self hideInWindowDirectly:currentShowingView];
    }
    _showingView = showingView;
}
@end
