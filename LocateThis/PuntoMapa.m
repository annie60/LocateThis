//
//  PuntoMapa.m
//  LocateThis
//
//  Created by DA2 on 11/07/14.
//  Last updated: 11/07/2014
//  General Description: Controlador para la un punto de ubicacion en el mapa.

//  Copyright (c) 2014 ITESM. All rights reserved.

#import <Foundation/Foundation.h>
#import "PuntoMapa.h"
@implementation PuntoMapa
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate  {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        
    }
    return self;
}

-(NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown";
    else
        return _name;
}

-(NSString *)subtitle {
    return _address;
}

@end