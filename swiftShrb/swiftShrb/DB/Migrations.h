//
//  CreateChannel.h
//  quan-iphone
//
//  Created by Wan Wei on 14-4-20.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FmdbMigration.h"
#import "FmdbMigrationManager.h"

@interface Migrations : NSObject

+ (void)migrate;

@end


@interface M1CreateChannel : FmdbMigration

@end

@interface M2CreateMessage : FmdbMigration

@end

@interface M3CreateUser : FmdbMigration

@end
