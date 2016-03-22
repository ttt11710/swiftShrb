//
//  CreateChannel.m
//  quan-iphone
//
//  Created by Wan Wei on 14-4-20.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//

#import "Migrations.h"

@implementation M1CreateChannel


//id: 1,
//artist_id: 1,
//customer_id: 11,
//last_message: "",
//last_send_at: "0000-00-00 00:00:00",
//status: 2,
//try_at: "0000-00-00 00:00:00",
//start_at: "0000-00-00 00:00:00",
//end_at: "0000-00-00 00:00:00",
//current_order_id: 1
- (void)up {
    [self createTable:@"chats" withColumns:[NSArray arrayWithObjects:
                                               [FmdbMigrationColumn columnWithColumnName:@"type" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"title" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"avatar" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"new_messages_count" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"last_message" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"last_sender_name" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"last_sent_at" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"created_at" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"updated_at" columnType:@"string"],
                                             [FmdbMigrationColumn columnWithColumnName:@"artist_id" columnType:@"integer"],
                                             [FmdbMigrationColumn columnWithColumnName:@"customer_id" columnType:@"integer"],
                                             [FmdbMigrationColumn columnWithColumnName:@"status" columnType:@"integer"],
                                             [FmdbMigrationColumn columnWithColumnName:@"try_at" columnType:@"string"],
                                             [FmdbMigrationColumn columnWithColumnName:@"try_end" columnType:@"string"],
                                             [FmdbMigrationColumn columnWithColumnName:@"start_at" columnType:@"string"],
                                             [FmdbMigrationColumn columnWithColumnName:@"end_at" columnType:@"string"],
                                             [FmdbMigrationColumn columnWithColumnName:@"current_order_id" columnType:@"integer"],
                                            [FmdbMigrationColumn columnWithColumnName:@"pay_at" columnType:@"string"],
                                            [FmdbMigrationColumn columnWithColumnName:@"pay_end" columnType:@"string"],
                                            [FmdbMigrationColumn columnWithColumnName:@"duration" columnType:@"integer"],
                                            [FmdbMigrationColumn columnWithColumnName:@"appraiseStatus" columnType:@"integer"],
                                            
                                               nil]];
}

- (void)down {
    [self dropTable:@"chat"];
}
@end
