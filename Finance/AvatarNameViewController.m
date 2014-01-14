//
//  AvatarNameViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/22/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "AvatarNameViewController.h"
#import "UINavigationController+KeyboardDismiss.h"
#import "AvatarPictureViewController.h"

@interface AvatarNameViewController ()

@end

@implementation AvatarNameViewController

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
    [_nameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nameField release];
    [_nextButton release];
    [super dealloc];
}

- (IBAction)nextButtonPressed:(id)sender {
    if(![_nameField.text isEqualToString:@""]){
        [_nameField resignFirstResponder];
        [self performSegueWithIdentifier:@"pictureSegue" sender:self];
        [[NSUserDefaults standardUserDefaults] setObject:_nameField.text forKey:@"avatarName"];
    }
}

@end
