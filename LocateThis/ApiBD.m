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
            
            
            const char *sql_statement="CREATE TABLE IF NOT EXISTS FAVORITOS (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT)";
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
-(BOOL)addFavorito:(NSString *)name{
    
    sqlite3_stmt *sql_statement;
    self.status=@"OK";
    sqlite3 *profileDB_Local;
    NSString *insertsql=[NSString stringWithFormat:@"INSERT INTO FAVORITOS (NAME) VALUES (\"%@\")",name];
    const char *insert_statement=[insertsql UTF8String];
    if (sqlite3_open([self.databasePath UTF8String], &profileDB_Local) == SQLITE_OK)
    {
        sqlite3_prepare_v2(self.puntoMapaBD, insert_statement, -1, &sql_statement, NULL);
        NSLog(@"addProfile : %s",sqlite3_errmsg(self.puntoMapaBD));
        if(sqlite3_step(sql_statement)==SQLITE_DONE){
            self.status=@"Profile added";
            sqlite3_finalize(sql_statement);
            return NO;
        }else{
            self.status=@"Failed to add profile";
            sqlite3_finalize(sql_statement);
            return YES;
            
        }
    }
    sqlite3_finalize(sql_statement);
    sqlite3_close(profileDB_Local);
    return NO;
    
}
-(BOOL) removeFavorito:(NSString *)name
{
    BOOL error=NO;
    sqlite3_stmt *sql_statement;
    
    sqlite3 *profileDB_Local;
    NSString *insertsql=[NSString stringWithFormat:@"DELETE FROM FAVORITOS WHERE name=\"%@\"",name];
    const char *delete_statement=[insertsql UTF8String];
    
    if (sqlite3_open([self.databasePath UTF8String], &profileDB_Local) == SQLITE_OK) {
        if(sqlite3_prepare_v2(self.puntoMapaBD, delete_statement, -1, &sql_statement, NULL)==SQLITE_OK){
            NSLog(@"removeProfile: %s",sqlite3_errmsg(self.puntoMapaBD));
            if(sqlite3_step(sql_statement) ==SQLITE_ROW){
                self.status=@"Match found";
            }else{
                self.status=@"Match not found";
                error=YES;
            }
            sqlite3_finalize(sql_statement);
            sqlite3_close(profileDB_Local);
        }
    }
    return error;
}
-(NSMutableArray*) findFavorito{
    sqlite3_stmt *sql_statement;
    sqlite3 *profileDB_Local;
    NSMutableArray *perfil=[[NSMutableArray alloc]init];
    NSString *querySQL=[NSString stringWithFormat:@"SELECT * FROM FAVORITOS"];
    const char *sql_select=[querySQL UTF8String];
    if (sqlite3_open([self.databasePath UTF8String], &profileDB_Local) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(self.puntoMapaBD, sql_select, -1, &sql_statement, NULL)==SQLITE_OK){
            NSLog(@"findFavorito: %s",sqlite3_errmsg(self.puntoMapaBD));
            while(sqlite3_step(sql_statement) ==SQLITE_ROW){
                self.status=@"Match found";
                //int idrow=sqlite3_column_int(sql_statement, 0);
                NSString *name=[[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(sql_statement, 1)];
               
                [perfil addObject:name];
            }
            sqlite3_finalize(sql_statement);
            sqlite3_close(profileDB_Local);
        }
    }
    return perfil;
    
}


@end
