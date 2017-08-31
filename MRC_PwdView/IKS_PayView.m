//
//  IKS_PayView.m
//  IKS_Express
//
//  Created by Mr.陈 on 2017/8/30.
//  Copyright © 2017年 XLKD. All rights reserved.
//

#define VIEW_WIDTH [UIScreen  mainScreen].bounds.size.width
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height

#define DEFALUT_COLOR [[UIColor blackColor]colorWithAlphaComponent:0.75]

#define PWD_MAX_LENGTH 6

#import "IKS_PayView.h"
@interface IKS_PayView ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *view_Pwd;
@property (strong, nonatomic) IBOutlet UITextField *tf_Pwd;
@property (strong, nonatomic) IBOutlet UIButton *but_Select;
@property (nonatomic ,strong) UIControl *control;
@property (nonatomic , strong) NSMutableArray *blackArr;
@property (nonatomic ,assign) NSUInteger old_Length;


@end

static float view_H = 300 ;

@implementation IKS_PayView
+(IKS_PayView *)instance
{
    NSArray *nibView=[[NSBundle mainBundle]loadNibNamed:@"IKS_PayView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, VIEW_HEIGHT, VIEW_WIDTH, 0)];
    if (self) {
        self.frame = frame;
        
        self.old_Length = 0;
        ;
        self.view_Pwd.layer.borderColor = DEFALUT_COLOR.CGColor;
        self.view_Pwd.layer.borderWidth = 0.5;
        self.tf_Pwd.delegate = self;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tf_First_Reponse)];
        ges.numberOfTouchesRequired = 1;
        ges.numberOfTapsRequired = 1;
        [self.view_Pwd addGestureRecognizer:ges];
        [self createBlackPointView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFeildDidChange) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    return self;
}
#pragma mark 关闭支付界面
- (IBAction)closeMethod:(id)sender {
    [self hiddenPwd];
}
#pragma mark 点击进行其他操作

- (IBAction)otherClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(otherClick)]) {
        [self.delegate otherClick];
    }
}
- (IBAction)forgotPwd:(id)sender {
    if ([self.delegate respondsToSelector:@selector(forgotPwd)]) {
        [self.delegate forgotPwd];
    }
}

#pragma mark 密码输入判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > PWD_MAX_LENGTH) {
        return NO;
    }
    return YES;
}
- (void)textFeildDidChange{
    
    if ([self.delegate respondsToSelector:@selector(currentInputPwd:)]) {
        [self.delegate currentInputPwd:self.tf_Pwd.text];
    }
    
    NSUInteger length = [self.tf_Pwd.text length];
    
    if (self.blackArr.count < length || self.blackArr.count < self.old_Length) {
        return;
    }
    if (length > self.old_Length) {
        UIView *view = self.blackArr[length - 1];
        view.hidden = NO;
    }else{
        if (self.old_Length == 0) {
            return;
        }
        UIView *view = self.blackArr[self.old_Length - 1];
        view.hidden = YES;
    }
    self.old_Length = length;
    
    if (length == PWD_MAX_LENGTH) {
        
        [self.tf_Pwd resignFirstResponder];
        
        if ([self.delegate respondsToSelector:@selector(finishPwd:)]) {
            [self.delegate finishPwd:self.tf_Pwd.text];
        }
    }
}
#pragma mark 加载动画
- (void)showInView:(UIView *)view{
    [view addSubview:self.control];
    [view addSubview:self];
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.32 animations:^{
        __strong typeof(self)strong = weak;
        strong.frame = CGRectMake(0, VIEW_HEIGHT - view_H, VIEW_WIDTH, view_H);
        strong.control.alpha = 1;
    }completion:^(BOOL finished) {
         __strong typeof(self)strong = weak;
        [strong.tf_Pwd becomeFirstResponder];
    }];
}
#pragma mark 隐藏
- (void)hiddenPwd{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.tf_Pwd resignFirstResponder];
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.32 animations:^{
        __strong typeof(self)strong = weak;
        strong.control.alpha = 0;
        strong.frame = CGRectMake(0, VIEW_HEIGHT, VIEW_WIDTH, view_H);
    }completion:^(BOOL finished) {
        __strong typeof(self)strong = weak;
        [strong.control removeFromSuperview];
        [strong removeFromSuperview];
    }];
}
- (void)touchMethod{
    [self hiddenPwd];
}
#pragma mark 输入框响应
- (void)tf_First_Reponse{
    [self.tf_Pwd becomeFirstResponder];
}
- (void)createBlackPointView{
    
    self.control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenPwd)];
    ges.numberOfTouchesRequired = 1;
    ges.numberOfTapsRequired = 1;
    [self.control addGestureRecognizer:ges];
    self.control.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.control.alpha = 0;
    
    float max_Width = VIEW_WIDTH - 20;
    
    float max_Height = 50;
    
    float piece_Width = max_Width/PWD_MAX_LENGTH; // 每个格子间距
    
    
    for (int i = 0; i < PWD_MAX_LENGTH - 1; i++) {
        //创建中间间隔线
        
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(piece_Width *i + piece_Width, 0, 0.5, max_Height);
        view.userInteractionEnabled = NO;
        view.layer.backgroundColor = DEFALUT_COLOR.CGColor;
        [self.view_Pwd addSubview:view];
    }
    
    float piece_Size = 25;
    
    for (int i = 0 ; i < PWD_MAX_LENGTH; i++) {
        //创建黑点
        UIView *blackView = [[UIView alloc]init];
        blackView.frame = CGRectMake( piece_Width * i + (piece_Width - piece_Size) / 2 , piece_Size / 2, piece_Size, piece_Size );
        blackView.userInteractionEnabled = NO;
        blackView.backgroundColor = [UIColor blackColor];
        blackView.layer.cornerRadius = (max_Height - piece_Size)/2;
        blackView.layer.masksToBounds  = YES;
        blackView.hidden = YES;
         [self.view_Pwd addSubview:blackView];
        
        [self.blackArr addObject:blackView];
    }
    
}
- (NSMutableArray *)blackArr{
    if (!_blackArr) {
        _blackArr = [NSMutableArray arrayWithCapacity:6];
    }
    return _blackArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
