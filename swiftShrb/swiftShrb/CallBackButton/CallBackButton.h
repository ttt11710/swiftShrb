//
//  CallBackButton.h
//  shrb
//
//  Created by PayBay on 15/8/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallBackButton : UIButton

@property (nonatomic, copy) void (^callBack) (NSInteger tag);

- (void)setupBlock;

@end
