//
//  TransactionConfirmationViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/28/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "TransactionConfirmationViewController.h"
#import <Parse/Parse.h>
#import "UIImage+RoundedImage.h"
#import <QuartzCore/QuartzCore.h>

@interface TransactionConfirmationViewController ()
@property (retain, nonatomic) PFObject *transactionObject;
@end

@implementation TransactionConfirmationViewController
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTransactions"
                                                        object:nil
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadBalances"
                                                        object:nil
                                                      userInfo:nil];
    NSError *error = nil;
    PFQuery *transactionQuery = [PFQuery queryWithClassName:@"Transactions"];
    self.transactionObject = [transactionQuery getObjectWithId:[[NSUserDefaults standardUserDefaults] objectForKey:@"sentTransactionID"]error:&error];
    self.navigationItem.hidesBackButton = YES;
    if(error){
        NSString *errorString = [error localizedDescription];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:errorString
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(loadUI) onTarget:self withObject:nil animated:YES];
    }
}

- (void)loadUI{
    self.transactionCodeLabel.text = [NSString stringWithFormat:@"Transaction Code: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"sentTransactionID"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM-dd-yyyy  h:mm a"];
    self.dateLabel.text = [NSString stringWithFormat:@"Sent on %@",[formatter stringFromDate:self.transactionObject.createdAt]];
    self.descriptionLabel.text = [self.transactionObject objectForKey:@"Description"];
    self.amountLabel.text = [NSString stringWithFormat:@"$%@",[self.transactionObject objectForKey:@"Amount"]];
    
    PFQuery *avatarQuery = [PFQuery queryWithClassName:@"Avatar"];
    if ([[self.transactionObject objectForKey:@"TransactionType"] isEqualToString:@"Payment"]){
        self.toLabel.text = [[[self.transactionObject objectForKey:@"Recipient"] fetchIfNeeded] objectForKey:@"AvatarName"];
        [avatarQuery whereKey:@"user" equalTo:[self.transactionObject objectForKey:@"Recipient"]];
    }else{
        self.toLabel.text = [[[self.transactionObject objectForKey:@"Sender"] fetchIfNeeded] objectForKey:@"AvatarName"];
        [avatarQuery whereKey:@"user" equalTo:[self.transactionObject objectForKey:@"Sender"]];
    }
    PFFile *avatar = [[avatarQuery getFirstObject] objectForKey:@"imageFile"];
    self.avatarImage.image = [UIImage roundedImageWithImage:[UIImage imageWithData:[avatar getData]]];
    
    UIImage *img =[[UIImage alloc] init];
    img = self.avatarImage.image;
    CGRect imageRect = CGRectMake( 0 , 0 , img.size.width + 4 , img.size.height + 4 );
    
    UIGraphicsBeginImageContext( imageRect.size );
    [img drawInRect:CGRectMake( imageRect.origin.x + 2 , imageRect.origin.y + 2 , imageRect.size.width - 4 , imageRect.size.height - 4 ) ];
    CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.avatarImage setImage:img ];
    self.avatarImage.layer.shouldRasterize = YES;
    self.avatarImage.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    self.avatarImage.clipsToBounds = NO;
    self.avatarImage.layer.masksToBounds = NO;
    
    self.avatarImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.avatarImage.layer.shadowOffset = CGSizeMake(0, 1);
    self.avatarImage.layer.shadowOpacity = 1;
    self.avatarImage.layer.shadowRadius = 1.5;
    self.avatarImage.clipsToBounds = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_dateLabel release];
    [_descriptionLabel release];
    [_amountLabel release];
    [_toLabel release];
    [_avatarImage release];
    [_transactionCodeLabel release];
    [super dealloc];
}
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
