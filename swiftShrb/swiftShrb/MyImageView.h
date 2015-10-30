//
//  MyImageView.h
//  shrb
//
//  Created by PayBay on 15/7/24.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyImageView : UIImageView

@property(assign, readwrite, nonatomic)NSInteger currentInt;
@property(readwrite, nonatomic)NSMutableArray *imageArr;

- (void)initImageArr;
- (void)beginAnimation;
@end
