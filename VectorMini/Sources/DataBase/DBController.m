//
//  DBController.m
//  FMDBTest
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "DBController.h"
#import <FMDB/FMDB.h>
#import "Project.h"

@interface DBController()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) dispatch_queue_t workQueue;
@property (nonatomic, strong) NSURL *dbUrl;

@end

@implementation DBController

#pragma mark - Initializations and deallocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_attr_t  attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, -1);
        _workQueue = dispatch_queue_create("com.database.workQueue", attr);
        
         NSURL * documnetDirUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        _dbUrl = [documnetDirUrl URLByAppendingPathComponent:@"projects.db"];
    }
    return self;
}

- (void)dealloc
{
    dispatch_async(self.workQueue, ^{
        [self.db close];
    });
}

#pragma mark - Public

- (void)start {
    dispatch_async(self.workQueue, ^{
        if ([self dbExists]) {
            [self openDB];
        } else {
            [self openDB];
            [self turnOnForeignKey];
            [self createTables];
        }
    });
}

- (void)fetchProjects:(void(^)(NSArray *))completion {
    dispatch_async(self.workQueue, ^{
        FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM projects ORDER BY id ASC"];
        NSMutableArray *results = [NSMutableArray array];
        while ([rs next]) {
            NSInteger projId = [rs intForColumn:@"id"];
            NSString *projectName = [rs stringForColumn:@"name"];
            Project *p = [[Project alloc] init:projId :projectName];
            [results addObject:p];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(results);
        });
        
    });
}

- (void)addProject:(void(^)(NSString *))completion {
    dispatch_async(self.workQueue, ^{
        NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MMM-dd HH:mm:ss:SSS"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        [self.db executeUpdate:@"INSERT INTO projects(name) VALUES(?);", dateString];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(dateString);
        });
    });
}

#pragma mark - Private

- (void)openDB {
    self.db = [FMDatabase databaseWithURL:self.dbUrl];
    if (![self.db open]) {
        self.db = nil;
        return;
    }
}

- (BOOL)dbExists {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self.dbUrl path]];
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
