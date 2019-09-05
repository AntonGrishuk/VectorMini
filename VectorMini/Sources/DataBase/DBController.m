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

- (void)addProject:(void(^)(Project *))completion {
    dispatch_async(self.workQueue, ^{
        NSString *dateString = [self dateString];
        BOOL result = [self.db executeUpdate:@"INSERT INTO projects(name) VALUES(?);", dateString];
        Project *project = [Project new];
        if (result) {
            project = [[Project alloc] init:(NSInteger)self.db.lastInsertRowId :dateString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(project);
        });
    });
}

- (void)addCurve:(Curve *)curve forProject:(NSUInteger)projectId completion:(void(^)(NSInteger curveId, BOOL result))completion  {
    dispatch_async(self.workQueue, ^{
        NSString *dateString = [self dateString];
        BOOL result = [self.db executeUpdate:@"INSERT INTO lines(projectId, color, visible, date) VALUES(?, ?, ?, ?);",
                       projectId, [curve hexColor], 1, dateString];
        
        NSInteger curveId = (NSInteger)self.db.lastInsertRowId;

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(curveId, result);
            [self addPoints:curve];
            [self addToChangesHistory];
        });
        
        NSArray *points = [curve getPoints];
        for (NSValue *pointValue in points) {
            CGPoint p = [pointValue CGPointValue];
            [self.db executeUpdate:@"INSERT INTO linesPoints(lineId, x, y) VALUES(?,?);", curveId, p.x, p.y];
        }

        [self.db executeUpdate:@"INSERT INTO history(date, projectId, toolId, action) VALUES(?,?,?,?);",
         dateString, projectId, curveId, @"AddLine"];
        
    });
}

- (void)addPoints:(Curve *)curve {
    
}

- (void)addToChangesHistory {
    
}

//- (void)lastInserRowId {
//    dispatch_async(self.workQueue, ^{
//        NSInteger lastId = (NSInteger)self.db.lastInsertRowId;
//
//        dispatch_async(dispatch_get_main_queue(), ^{
////            completion(results);
//        });
//    });
//}

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
    "projectId INTEGER, color INTEGER NOT NULL, visible INTEGER, date REAL NOT NULL,"
    "FOREIGN KEY(projectId) REFERENCES projects(id) ON DELETE CASCADE);"
    
    "CREATE TABLE rectangles(id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "x REAL NOT NULL, y REAL NOT NULL, width REAL NOT NULL, height REAL NOT NULL,"
    "projectId INTEGER, color INTEGER NOT NULL, visible INTEGER, date REAL NOT NULL,"
    "FOREIGN KEY(projectId) REFERENCES projects(id) ON DELETE CASCADE);"
    
    "CREATE TABLE linesPoints(id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "lineId INTEGER, x REAL NOT NULL, y REAL NOT NULL,"
    "FOREIGN KEY(lineId) REFERENCES lines(id) ON DELETE CASCADE);"
    
    "CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, date REAL NOT NULL,"
    "projectId INTEGER, toolId INTEGER NOT NULL, action TEXT NOT NULL,"
    "FOREIGN KEY(projectId) REFERENCES projects(id) ON DELETE CASCADE);"
    ;
    
    [self.db executeStatements:sql];
}

- (NSString *)dateString {
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MMM-dd HH:mm:ss:SSS"];
    return [formatter stringFromDate:[NSDate date]];
}

@end
