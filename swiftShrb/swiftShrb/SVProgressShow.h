//
//  SVProgressShow.h
//  swiftShrb
//
//  Created by PayBay on 15/10/12.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVProgressShow : NSObject

+ (void)setBackgroundColorAndForegroundColor;
+ (void)showWithStatus:(NSString *)status;
+ (void)showSuccessWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showInfoWithStatus:(NSString *)string;
+ (void)dismiss;

@end
