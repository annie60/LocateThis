// PuntoMapa.m
//  LocateThis
//
//  Created by DA2 on 11/07/14.
//  Last updated: 11/07/2014
//  General Description: Controlador para la un punto de ubicacion en el mapa.

//  Copyright (c) 2014 ITESM. All rights reserved.
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface PuntoMapa : NSObject <MKAnnotation>
{
    
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
