//
//  FavoritosViewController.m
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 10/21/2014
//  General Description: Controlador para la sección de mapa.

//  Copyright (c) 2014 ITESM. All rights reserved.
////

#import "MapaViewController.h"
#import "ApiBD.h"
#define kGOOGLE_API_KEY @"AIzaSyBppKVBeD433ZeEcimKh35Eiw-yeBPOGIM"
@interface MapaViewController ()
{
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    BOOL firstLaunch;
    int primera;
    
}
@end

@implementation MapaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.subtitulo.hidden=YES;
    self.nombreLocal.hidden=YES;
    self.favorito.enabled=NO;
    [self.mapView setShowsUserLocation:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager setDelegate:self];
    primera=0;
    self.palabraBusca.text=_categoria;
    
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    firstLaunch=YES;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
#pragma mark - MKMapViewDelegate methods.
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    
    [mv setRegion:region animated:YES];
}
#pragma Google Places Api
-(void)plotPositions:(NSArray *)data {
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[PuntoMapa class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    for (int i=0; i<[data count]; i++) {
        
        NSDictionary* place = [data objectAtIndex:i];
        
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        CLLocationCoordinate2D placeCoord;
        
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        PuntoMapa *placeObject = [[PuntoMapa alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [_mapView addAnnotation:placeObject];
    }
}
-(void) queryGooglePlaces: (NSString *) googleType {
    
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&keyword=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    //NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", 25.651565, -100.28954, [NSString stringWithFormat:@"%i", 1000], googleType, kGOOGLE_API_KEY];
    
    
    
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}
-(void)fetchedData:(NSData *)responseData {
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    
    NSArray* places = [json objectForKey:@"results"];
    
    [self plotPositions:places];
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    primera++;
    
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    currentCentre = self.mapView.centerCoordinate;
    if(primera==2){
        [self queryGooglePlaces:_busqueda];
    }
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Define your reuse identifier.
    static NSString *identifier = @"PuntoMapa";
    
    if ([annotation isKindOfClass:[PuntoMapa class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}
- (void)setBusqueda:(NSString *)newDetailItem
{
    if (_busqueda!= newDetailItem) {
        _busqueda = newDetailItem;
        
        // Update the view.
        
    }
}

- (void)setCategoria:(NSString *)newDetailItem
{
    if (_categoria!= newDetailItem) {
        _categoria = newDetailItem;
        
        // Update the view.
        
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    self.nombreLocal.text=view.annotation.title;
    self.subtitulo.text=view.annotation.subtitle;
    self.subtitulo.hidden=NO;
    self.nombreLocal.hidden=NO;
     self.favorito.enabled=YES;
}

- (IBAction)facebook:(id)sender {
    NSString *strFacebook = [NSString stringWithFormat: @"Encontre a %@ en LocateThis", self.nombreLocal.text];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *facebookController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookController setInitialText:strFacebook];
        
        [self presentViewController:facebookController animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Facebook Error" message:@"No esta habilitado facebook en tu dispositivo o no estas conectado a internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)twitter:(id)sender {
    NSString *strTwitter = [NSString stringWithFormat: @"Encontre a %@ en LocateThis", self.nombreLocal.text];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *twitterController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterController setInitialText:strTwitter];
        
        [self presentViewController:twitterController animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Twitter Error" message:@"No esta habilitado twitter en tu dispositivo o no estas conectado a internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
- (IBAction)favoritos:(id)sender {
    [self setServicioBD:[ApiBD getSharedInstance]];
    [self.servicioBD initWithDatabaseFilename:@"favoritos.db"];
    [self.servicioBD crearDB];
    BOOL error=[self.servicioBD addFavorito:self.nombreLocal.text];
    if (!error) {
        UIAlertView*mialerta=[[UIAlertView alloc]initWithTitle:@"Exito" message:@"Fue agregado con exito" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mialerta show];
    }

}
@end
