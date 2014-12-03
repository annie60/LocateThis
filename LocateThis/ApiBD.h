//
//  ApiBD.h
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 12/01/2014
//  General Description: Controlador para la BASE DE DATOS.

//  Copyright (c) 2014 ITESM. All rights reserved.
////

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
-(BOOL)addFavorito:(NSString*)name;
-(BOOL)removeFavorito:(NSString*)name;

-(NSMutableArray*)findFavorito;
@end
