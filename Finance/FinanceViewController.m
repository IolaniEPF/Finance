//
//  FinanceViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/16/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "FinanceViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "UIImage+RoundedImage.h"
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "ClassPeriodViewController.h"

@interface FinanceViewController ()

@end

@implementation FinanceViewController

@synthesize signInButton;
@synthesize signInActivity;
@synthesize signInLabel;

- (void)viewDidLoad
{
	// Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    signInLabel.text = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadMainScreen)
                                                 name:@"ReloadLogin"
                                               object:nil];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
                     nil];
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    if (error) {
        // Do some error handling here.
        NSLog(@"Received error %@ and auth object %@",error, auth);
        [self loginError:error];
    } else {
        [self refreshInterfaceBasedOnSignIn];
    }
}

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        [self.signInActivity startAnimating];
        [self loadingUI];
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}

- (void)loadMainScreen{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}
- (void)loadNewAccountScreen{
    [self performSegueWithIdentifier:@"createAccountSegue" sender:self];
}

- (void)loadingUI{
    GTLServicePlus* plusService = [[[GTLServicePlus alloc] init] autorelease];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    GTMLoggerError(@"Error: %@", error);
                } else {
                    // Retrieve the display name and "about me" text
                    [person retain];
                    NSURL *url = [NSURL URLWithString:[person.image.url stringByReplacingOccurrencesOfString:@"?sz=50" withString:@"?sz=180"]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(img) forKey:@"plusImage"];
                    
                    [UIView transitionWithView:self.view
                                      duration:.5f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        _userImageView.image = [UIImage roundedImageWithImage:img];
                                    } completion:nil];
                    
                    img =_userImageView.image;
                    CGRect imageRect = CGRectMake( 0 , 0 , img.size.width + 4 , img.size.height + 4 );
                    
                    UIGraphicsBeginImageContext( imageRect.size );
                    [img drawInRect:CGRectMake( imageRect.origin.x + 2 , imageRect.origin.y + 2 , imageRect.size.width - 4 , imageRect.size.height - 4 ) ];
                    CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
                    img = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    [_userImageView setImage:img ];
                    _userImageView.layer.shouldRasterize = YES;
                    //_userImageView.layer.rasterizationScale = 3;
                    _userImageView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
                    _userImageView.clipsToBounds = NO;
                    _userImageView.layer.masksToBounds = NO;
                    
                    _userImageView.layer.shadowColor = [UIColor blackColor].CGColor;
                    _userImageView.layer.shadowOffset = CGSizeMake(0, 1);
                    _userImageView.layer.shadowOpacity = 1;
                    _userImageView.layer.shadowRadius = 1.5;
                    _userImageView.clipsToBounds = NO;
                    
                    NSString *welcome = [NSString stringWithFormat:
                                         @"%@", person.displayName];
                    signInLabel.text = welcome;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:person.displayName forKey:@"displayName"];
                    
                    _userImageView.hidden = NO;
                    _bankLabel1.hidden = YES;
                    _bankLabel2.hidden = YES;
                    _bankLogo.hidden = YES;
                    
                    [self tryParseLogin];
                }
            }];
}

- (void)tryParseLogin{
    NSLog(@"Logging into Parse");
    
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"username" equalTo:[GPPSignIn sharedInstance].authentication.userEmail];
    if([userQuery getFirstObject]){
        NSError *error = nil;
        [PFUser logInWithUsername:[GPPSignIn sharedInstance].authentication.userEmail password:@"iolani63" error:&error];
         if(error){
            [self loginError:error];
            self.signInButton.hidden = NO;
            [self.signInActivity stopAnimating];
        }else{
            NSLog(@"Successfully logged in. Loading main screen");
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage"] == nil){
                PFQuery *backgroundQuery = [PFQuery queryWithClassName:@"Background"];
                [backgroundQuery whereKey:@"user" equalTo:[PFUser currentUser]];
                PFFile *backgroundImage = [[backgroundQuery getFirstObject] objectForKey:@"imageFile"];
                [[NSUserDefaults standardUserDefaults] setObject:[backgroundImage getData] forKey:@"backgroundImage"];
            }
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"plusImage"] == nil){
                PFQuery *backgroundQuery = [PFQuery queryWithClassName:@"Avatar"];
                [backgroundQuery whereKey:@"user" equalTo:[PFUser currentUser]];
                PFFile *backgroundImage = [[backgroundQuery getFirstObject] objectForKey:@"imageFile"];
                [[NSUserDefaults standardUserDefaults] setObject:[backgroundImage getData] forKey:@"plusImage"];
            }
            [self performSelector:@selector(loadMainScreen) withObject:nil afterDelay:2.];
        }
    }else{
        NSLog(@"No matching Parse user. Loading new account screen");
        [self performSelector:@selector(loadNewAccountScreen) withObject:nil afterDelay:2.];
    }
}

- (void)loginError:(NSError *)error{
    NSString *errorString = [error localizedDescription];
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:errorString
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [signInActivity release];
    [signInButton release];
    [signInLabel release];
    [_bankLabel1 release];
    [_bankLabel2 release];
    [_bankLogo release];
    [_userImageView release];
    [super dealloc];
}
@end
