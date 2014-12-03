//
//  Cell.h
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 12/01/2014
//  General Description: Controlador para la celda.

//  Copyright (c) 2014 ITESM. All rights reserved.
////

#import <UIKit/UIKit.h>

@class Cell; // Forward declare Custom Cell for the property

@protocol MyMenuDelegate <NSObject>

@optional
- (void)customAction:(id)sender;
@end

@interface Cell : UICollectionViewCell

@property (strong, nonatomic) UILabel* label;
@property (weak, nonatomic) id<MyMenuDelegate> delegate;

@end