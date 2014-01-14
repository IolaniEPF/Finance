//
//  ConfirmationViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/22/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ConfirmationViewController : UIViewController <MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UILabel *avatarName;
- (IBAction)doneButtonPressed:(id)sender;
@end
