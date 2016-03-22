#import "Migrations.h"
#import "DB.h"

@implementation Migrations

+ (void)migrate {
    NSArray *migrations = [NSArray arrayWithObjects:
                           [M1CreateChannel migration], // 1
                           [M2CreateMessage migration],
                           [M3CreateUser migration],
                           nil
                           ];
    
    NSString* dbPath = [DB dbPath];
    NSLog(@"dbPath: %@", dbPath);
    
    [FmdbMigrationManager executeForDatabasePath:dbPath withMigrations:migrations];
}



@end