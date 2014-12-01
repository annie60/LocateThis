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

@interface FavoritosViewController (){
    NSMutableArray*favoritos;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
-(IBAction)backToFavoritos:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"irMap"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

@end
