//
//  MyImageView.m
//  shrb
//
//  Created by PayBay on 15/7/24.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "MyImageView.h"
#import "UIImageView+WebCache.h"

@interface MyImageView ()
{
    NSInteger  _currentInt;
    NSMutableArray *_imageArr;
    //  CAGradientLayer *_gradientLayer;
    //  UIView *_containerView;
    CGRect _oldframe;
    
    UIImageView *_imageView;
}


@end

@implementation MyImageView


- (void)setCurrentInt:(NSInteger)currentInt
{
    _currentInt = currentInt;
}

- (void)initImageArr
{
    _imageArr = [[NSMutableArray alloc] init];
    _imageView = [[UIImageView alloc] init];
    
}

- (void)beginAnimation
{
    //    _gradientLayer = [CAGradientLayer layer];
    //    _gradientLayer.frame = CGRectMake(0, 0,screenWidth*2 , 250);
    //    _gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,
    //                             (__bridge id)[UIColor colorWithWhite:0.1 alpha:0.8].CGColor,
    //                             (__bridge id)[UIColor blackColor].CGColor,
    //                             ];
    //    _gradientLayer.locations = @[@(0.4),@(0.5),@(0.6)];
    //    _gradientLayer.startPoint = CGPointMake(0, 0);
    //    _gradientLayer.endPoint = CGPointMake(1, 0);
    //
    //
    //    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenWidth*2 , 250)];
    //    [_containerView.layer addSublayer:_gradientLayer];
    //
    //    if (IsIOS8) {
    //       // self.maskView = _containerView;
    //        _oldframe= _containerView.frame;
    //        _oldframe.origin.x -=screenWidth;
    //        _containerView.frame = _oldframe;
    //
    //    }
    
    
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_imageArr objectAtIndex:_currentInt]]];
    
    [self sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:_currentInt]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
    
    [self timeForShowImage];
}


- (void)timeForShowImage
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextImage) object:nil];
    [self performSelector:@selector(nextImage)
               withObject:nil
               afterDelay:(arc4random() % 3)+3];
}

- (void)nextImage
{
    _currentInt++;
    if (_currentInt == [_imageArr count]) {
        _currentInt = 0;
    }
    _imageView = self;
    
    [self sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:_currentInt]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
    
    CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
    contentsAnimation.fromValue = _imageView;
    contentsAnimation.toValue = self;
    contentsAnimation.duration = 1.f;
    contentsAnimation.delegate = self;
    contentsAnimation.fillMode=kCAFillModeForwards;
    contentsAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:contentsAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
   // [self sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:_currentInt]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
    
    [self timeForShowImage];
    
}

@end
