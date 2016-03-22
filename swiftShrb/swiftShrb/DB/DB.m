//
//  DB.m
//  Mercury
//
//  Created by Wan Wei on 15/1/13.
//  Copyright (c) 2015年 GangXu. All rights reserved.
//

#import "DB.h"
static NSString *userId = nil;

@implementation DB


+ (instancetype)openDb {
    NSString* dbPath = [DB dbPath];

    DB *db= [[DB alloc] initWithPath:dbPath];
    [db open];
    return db;
}

+ (NSString *)dbPathFor:(NSString *) user {
    NSString* docsDir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* userDocDir = [docsDir stringByAppendingPathComponent:user];
    
    NSLog(userDocDir);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDocDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userDocDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [userDocDir stringByAppendingPathComponent:@"mercury.db"];
}

+ (NSString *)dbPath {
//    if (userId == nil) {
//        return nil;
//    }
    return [DB dbPathFor: @"123"];
}

+ (void)setDbUserId:(NSString *)user {
    NSAssert([user isKindOfClass:[NSString class]], @"user is not nsstring");
    userId = [user copy];
}

- (BOOL)insertChatWithId:(NSString *)chatId Title:(NSString *)title Avatar:(NSString *)avatar  message:(Message *)message{
    if (title == nil) {
//        NSLog(@"chat title is null");
        return NO;
    }
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *now = [NSNumber numberWithDouble: timeStamp];
    
    __block BOOL result=NO;

    
//    MPObject *object = [MPObject objectWithoutDataWithClassName:@"chat" objectId:chatId];
//    
//    [object fetchInBackgroundWithBlock:^(MPObject *object, NSError *error) {
//        
////        NSLog(@"%@",object);
//        if (error!=nil) {
//            result=NO;
//            return ;
//        }
//        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//        formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
//        NSDate *date=[formatter dateFromString:object[@"try_at"]];
//        NSTimeInterval timeStamp =[date timeIntervalSince1970];
//        NSNumber *tay_atNum=[NSNumber numberWithDouble:timeStamp];
//        NSNumber *tryEndTime=[NSNumber numberWithDouble: timeStamp];
//        
//        NSDate *start_atDate=[formatter dateFromString:object[@"start_at"]];
//        NSTimeInterval start_atTimeStamp =[start_atDate timeIntervalSince1970];
//        NSNumber *start_atNum=[NSNumber numberWithDouble:start_atTimeStamp];
//        
//        NSDate *end_atDate=[formatter dateFromString:object[@"end_at"]];
//        NSTimeInterval end_atTimeStamp =[end_atDate timeIntervalSince1970];
//        NSNumber *end_atNum=[NSNumber numberWithDouble:end_atTimeStamp];
//        [self open];
//        result= [self executeUpdate:@"INSERT INTO chats (id, type, title, avatar, new_messages_count, \
//                 last_message, last_sender_name, last_sent_at, \
//                 created_at, updated_at,artist_id,customer_id,try_at,try_end,status,current_order_id,start_at,end_at) VALUES (?,?,?,?,?,'','',0, ?,?  ,?,?,?,?,?,?,?,?)",
//                 chatId, @(1), title, avatar, @(1), now, now,object[@"artist_id"],object[@"customer_id"],tay_atNum,tryEndTime,object[@"status"],object[@"current_order_id"],start_atNum,end_atNum];
//        
//        result&= [self executeUpdate:@"UPDATE chats set last_message = ?, last_sender_name = ?, last_sent_at = ?,new_messages_count=new_messages_count  where id=?",
//              [message text], message.senderName, message.sentAt, message.chatId];
//        
//        if (result) {
//              [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChatCreated object:chatId];
//        }
//
//        [self close];
//        
//        
//    }];
    
    return result;

}

- (BOOL)insertChatWithArtistId:(NSString *)artistId customerId:(NSString *)customerId avatar:(NSString *)avatar  status:(NSString *)status  chatId:(NSString *)chatId  title:(NSString *)title tryAt:(NSString *)tryAtTime tryEnd:(NSString *)tryEndTime statAtTime:(NSString *)statAtTime  endAtTime:(NSString *)endAtTime orderId:(NSNumber *)current_order_id{

     NSDate *date=[NSDate date];
     NSTimeInterval time =[date timeIntervalSince1970];
     NSNumber *now=[NSNumber numberWithDouble:time];
    if ([tryAtTime doubleValue]>0) {
        tryEndTime=[NSString stringWithFormat:@"%lf",[tryAtTime doubleValue]+60*15];
    }
    
    return [self executeUpdate:@"INSERT INTO chats (id, type, title, avatar, new_messages_count, \
            last_message, last_sender_name, last_sent_at, \
            created_at, updated_at,artist_id,customer_id,try_at,try_end,start_at,end_at,status,current_order_id) VALUES (?,?,?,?,?,'','',0, ?,? ,?,?,?,?,?,?,?,?)",
            chatId, @(1), title, avatar, @(1), now, now,artistId,customerId,tryAtTime,tryEndTime,statAtTime,endAtTime,status,current_order_id];
}


-(BOOL)insertChatWithUpdateMessage:(Message *)message{

    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *now = [NSNumber numberWithDouble: timeStamp];

//    if (message.subType==MESSAGE_ST_CE_CHAT_UPDATE) {
//       return  [self executeUpdate:@"INSERT INTO chats (id, type, title, avatar, new_messages_count, \
//         last_message, last_sender_name, last_sent_at, \
//         created_at, updated_at,try_at,try_end,start_at,end_at,current_order_id) VALUES (?,?,?,?,?,'','',0, ?,?,?,?,?,?,?)",
//                message.chatId, @(1), message.senderName, message.senderAvatar, @(1), now, now,message.body[@"try_at"],message.body[@"try_at"],message.body[@"start_at"],message.body[@"end_at"],message.body[@"current_order_id"]];
//    }
    
    return NO;
}

@end
