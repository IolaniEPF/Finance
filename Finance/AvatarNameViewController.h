//
//  AvatarNameViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/22/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarNameViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
- (IBAction)nextButtonPressed:(id)sender;

@end
