//
//  BackgroundImageViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/22/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "BackgroundImageViewController.h"

@interface BackgroundImageViewController ()
@property (strong, nonatomic) UIPopoverController *popover;
@end

@implementation BackgroundImageViewController

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
    [self.backgroundImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage"];
    [self.backgroundImage setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_backgroundImage release];
    [super dealloc];
}
- (IBAction)backgroundTapped:(id)sender {
    CGPoint touch = _backgroundImage.frame.origin;
    touch.x = touch.x+(_backgroundImage.frame.size.width/2);
    touch.y = touch.y+(_backgroundImage.frame.size.height);
    
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
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]) forKey:@"backgroundImage"];
    [self loadUserImage];
}
- (IBAction)nextButtonPressed:(id)sender {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage"]){
        [self performSegueWithIdentifier:@"confirmationSegue" sender:self];
    }
}
@end
