//
//  LifeEventViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/28/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeEventViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextView *newsText;
- (IBAction)doneButtonPressed:(id)sender;

@end
