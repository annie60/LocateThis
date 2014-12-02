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
#import "Cell.h"

@interface FavoritosViewController ()<MyMenuDelegate>{
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
    self.collectionView.delegate = self;
    
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Eliminar" action:@selector(customAction:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
    
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"celda"];

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
        NSIndexPath *indexpath =[[self.collectionView indexPathsForSelectedItems]lastObject];
        
        busca=[favoritos objectAtIndex:indexpath.row];
        busca=[busca lowercaseString];
        
        NSArray* words = [busca componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        nospacestring = [words componentsJoinedByString:@"+"];
        //nospacestring=[NSString stringWithFormat:@"\"%@\"", nospacestring];
          [[segue destinationViewController] setCategoria:busca];
        [[segue destinationViewController] setBusqueda:nospacestring];
    }
}
#pragma Collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [favoritos count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"celda" forIndexPath:indexPath];
    cell.label.text=[favoritos objectAtIndex:indexPath.row];
    //UILabel*label=(UILabel*)[cell viewWithTag:100];
    //label.text=[favoritos objectAtIndex:indexPath.row];
    
    return cell;
    

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self performSegueWithIdentifier:@"irMap" sender:self];
    
    
}

-(IBAction)backToFavoritos:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"irMap"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

#pragma mark - UICollectionViewDelegate methods
- (BOOL)collectionView:(UICollectionView *)collectionView
      canPerformAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    return NO;  // YES for the Cut, copy, paste actions
}


- (BOOL)collectionView:(UICollectionView *)collectionView
shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
         performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    [self setServicioBD:[ApiBD getSharedInstance]];
    [self.servicioBD initWithDatabaseFilename:@"favoritos.db"];
    [self.servicioBD crearDB];
    [self.servicioBD removeFavorito:[favoritos objectAtIndex:indexPath.row]];
    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    [self.collectionView reloadData];
    
   
    
}



// Delegate methods for UICollectionView... setup the delegate for the UICollectionViewCell

/*- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}*/



@end
