//
//  M3CreateAvatar.m
//  quan-iphone
//
//  Created by Wan Wei on 14-4-22.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//


#import "Migrations.h"

@implementation M3CreateUser

- (void)up {
    [self createTable:@"users" withColumns:[NSArray arrayWithObjects:
                                               [FmdbMigrationColumn columnWithColumnName:@"nickname" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"avatar" columnType:@"string"],
                                               [FmdbMigrationColumn columnWithColumnName:@"gender" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"friend_id" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"chat_id" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"created_at" columnType:@"integer"],
                                               [FmdbMigrationColumn columnWithColumnName:@"updated_at" columnType:@"integer"],
                                               nil]];
}

- (void)down {
    [self dropTable:@"users"];
}
@end
