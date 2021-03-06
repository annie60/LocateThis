//
//  FavoritosViewController.m
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 10/21/2014
//  General Description: Clase de atributos y operadores del controlador para la sección de Mapa

//  Copyright (c) 2014 ITESM. All rights reserved.
////
#import "PuntoMapa.h"
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MapKit/MapKit.h>
#import "ApiBD.h"
#import <CoreLocation/CoreLocation.h>
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface MapaViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *palabraBusca;
- (IBAction)facebook:(id)sender;
- (IBAction)twitter:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *subtitulo;
@property (strong, nonatomic) IBOutlet UILabel *nombreLocal;
- (IBAction)favoritos:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favorito;
@property (nonatomic, assign) NSString *busqueda;
@property (nonatomic, assign) NSString *categoria;
@property (strong, nonatomic) ApiBD *servicioBD;
@end
