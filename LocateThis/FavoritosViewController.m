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
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"celda" forIndexPath:indexPath];
    UILabel*label=(UILabel*)[cell viewWithTag:100];
    label.text=[favoritos objectAtIndex:indexPath.row];
    
    return cell;
    /* Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
     cell.delegate = self;
     return cell;
 */

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //[self performSegueWithIdentifier:@"irMap" sender:self];
    
    
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
    return YES;  // YES for the Cut, copy, paste actions
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
         performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    NSLog(@"performAction");
}

#pragma mark - UIMenuController required methods (Might not be needed on iOS 7)
- (BOOL)canBecomeFirstResponder {
    // NOTE: This menu item will not show if this is not YES!
    return YES;
}

// NOTE: on iOS 7.0 the message will go to the Cell, not the ViewController. We need a delegate protocol
//  to send the message back. On iOS 6.0 these methods work without the delegate.

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    NSLog(@"canPerformAction");
    // The selector(s) should match your UIMenuItem selector
    if (action == @selector(customAction:)) {
        return YES;
    }
    return NO;
}

#pragma mark - Custom Action(s) for iOS 6.0
- (void)customAction:(id)sender {
    NSLog(@"custom action! %@", sender);
}

// iOS 7.0 custom delegate method for the Cell to pass back a method for what custom button in the UIMenuController was pressed
- (void)customAction:(id)sender forCell:(Cell *)cell {
    NSLog(@"custom action on iOS 7.0");
}

// Delegate methods for UICollectionView... setup the delegate for the UICollectionViewCell

/*- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}*/



@end
