//
//  M2CreateMessage.m
//  quan-iphone
//
//  Created by Wan Wei on 14-4-20.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//

#import "Migrations.h"

@implementation M2CreateMessage

- (void)up {
    [self createTable:@"messages" withColumns:[NSArray arrayWithObjects:
                                               
                                               [FmdbMigrationColumn columnWithColumnName:@"msg_id" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"chat_id" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"sender_id" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"type" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"sub_type" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"mime_type" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"content" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"ass_object_id" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"ack" columnType:@"integer"],

                                               [FmdbMigrationColumn columnWithColumnName:@"status" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"sent_at" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"created_at" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"updated_at" columnType:@"string"],
                                               nil]];
}

- (void)down {
    [self dropTable:@"messages"];
}
@end