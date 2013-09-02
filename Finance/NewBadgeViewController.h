//
//  NewBadgeViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/30/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewBadgeViewController : UIViewController <UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UITextField *badgeName;
@property (retain, nonatomic) IBOutlet UITextField *badgeDescription;
@property (retain, nonatomic) IBOutlet UIButton *BadgeImageButton;
- (IBAction)imageButtonPressed:(id)sender;
- (IBAction)nextButtonTapped:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
@end
