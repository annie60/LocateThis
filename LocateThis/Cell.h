//
//  Cell.h
//  LocateThis
//
//  Created by andres on 12/1/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cell; // Forward declare Custom Cell for the property

@protocol MyMenuDelegate <NSObject>

@optional
- (void)customAction:(id)sender forCell:(Cell *)cell;
@end

@interface Cell : UICollectionViewCell

@property (strong, nonatomic) UILabel* label;
@property (weak, nonatomic) id<MyMenuDelegate> delegate;

@end