//
//  DBController.m
//  FMDBTest
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "DBController.h"
#import <FMDB/FMDB.h>

@interface DBController()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) dispatch_queue_t workQueue;

@end

@implementation DBController

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_attr_t  attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, -1);
        _workQueue = dispatch_queue_create("com.database.workQueue", attr);
    }
    return self;
}

- (void)start {
    dispatch_async(self.workQueue, ^{
        [self openDB];
        [self turnOnForeignKey];
        [self createTables];
    });
}

- (void)openDB {
    NSURL * documnetDirUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *dbUrl = [documnetDirUrl URLByAppendingPathComponent:@"projects.db"];
    self.db = [FMDatabase databaseWithURL:dbUrl];
    if (![self.db open]) {
        self.db = nil;
        return;
    }
}

- (void)turnOnForeignKey {
    NSString *sql = @"PRAGMA foreign_keys = ON;";
    [self.db executeStatements:sql];
}

- (void)createTables {
    NSString *sql = @""
    "CREATE TABLE projects(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);"
    
    "CREATE TABLE lines(id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "projectId INTEGER, color TEXT NOT NULL, visible INTEGER, date TEXT NOT NULL,"
    "FOREIGN KEY(projectId) REFERENCES projects(id) ON DELETE CASCADE);"
    
    "CREATE TABLE rectangles(id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "x REAL NOT NULL, y REAL NOT NULL, width REAL NOT NULL, height REAL NOT NULL,"
    "projectId INTEGER, color TEXT NOT NULL, visible INTEGER, date TEXT NOT NULL,"
    "FOREIGN KEY(projectId) REFERENCES projects(id) ON DELETE CASCADE);"
    
    "CREATE TABLE linesPoints(id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "lineId INTEGER, x REAL NOT NULL, y REAL NOT NULL,"
    "FOREIGN KEY(lineId) REFERENCES lines(id) ON DELETE CASCADE);"
    
    "CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL,"
    "projectId INTEGER, toolType INTEGER NOT NULL, toolId INTEGER NOT NULL, action INTEGER NOT NULL,"
    "FOREIGN KEY(projectId) REFERENCES projects(id) ON DELETE CASCADE);"
    ;
    
    [self.db executeStatements:sql];
}

@end
