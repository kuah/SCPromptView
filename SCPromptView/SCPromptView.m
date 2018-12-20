//
//  SCPromptView.m
//  SCPromptViewDemo
//
//  Created by 陈世翰 on 17/3/9.
//  Copyright © 2017年 Coder Chan. All rights reserved.
//

#import "SCPromptView.h"
#define SC_SLIDE_DISTANCE 18
#define SC_DEFAULT_SHOW_TIME 2
#define SC_SHOW_ANIMATION_DURATION 0.35
#define SC_HIDE_ANIMATION_DURATION 0.2
#define SC_CONTENT_HEIGHT (lt_iPhoneX()?88:64)

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
    self.frame = (CGRect){0,0,[UIScreen mainScreen].bounds.size.width,SC_CONTENT_HEIGHT+[self sc_slideDistance]};
    self.contentView.frame = (CGRect){0,[self sc_slideDistance],[UIScreen mainScreen].bounds.size.width,SC_CONTENT_HEIGHT};
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
/**
 *  @brief 即将执行由手势触发的隐藏
 *  @return yes 隐藏 / no 不隐藏
 */
-(BOOL)sc_willHideByTap{
    return YES;
}
/**
 *  @brief 滑动距离 仅仅用于震动动画时候遮挡上一个的view
 */
-(CGFloat)sc_slideDistance{
    return SC_SLIDE_DISTANCE;
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
    if ([NSThread isMainThread]) {
        [self matchWithShowCommand:showCommand param:param];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self matchWithShowCommand:showCommand param:param];
        });
    }
}
/**
 *  @brief 匹配显示命令和参数
 *  @param showCommand 显示命令
 *  @param param 参数
 */
-(void)matchWithShowCommand:(NSString *)showCommand param:(id)param{
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
        promptView.frame = (CGRect){0,-SC_CONTENT_HEIGHT-[promptView sc_slideDistance],[UIScreen mainScreen].bounds.size.width,SC_CONTENT_HEIGHT+[promptView sc_slideDistance]};
        promptView.contentView.frame = (CGRect){0,[promptView sc_slideDistance],[UIScreen mainScreen].bounds.size.width,SC_CONTENT_HEIGHT};
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
    if (queueForCommand && queueForCommand.count>1) {
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
-(void)tapToHide:(UITapGestureRecognizer *)target{
    SCPromptView *promptView = (SCPromptView *)target.view;
    if ([promptView sc_willHideByTap]) {
        [self hideInWindow:promptView];
    }
}
/**
 *  @brief 显示
 *  @param promptView 显示的视图
 */
-(void)showInWindow:(SCPromptView *)promptView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInWindow:) object:nil];
    [[[UIApplication sharedApplication].delegate window] addSubview:promptView];
    if (!promptView.gestureRecognizers || promptView.gestureRecognizers.count==0) {
        [promptView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide:)]];
    }
    [UIView animateWithDuration:[promptView sc_showAnimationDuration] delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut animations:^{
         promptView.frame = (CGRect){0,-[promptView sc_slideDistance],promptView.bounds.size};
    } completion:^(BOOL finished) {
        [self delayhideInWindow:promptView];
    }];
}
/**
 *  @brief 动画式隐藏
 *  @param promptView 隐藏的视图
 */
-(void)delayhideInWindow:(SCPromptView *)promptView{
    if(!promptView.superview){
     return;
    }
    //关闭之前的收起的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInWindow:) object:promptView];
    //设置showingView，把后面的直接从window remove
    self.showingView = promptView;
    [self performSelector:@selector(hideInWindow:) withObject:promptView afterDelay:[promptView sc_showTime] ];
}
/**
 *  @brief 动画隐藏promptView
 *  @param promptView 隐藏的view
 */
-(void)hideInWindow:(SCPromptView *)promptView{
    //不是最顶层的view则不管
     if (self.showingView != promptView)return;
    [UIView animateWithDuration:[promptView sc_hideAnimationDuration] animations:^{
        promptView.frame = (CGRect){0,-SC_CONTENT_HEIGHT-[promptView sc_slideDistance],promptView.bounds.size};
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
BOOL lt_iPhoneX(){
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    if (statusBarFrame.size.height > 20.f) {
        return YES;
    }
    return NO;
}
@end
