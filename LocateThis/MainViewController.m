//
//  FavoritosViewController.m
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 10/21/2014
//  General Description: Controlador para la sección principal.

//  Copyright (c) 2014 ITESM. All rights reserved.
////

#import "MainViewController.h"


@interface MainViewController ()
{
    
    CLLocationManager *locationManager;
    
    
}
@end

@implementation MainViewController

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
    // Do any additional setup after loading the view.
    locationManager=[[CLLocationManager alloc]init];
    [self getLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)unWind:(UIStoryboardSegue *)segue
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getLocation{
    
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    if([CLLocationManager locationServicesEnabled]){
     [locationManager startUpdatingLocation];
    }
}
#pragma CLLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Problemas con el GPS" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    self.cameraButton.enabled=false;
    self.catalogButton.enabled=false;
    self.favoritesButton.enabled=false;
    self.posTest.text=@"Porfavor cambie los permisos del GPS";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
  
    self.cameraButton.enabled=true;
    self.catalogButton.enabled=true;
    self.favoritesButton.enabled=true;
    
    
    
    
}
@end
