//
//  HJCAjustNumButton.m
//  HJCAdjustButtonTest
//
//  Created by HJaycee on 15/6/4.
//  Copyright (c) 2015年 HJaycee. All rights reserved.
//

#import "HJCAjustNumButton.h"


@interface HJCAjustNumButton ()
{
    UIButton *_decreaseBtn;
    UIButton *_increaseBtn;
    UITextField *_textField;
    UIView *_oneLine;
    UIView *_twoLine;
    NSTimer *_timer;
}

@end

@implementation HJCAjustNumButton

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self commonSetup];
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    
    self.layer.borderColor = [lineColor CGColor];
    _oneLine.backgroundColor = lineColor;
    _twoLine.backgroundColor = lineColor;
}

- (void)setCurrentNum:(NSString *)currentNum{
    _textField.text = currentNum;
}

- (NSString *)currentNum{
    return _textField.text;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    UIColor *lineColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    
    self.frame = CGRectMake(0, 0, 30, 30);
  //  self.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1];
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [lineColor CGColor];
    
    _oneLine = [[UIView alloc] init];
    _oneLine.backgroundColor = lineColor;
   // [self addSubview:_oneLine];
    
    _twoLine = [[UIView alloc] init];
    _twoLine.backgroundColor = lineColor;
   // [self addSubview:_twoLine];
    
    _decreaseBtn = [[UIButton alloc] init];
    [self setupButton:_decreaseBtn normalImage:@"decrease" HighlightImage:@"decrease"];
   // [self addSubview:_decreaseBtn];
    
    _increaseBtn = [[UIButton alloc] init];
    [self setupButton:_increaseBtn normalImage:@"increase" HighlightImage:@"increase"];
    [self addSubview:_increaseBtn];
    
    _textField = [[UITextField alloc] init];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    _textField.text = @"0";
  //  [self addSubview:_textField];
    
    [self commonSetup];
}

- (void)commonSetup{
    CGFloat viewH = self.frame.size.height;
    CGFloat viewW = self.frame.size.width;
    
    _oneLine.frame = CGRectMake(viewH, 0, 1, viewH);
    _decreaseBtn.frame = CGRectMake(0, 0, viewH, viewH);
    _twoLine.frame = CGRectMake(viewW - viewH, 0, 1, viewH);
    _increaseBtn.frame = CGRectMake(viewW - viewH, 0, viewH, viewH);
    _textField.frame = CGRectMake(viewH, 0, viewW - viewH * 2, viewH);
}

- (void)setupButton:(UIButton *)btn normalImage:(NSString *)norImage HighlightImage:(NSString *)highImage{
    
    [btn setBackgroundImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
   // [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
   // [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
    
}

- (void)btnTouchDown:(UIButton *)btn{
    [_textField resignFirstResponder];
    
    [self increase];
//    if (btn == _increaseBtn) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(increase) userInfo:nil repeats:YES];
//    } else {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(decrease) userInfo:nil repeats:YES];
//    }
//    [_timer fire];
//    
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:nil];
//    [self performSelector:@selector(todoSomething:) withObject:btn afterDelay:0.4f];
}

- (void)btnTouchUpInside:(UIButton *)btn{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:nil];
    [self performSelector:@selector(todoSomething:) withObject:btn afterDelay:1.0f];
    
    [self increase];
}

- (void)todoSomething:(UIButton *)btn
{
    
}

- (void)btnTouchUp:(UIButton *)btn{
    
    [self cleanTimer];
}

- (void)increase{
    if (_textField.text.length == 0) {
        _textField.text = @"1";
    }
    int newNum = [_textField.text intValue] + 1;
    _textField.text = [NSString stringWithFormat:@"%i", newNum];
    self.callBack(_textField.text);
}

- (void)decrease{
    if (_textField.text.length == 0) {
        _textField.text = @"1";
    }
    int newNum = [_textField.text intValue] -1;
    if (newNum >= 0) {
        _textField.text = [NSString stringWithFormat:@"%i", newNum];
        self.callBack(_textField.text);
    } else {
        NSLog(@"num can not less than 0");
    }
}

- (UIImage *)readImageFromBundle:(NSString *)imageName{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"HJCAdjustNumButton.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *(^getBundleImage)(NSString *) = ^(NSString *n) {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:n ofType:@"png"]];
    };
    UIImage *myImg = getBundleImage(imageName);
    return myImg;
}

- (void)dealloc{
    [self cleanTimer];
}

- (void)cleanTimer{
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
