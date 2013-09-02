//
//  AvatarPictureViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/22/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "AvatarPictureViewController.h"
#import "UIImage+RoundedImage.h"

@interface AvatarPictureViewController ()
@property (strong, nonatomic) UIPopoverController *popover;
@end

@implementation AvatarPictureViewController

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
    [self.avatarImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"plusImage"];
    [self.avatarImage setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nextButton release];
    [_avatarImage release];
    [super dealloc];
}

- (IBAction)avatarTapped:(id)sender {
    CGPoint touch = _avatarImage.frame.origin;
    touch.x = touch.x+(_avatarImage.frame.size.width/2);
    touch.y = touch.y+(_avatarImage.frame.size.height);
    
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
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]) forKey:@"plusImage"];
    [self loadUserImage];
}
@end
