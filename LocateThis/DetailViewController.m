//
//  FavoritosViewController.m
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 10/21/2014
//  General Description: Controlador para la sección de categoría.

//  Copyright (c) 2014 ITESM. All rights reserved.
////

#import "DetailViewController.h"

@interface DetailViewController ()
//@property (strong, nonatomic) IBOutlet NSArray *pickerArray;
{

    NSMutableArray *productos;
     NSMutableArray *productitos;
    NSMutableArray *busqueda;
}
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(int)newDetailItem
{
    if (_detailItem != newDetailItem) {
       _detailItem = newDetailItem;
        
        // Update the view.
            }
}


-(void)cargarProductos{
    NSBundle*bundle=[NSBundle mainBundle];
    NSString*path=[bundle pathForResource:@"catalogoPlist" ofType:@"plist"];
    productitos=[NSMutableArray arrayWithContentsOfFile:path];
    NSArray *arr=[productitos objectAtIndex:_detailItem];
    for(int j=0;j<arr.count; j++){
        NSDictionary *temp=[arr objectAtIndex:j];
        [productos addObject:[temp objectForKey:@"Display"]];
        
        [busqueda addObject:[temp objectForKey:@"LookUp"]];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    productos=[[NSMutableArray alloc]init];
    busqueda=[[NSMutableArray alloc]init];
    [self cargarProductos];
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return productos.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [productos objectAtIndex:row];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backToDetail:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"irDetalle"]) {
        
    [self dismissViewControllerAnimated:YES completion:nil];    
        
    }
    
    
}
@end
