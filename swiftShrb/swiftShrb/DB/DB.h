//
//  DB.h
//  Mercury
//
//  Created by Wan Wei on 15/1/13.
//  Copyright (c) 2015年 GangXu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class Message;
@interface DB : FMDatabase

+ (instancetype)openDb;
+ (NSString *)dbPath;
+ (NSString *)dbPathFor:(NSString *) user;
+ (void)setDbUserId:(NSString *)user;

- (BOOL)insertChatWithId:(NSString *)chatId Title:(NSString *)title Avatar:(NSString *)avatar  message:(Message *)message;

- (BOOL)insertChatWithArtistId:(NSString *)artistId customerId:(NSString *)customerId avatar:(NSString *)avatar  status:(NSString *)status  chatId:(NSString *)chatId  title:(NSString *)title tryAt:(NSString *)tryAtTime tryEnd:(NSString *)tryEndTime statAtTime:(NSString *)statAtTime  endAtTime:(NSString *)endAtTime orderId:(NSNumber *)current_order_id;

-(BOOL)insertChatWithUpdateMessage:(Message *)message;
@end
