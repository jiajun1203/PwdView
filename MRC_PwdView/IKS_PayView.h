//
//  IKS_PayView.h
//  IKS_Express
//
//  Created by Mr.陈 on 2017/8/30.
//  Copyright © 2017年 XLKD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IKS_Pwd_Delegate <NSObject>
//当前输入密码(不判断是否完成)
- (void)currentInputPwd:(NSString *)pwd;
//密码输入完成返回
- (void)finishPwd:(NSString *)pwd;
//忘记密码
- (void)forgotPwd;
//点击进行其他操作
- (void)otherClick;

@end

@interface IKS_PayView : UIView
+(IKS_PayView *)instance;

@property (nonatomic ,weak) id <IKS_Pwd_Delegate>delegate;

/**
 展示 密码输入界面

 @param view 要展示到的view
 */
- (void)showInView:(UIView *)view;

/**
 注销密码输入界面
 */
- (void)hiddenPwd;
@end
