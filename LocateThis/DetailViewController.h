//
//  FavoritosViewController.m
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 10/21/2014
//  General Description: Clase con atributos y operadores del controlador para la sección de categoría.

//  Copyright (c) 2014 ITESM. All rights reserved.
////

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (assign, nonatomic) int detailItem;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end
