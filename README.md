# SCPromptView
![](https://upload-images.jianshu.io/upload_images/2170902-b6fb40eefb87214e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
[SCPromptView](https://github.com/Chan4iOS/SCPromptView) : 显示在顶部的提示控件
[SCPromptView-Swift](https://github.com/Chan4iOS/SCPromptView-Swift)

>**你的star是我最大的动力**

<!--##效果-->
<!--![effect.gif](http://upload-images.jianshu.io/upload_images/2170902-85ffe61c9e99f291.gif?imageMogr2/auto-orient/strip)-->

## 安装
### 手动安装
下载源码，将`SCPromptView `文件夹拖进项目

### CocoaPod
```
pod 'SCPromptView'
```

## 使用
SCPromptView 的用法，与tableView相似
#### 创建view
```
#import "SCPromptView.h"

@interface TestPromptView : SCPromptView

@end
#import "TestPromptView.h"

@interface TestPromptView()
/**
 *   label
 */
@property (nonatomic,strong)UILabel *textLabel;
@end

@implementation TestPromptView
//初始化子控件
-(void)sc_setUpCustomSubViews{
    self.backgroundColor=  [UIColor colorWithRed:(arc4random()%255)/255.f green:(arc4random()%255)/255.f blue:(arc4random()%255)/255.f alpha:1];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:textLabel];
    self.textLabel = textLabel;
}
//读取参数
-(void)sc_loadParam:(id)param{
    NSString *text = param;
    self.textLabel.text = text;
}
@end
```
重写两个基础方法

#### 注册
```
SCPROMPT_REGISTER([TestPromptView class],@"test")
SCPROMPT_REGISTER([ResultPromptView class], @"result")
```
#### 发送显示命令
```
///随机颜色显示
-(void)clickBtn:(id)sender{
    NSString * text =[NSString stringWithFormat:@"%d",_num];
    SCPROMPT_SHOW(@"test",text)
    _num++;
}
```

## 其他Api
```
@protocol SCPromptViewDelegate <NSObject>
@required
/**
 *  @brief 添加自定义的子控件
 */
-(void)sc_setUpCustomSubViews;
/**
 *  @brief 子控件读取数据
 */
-(void)sc_loadParam:(id)param;

@optional
/**
 *  @brief 显示时间
 */
-(NSTimeInterval)sc_showTime;
/**
 *  @brief 滑动距离
 */
-(CGFloat)sc_slideDistance;
/**
 *  @brief 震动距离
 */
-(CGFloat)sc_shakeDistance;
/**
 *  @brief 出现动画时间
 */
-(NSTimeInterval)sc_showAnimationDuration;
/**
 *  @brief 隐藏动画时间
 */
-(NSTimeInterval)sc_hideAnimationDuration;
/**
 *  @brief 即将执行由手势触发的隐藏
 *  @return yes 隐藏 / no 不隐藏
 */
-(BOOL)sc_willHideByTap;

@end
```


# SCPromptView
[SCPromptView](https://github.com/Chan4iOS/SCPromptView)  : A prompt view which show in the top of the screen .


>**Your star is my biggest motivation.**

<!--##Effect

![effect.gif](http://upload-images.jianshu.io/upload_images/2170902-85ffe61c9e99f291.gif?imageMogr2/auto-orient/strip)-->

## Install
### Manually
Download the source code , copy  folder `SCPromptView` into your project.
### CocoaPod
```
pod 'SCPromptView'
```

## Usage
The usage of SCPromptView is similar to the usage of UITableView.
#### Create Custom View
```
#import "SCPromptView.h"

@interface TestPromptView : SCPromptView

@end
#import "TestPromptView.h"

@interface TestPromptView()
/**
 *   label
 */
@property (nonatomic,strong)UILabel *textLabel;
@end

@implementation TestPromptView
//setUp subviews
-(void)sc_setUpCustomSubViews{
    self.backgroundColor=  [UIColor colorWithRed:(arc4random()%255)/255.f green:(arc4random()%255)/255.f blue:(arc4random()%255)/255.f alpha:1];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:textLabel];
    self.textLabel = textLabel;
}
//loadParam which you deliver via command
-(void)sc_loadParam:(id)param{
    NSString *text = param;
    self.textLabel.text = text;
}
@end
```
Override two basic function.

#### Register
```
SCPROMPT_REGISTER([TestPromptView class],@"test")
SCPROMPT_REGISTER([ResultPromptView class], @"result")
```
#### 发送显示命令
```
///show random color
-(void)clickBtn:(id)sender{
    NSString * text =[NSString stringWithFormat:@"%d",_num];
    SCPROMPT_SHOW(@"test",text)
    _num++;
}
```
## Other Api
```
@protocol SCPromptViewDelegate <NSObject>
@required
/**
 *  @brief 添加自定义的子控件
 */
-(void)sc_setUpCustomSubViews;
/**
 *  @brief 子控件读取数据
 */
-(void)sc_loadParam:(id)param;

@optional
/**
 *  @brief 显示时间
 */
-(NSTimeInterval)sc_showTime;
/**
 *  @brief 滑动距离
 */
-(CGFloat)sc_slideDistance;
/**
 *  @brief 震动距离
 */
-(CGFloat)sc_shakeDistance;
/**
 *  @brief 出现动画时间
 */
-(NSTimeInterval)sc_showAnimationDuration;
/**
 *  @brief 隐藏动画时间
 */
-(NSTimeInterval)sc_hideAnimationDuration;
/**
 *  @brief 即将执行由手势触发的隐藏
 *  @return yes 隐藏 / no 不隐藏
 */
-(BOOL)sc_willHideByTap;

@end
```
