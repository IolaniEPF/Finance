//
//  AvatarPictureViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/22/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarPictureViewController : UIViewController <UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UIButton *avatarImage;
- (IBAction)avatarTapped:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
@end
