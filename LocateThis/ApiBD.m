//
//  ApiBD.m
//  LocateThis
//
//  Created by David Quilla on 30/11/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ApiBD.h"

@implementation ApiBD
-(void)initWithDatabaseFilename:(NSString *)dbFileName {
    if(self){
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory=[path objectAtIndex:0];
        self.databaseFilename=dbFileName;
        
        self.documentsDirectory=[path objectAtIndex:0];
        
        self.databasePath=[[NSString alloc]initWithString:[self.documentsDirectory stringByAppendingPathComponent:dbFileName]];
        
        
    }
}

+(ApiBD *)getSharedInstance{
    static ApiBD *_sharedInstance=nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance=[[ApiBD alloc]init];
    });
    return _sharedInstance;
}

-(BOOL)crearDB{
    BOOL error=NO;
    sqlite3 *puntoMapaBD_Local;
    self.status=@"OK";
    NSFileManager*fileMngr=[NSFileManager defaultManager];
    
    if ([fileMngr fileExistsAtPath:self.databasePath]==NO) {
        const char *dbpath=[self.databasePath UTF8String];
        if (sqlite3_open(dbpath, &puntoMapaBD_Local)==SQLITE_OK) {
            char *errmsg;
            
            self.puntoMapaBD=puntoMapaBD_Local;
            
            
            const char *sql_statement="CREATE TABLE IF NOT EXISTS PUNTOSMAPA (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,EMAIL TEXT)";
            if(sqlite3_exec(self.puntoMapaBD, sql_statement, NULL, NULL, &errmsg) != SQLITE_OK){
                error=YES;
                self.status=@"Failed to create table";
                NSLog(@"crearDB: %s",sqlite3_errmsg(self.puntoMapaBD));
            }
            sqlite3_close(self.puntoMapaBD);
            return error;
        }else{
            error=YES;
            NSLog(@"Error en crear DB");
            self.status=@"Failed to open/create database";
        }
    }
    if (sqlite3_open([self.databasePath UTF8String], &puntoMapaBD_Local)==SQLITE_OK) {
        self.puntoMapaBD=puntoMapaBD_Local;
    }
    return error;
}

@end
