//
//  ConfirmationViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/22/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "UIImage+RoundedImage.h"
#import <Parse/Parse.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController
#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

MBProgressHUD *HUD;

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
    _avatarName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatarName"];
    [self.avatarImage setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"plusImage"]]];
    [self.backgroundImage setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_backgroundImage release];
    [_avatarImage release];
    [_avatarName release];
    [super dealloc];
}
- (IBAction)doneButtonPressed:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    
    [HUD showWhileExecuting:@selector(signUpForParse) onTarget:self withObject:nil animated:YES];
}
- (void)signUpForParse{
    HUD.labelText = @"Signing in";
    PFUser *newUser = [PFUser user];
    newUser.username = [GPPSignIn sharedInstance].authentication.userEmail;
    newUser.password = @"iolani63";
    
    [newUser setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatarName"] forKey:@"AvatarName"];
    [newUser setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"classPeriod"] forKey:@"ClassPeriod"];
    [newUser setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"displayName"] forKey:@"DisplayName"];
    [newUser setObject:@NO forKey:@"Superuser"];
    
    PFObject *balances = [[PFObject alloc] initWithClassName:@"Balances"];
    [balances setObject:[NSNumber numberWithInt:35000] forKey:@"CashBalance"];
    [balances setObject:[NSNumber numberWithInt:0] forKey:@"ExperiencePoints"];
    [balances setObject:[newUser objectForKey:@"AvatarName"] forKey:@"AvatarName"];
    [newUser setObject:balances forKey:@"Balances"];
    
    NSError *error = nil;
    [newUser signUp:&error];
    if(error){
        NSString *errorString = [error localizedDescription];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:errorString
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }else{
        [balances save];
        [self uploadData];
    }
}
- (void)uploadData{
    NSError *error = nil;
    
    HUD.labelText = @"Uploading data";
    
    PFObject *avatarPhoto = [PFObject objectWithClassName:@"Avatar"];
    PFFile *avatar = [PFFile fileWithName:[[[PFUser currentUser] objectForKey:@"AvatarName"] stringByAppendingString:@".png"] data:[[NSUserDefaults standardUserDefaults] objectForKey:@"plusImage"]];
    [avatar save:&error];
    
    
    [avatarPhoto setObject:avatar forKey:@"imageFile"];
    [avatarPhoto setObject:[PFUser currentUser] forKey:@"user"];
    [avatarPhoto setObject:[[PFUser currentUser] username] forKey:@"FileName"];
    [avatarPhoto save:&error];
    
    PFObject *backgroundPhoto = [PFObject objectWithClassName:@"Background"];
    PFFile *background = [PFFile fileWithName:[[[PFUser currentUser] objectForKey:@"AvatarName"] stringByAppendingString:@".png"] data:[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage"]];
    [background save:&error];
    
    [backgroundPhoto setObject:background forKey:@"imageFile"];
    [backgroundPhoto setObject:[PFUser currentUser] forKey:@"user"];
    [backgroundPhoto setObject:[[PFUser currentUser] username] forKey:@"FileName"];
    [backgroundPhoto save:&error];
    
    HUD.labelText = @"Registering iPad";
    if(error){
        NSString *errorString = [error localizedDescription];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:errorString
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
    
    [self finishSignup];
}
- (void)finishSignup{
    
    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"Finished";
    sleep(2);
    [HUD hide:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadLogin"
                                                            object:nil
                                                          userInfo:nil];
    }];
}
@end
