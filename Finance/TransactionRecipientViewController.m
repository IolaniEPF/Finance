//
//  TransactionRecipientViewController.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/28/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "TransactionRecipientViewController.h"
#import <Parse/Parse.h>
#import "RecipientCell.h"

@interface TransactionRecipientViewController ()
@property (retain, nonatomic) NSArray *users;
@end

@implementation TransactionRecipientViewController
NSInteger selectedRow = 0;
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
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    PFQuery *userQuery = [PFUser query];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"transactionType"] isEqual:@"Deposit"]&&[[[PFUser currentUser] objectForKey:@"Superuser"] isEqual:@NO]){
        [userQuery whereKey:@"isStudent" equalTo:@NO];
    }
    NSError *error = nil;
    self.users = [userQuery findObjects:&error];
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
    return [self.users count];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecipientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recipientCell" forIndexPath:indexPath];
    cell.emailLabel.text = [[self.users objectAtIndex:indexPath.row] objectForKey:@"username"];
    cell.avatarNameLabel.text = [[self.users objectAtIndex:indexPath.row] objectForKey:@"AvatarName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = indexPath.row;
    [self.nextButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_avatarTable release];
    [_nextButton release];
    [super dealloc];
}

- (IBAction)nextButtonPressed:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Sending";
    [HUD showWhileExecuting:@selector(uploadData) onTarget:self withObject:nil animated:YES];
}

- (void)uploadData{
    NSError *error = nil;
    PFObject *newTransaction = [[PFObject alloc] initWithClassName:@"Transactions"];
    [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionAmount"] forKey:@"Amount"];
    [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionDescription"] forKey:@"Description"];
    [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionType"] forKey:@"TransactionType"];
    [newTransaction setObject:[[PFUser currentUser]objectForKey:@"AvatarName"] forKey:@"CreatedBy"];
    
    PFQuery *myBalanceQuery = [PFQuery queryWithClassName:@"Balances"];
    [myBalanceQuery whereKey:@"AvatarName" equalTo:[[PFUser currentUser] objectForKey:@"AvatarName"]];
    PFObject *myBalance = [myBalanceQuery getFirstObject:&error];
    PFQuery *recipientBalanceQuery = [PFQuery queryWithClassName:@"Balances"];
    [recipientBalanceQuery whereKey:@"AvatarName" equalTo:[[self.users objectAtIndex:selectedRow] objectForKey:@"AvatarName"]];
    PFObject *recipientBalance = [recipientBalanceQuery getFirstObject:&error];
    NSNumber *transactionAmount = [[NSUserDefaults standardUserDefaults]objectForKey:@"transactionAmount"];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionType"] isEqualToString:@"Payment"]){
        [newTransaction setObject:[PFUser currentUser] forKey:@"Sender"];
        [newTransaction setObject:[[PFUser currentUser] objectForKey:@"AvatarName"] forKey:@"SenderString"];
        [newTransaction setObject:[self.users objectAtIndex:selectedRow] forKey:@"Recipient"];
        [newTransaction setObject:[[self.users objectAtIndex:selectedRow] objectForKey:@"AvatarName"] forKey:@"RecipientString"];
        
        [myBalance setObject:[NSNumber numberWithFloat: ([[myBalance objectForKey:@"CashBalance"] floatValue]-[transactionAmount floatValue])] forKey:@"CashBalance"];
        [recipientBalance setObject:[NSNumber numberWithFloat:([[recipientBalance objectForKey:@"CashBalance"] floatValue]+[transactionAmount floatValue])] forKey:@"CashBalance"];

    }else{
        [newTransaction setObject:[PFUser currentUser] forKey:@"Recipient"];
        [newTransaction setObject:[[PFUser currentUser] objectForKey:@"AvatarName"] forKey:@"RecipientString"];
        [newTransaction setObject:[[self.users objectAtIndex:selectedRow] objectForKey:@"AvatarName"] forKey:@"SenderString"];
        [newTransaction setObject:[self.users objectAtIndex:selectedRow] forKey:@"Sender"];
        
        [myBalance setObject:[NSNumber numberWithFloat: ([[myBalance objectForKey:@"CashBalance"] floatValue]+[transactionAmount floatValue])] forKey:@"CashBalance"];
        [recipientBalance setObject:[NSNumber numberWithFloat:([[recipientBalance objectForKey:@"CashBalance"] floatValue]-[transactionAmount floatValue])] forKey:@"CashBalance"];
    }
    [PFObject saveAll:[NSArray arrayWithObjects:myBalance,recipientBalance,newTransaction, nil] error:&error];
    
    if(error){
        [HUD hide:YES];
        NSString *errorString = [error localizedDescription];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:errorString
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:[newTransaction objectId] forKey:@"sentTransactionID"];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Finished";
        [HUD hide:YES];
        [self performSegueWithIdentifier:@"sentSegue" sender:self];
    }
}
@end
