//
//  BackgroundImageViewController.h
//  Finance
//
//  Created by Blake Tsuzaki on 8/22/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundImageViewController : UIViewController <UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)backgroundTapped:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *backgroundImage;
- (IBAction)nextButtonPressed:(id)sender;

@end
