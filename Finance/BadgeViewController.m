//
//  BadgeViewController.m
//  EPF
//
//  Created by Blake Tsuzaki on 7/31/13.
//  Copyright (c) 2013 'Iolani School. All rights reserved.
//

#import "BadgeViewController.h"

@interface BadgeViewController ()

@end

@implementation BadgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [_badgeTitle release];
    [_badgeDescription release];
    [super dealloc];
}
@end
