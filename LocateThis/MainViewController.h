//
//  FavoritosViewController.m
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 10/21/2014
//  General Description: Clase con atributos y operadores del controlador para la sección principal.

//  Copyright (c) 2014 ITESM. All rights reserved.
////

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *posTest;
@property (strong, nonatomic) IBOutlet UIButton *catalogButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *favoritesButton;



@end
