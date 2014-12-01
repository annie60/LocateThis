//
//  FavoritosViewController.m
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 10/21/2014
//  General Description: Controlador para la sección de favoritos.

//  Copyright (c) 2014 ITESM. All rights reserved.
////





#import "FavoritosViewController.h"
#import "MapaViewController.h"
@interface FavoritosViewController (){
    NSMutableArray*favoritos;
    NSString*busca;
    NSString* nospacestring;
}

@end

@implementation FavoritosViewController

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
    [self setServicioBD:[ApiBD getSharedInstance]];
    [self.servicioBD initWithDatabaseFilename:@"favoritos.db"];
    [self.servicioBD crearDB];
    favoritos = [self.servicioBD findFavorito];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"irMap"]) {
          [[segue destinationViewController] setCategoria:nospacestring];
        [[segue destinationViewController] setBusqueda:nospacestring];
    }
}
#pragma Collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [favoritos count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"celda" forIndexPath:indexPath];
    UILabel*label=(UILabel*)[cell viewWithTag:100];
    label.text=[favoritos objectAtIndex:indexPath.row];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    busca=[favoritos objectAtIndex:indexPath.row];
    busca=[busca lowercaseString];
    NSArray* words = [busca componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    nospacestring = [words componentsJoinedByString:@"+"];
    [self performSegueWithIdentifier:@"irMap" sender:self];
    
    
}
-(IBAction)backToFavoritos:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"irMap"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

@end
