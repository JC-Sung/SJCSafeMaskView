//
//  SafeMaskView.m
//  jewelry
//
//  Created by 时光与你 on 2018/8/14.
//  Copyright © 2018年 Yehwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeMaskView : NSObject
//@property (nonatomic,strong) UIVisualEffectView *visualEffectView;//毛玻璃效果
@property (nonatomic, strong) UIImageView *maskView;
@end

@implementation SafeMaskView

//+ (void)load{
//    [self shareManager];
//}

+(SafeMaskView *)shareManager{
    static SafeMaskView *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self show];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self dismiss];
        }];
    }
    return self;
}

- (void)show{
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    self.visualEffectView.frame = [UIApplication sharedApplication].keyWindow.frame;
    
    self.maskView.alpha = 1;
    self.maskView.image = [[[UIApplication sharedApplication].keyWindow snapshotImageAfterScreenUpdates:NO] blurImageWithRadius:4];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    
//    [[UIApplication sharedApplication].keyWindow addSubview:self.visualEffectView];
}

- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc] init];
        _maskView.frame = [UIApplication sharedApplication].keyWindow.frame;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _maskView.height-44, _maskView.width, 44)];
        bottomView.backgroundColor = WhiteColor;
        [_maskView addSubview:bottomView];
        UILabel *tip = [[UILabel alloc] initWithFrame:bottomView.bounds];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        tip.numberOfLines = 1;
        NSString *str = @"  Yehwang International Trade Co.,Ltd.";
        NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:str];
        [attri addAttributes:@{NSForegroundColorAttributeName:UIColor.grayColor,NSFontAttributeName:PoppinsRegular(12)} range:NSMakeRange(0, str.length)];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"logo_1024"];
        attch.bounds = CGRectMake(0, -10, 30, 30);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];
        tip.attributedText = attri;
        [bottomView addSubview:tip];
    }
    return _maskView;
}

- (void)dismiss{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.maskView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.maskView removeFromSuperview];
//    }];
    
    [UIView animateWithDuration:0.2 delay:0.f usingSpringWithDamping:0.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
