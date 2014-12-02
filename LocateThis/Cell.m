//
//  Cell.m
//  LocateThis
//
//  Created by andres on 12/1/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "Cell.h"
#import <QuartzCore/QuartzCore.h>

@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.backgroundColor = [UIColor underPageBackgroundColor];
        label.textColor = [UIColor blackColor];
        [self.contentView addSubview:label];
        _label = label;
        _label.text=@"Hola";
        label.text=@"Hola";
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}


// Must implement this method either here or in the UIViewController
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    NSLog(@"canPerformAction");
    // The selector(s) should match your UIMenuItem selector
    
    NSLog(@"Sender: %@", sender);
    if (action == @selector(customAction:)) {
        return YES;
    }
    return NO;
}
- (void)customAction:(id)sender {
    NSLog(@"custom action! %@", sender);
    UICollectionView* collecitonView=(UICollectionView*)[self superview];
    if ([collecitonView isKindOfClass:[UICollectionView class]]) {
        id <UICollectionViewDelegate> d=collecitonView.delegate;
        if  ([d respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]){
            [d collectionView:collecitonView performAction:@selector(delete:) forItemAtIndexPath:[collecitonView indexPathForCell:self] withSender:sender];
        }
    }
    
}

- (void)setLabel:(NSString *)newDetailItem
{
        _label.text = newDetailItem;

}
@end