//
//  CallBackButton.m
//  shrb
//
//  Created by PayBay on 15/8/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "CallBackButton.h"

@implementation CallBackButton

- (void)setupBlock
{
    [self addTarget:self action:@selector(block:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)block:(UIButton *)sender
{
    self.callBack(sender.tag);
}

@end
