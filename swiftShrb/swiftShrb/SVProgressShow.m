//
//  SVProgressShow.m
//  swiftShrb
//
//  Created by PayBay on 15/10/12.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "SVProgressShow.h"
#import "SVProgressHUD.h"


@implementation SVProgressShow

+ (void)setBackgroundColorAndForegroundColor
{
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:18.0]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}

+ (void)showWithStatus:(NSString *)status
{
    [self setBackgroundColorAndForegroundColor];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showSuccessWithStatus:(NSString *)string
{
    [self setBackgroundColorAndForegroundColor];
    [SVProgressHUD showSuccessWithStatus:string];
}

+ (void)showErrorWithStatus:(NSString *)string
{
    [self setBackgroundColorAndForegroundColor];
    [SVProgressHUD showErrorWithStatus:string];
}

+ (void)showInfoWithStatus:(NSString *)string
{
    [self setBackgroundColorAndForegroundColor];
    [SVProgressHUD showInfoWithStatus:string];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}


@end
