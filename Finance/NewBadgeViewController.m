//
//  NewBadgeViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/30/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "NewBadgeViewController.h"

@interface NewBadgeViewController ()
@property (strong, nonatomic) UIPopoverController *popover;
@end

@implementation NewBadgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadUserImage];
}

- (void)loadUserImage{
    [self.BadgeImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"badgeImage"];
    [self.BadgeImageButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonTapped:(id)sender {
    [self.badgeDescription resignFirstResponder];
    [self.badgeName resignFirstResponder];
    if([self.badgeName.text isEqualToString:@""]||[self.badgeDescription.text isEqualToString:@""]){
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"You left something blank."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        
    }else{
        [self saveTransactionData];
    }
}

- (void)saveTransactionData{
    [[NSUserDefaults standardUserDefaults] setObject:self.badgeName.text forKey:@"BadgeName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.badgeDescription.text forKey:@"BadgeDescription"];
    [self transitionToNext];
}

- (void)transitionToNext{
    [self performSegueWithIdentifier:@"newBadgeChooseAvatarSegue" sender:self];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [_badgeName release];
    [_badgeDescription release];
    [_BadgeImageButton release];
    [super dealloc];
}
- (IBAction)imageButtonPressed:(id)sender {
    CGPoint touch = _BadgeImageButton.frame.origin;
    touch.x = touch.x+(_BadgeImageButton.frame.size.width/2);
    touch.y = touch.y+(_BadgeImageButton.frame.size.height);
    
    [self pickImage:touch];
}

- (void)pickImage:(CGPoint )touch{
    if (![_popover isPopoverVisible]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        _popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        _popover.delegate = self;
        
        [_popover presentPopoverFromRect:CGRectMake(touch.x-90,touch.y-250,170,250) inView:super.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]) forKey:@"badgeImage"];
    [self loadUserImage];
}
@end
