//
//  ApiBD.h
//  LocateThis
//
//  Created by David Quilla on 30/11/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PuntoMapa.h"

@interface ApiBD : NSObject

@property (nonatomic) sqlite3 *puntoMapaBD;
@property(nonatomic,strong) NSString*documentsDirectory;
@property(nonatomic,strong) NSString*databaseFilename;
@property(nonatomic,strong) NSString*databasePath;
@property(nonatomic,strong) NSString*status;

+(ApiBD *)getSharedInstance;

-(void)initWithDatabaseFilename:(NSString *)dbFileName;
-(BOOL)crearDB;

@end
