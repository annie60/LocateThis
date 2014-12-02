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

// Call our ViewController to do the work, since it has knowledge of the data model, not this view.
// On iOS 7.0, you'll have to implement this method to make the custom menu appear with a UICollectionViewController
- (void)customAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(customAction:forCell:)]) {
        [self.delegate customAction:sender forCell:self];
    }
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

- (void)setLabel:(NSString *)newDetailItem
{
        _label.text = newDetailItem;

}
@end