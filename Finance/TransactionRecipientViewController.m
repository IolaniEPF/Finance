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
@property (retain, nonatomic) NSMutableArray *users;
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
- (void)viewWillAppear:(BOOL)animated{
    if([[[PFUser currentUser] objectForKey:@"Superuser"] isEqual:@YES]){
        self.avatarTable.multipleTouchEnabled = YES;
        [self.avatarTable setAllowsMultipleSelection:YES];
    }else{
        self.avatarTable.multipleTouchEnabled = NO;
        [self.avatarTable setAllowsMultipleSelection:NO];
    }
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
    [userQuery whereKey:@"AvatarName" notEqualTo:[[PFUser currentUser] objectForKey:@"AvatarName"]];
    NSError *error = nil;
    self.users = [[NSMutableArray alloc] initWithArray:[userQuery findObjects:&error]];
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
    if ([[[PFUser currentUser] objectForKey:@"Superuser"] isEqual:@YES]){
        if ([[tableView indexPathsForSelectedRows] containsObject:indexPath]){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = indexPath.row;
    [self.nextButton setEnabled:YES];
    if ([[[PFUser currentUser] objectForKey:@"Superuser"] isEqual:@YES]){
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[PFUser currentUser] objectForKey:@"Superuser"] isEqual:@YES]){
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
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
    if ([[[PFUser currentUser] objectForKey:@"Superuser"] isEqual:@YES]){
        [HUD showWhileExecuting:@selector(uploadMultiple) onTarget:self withObject:nil animated:YES];
    }else{
        [HUD showWhileExecuting:@selector(uploadData) onTarget:self withObject:nil animated:YES];
    }
}
- (void)uploadMultiple{
    NSError *error = nil;
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (int i = 0; i<[[self.avatarTable indexPathsForSelectedRows] count]; i++){
        PFObject *newTransaction = [[PFObject alloc] initWithClassName:@"Transactions"];
        [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionAmount"] forKey:@"Amount"];
        [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionDescription"] forKey:@"Description"];
        [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionType"] forKey:@"TransactionType"];
        [newTransaction setObject:[[PFUser currentUser]objectForKey:@"AvatarName"] forKey:@"CreatedBy"];
        NSInteger recipient = [[[self.avatarTable indexPathsForSelectedRows] objectAtIndex:i] row];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionType"] isEqualToString:@"Payment"]){
            [newTransaction setObject:[PFUser currentUser] forKey:@"Sender"];
            [newTransaction setObject:[[PFUser currentUser] objectForKey:@"AvatarName"] forKey:@"SenderString"];
            [newTransaction setObject:[self.users objectAtIndex:recipient] forKey:@"Recipient"];
            [newTransaction setObject:[[self.users objectAtIndex:recipient] objectForKey:@"AvatarName"] forKey:@"RecipientString"];
            
        }else{
            [newTransaction setObject:[PFUser currentUser] forKey:@"Recipient"];
            [newTransaction setObject:[[PFUser currentUser] objectForKey:@"AvatarName"] forKey:@"RecipientString"];
            [newTransaction setObject:[[self.users objectAtIndex:recipient] objectForKey:@"AvatarName"] forKey:@"SenderString"];
            [newTransaction setObject:[self.users objectAtIndex:recipient] forKey:@"Sender"];
        }
        [objects addObject:newTransaction];
    }
    [PFObject saveAll:objects error:&error];
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
        //[[NSUserDefaults standardUserDefaults]setObject:[newTransaction objectId] forKey:@"sentTransactionID"];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Finished";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTransactions"
                                                            object:nil
                                                          userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadBalances"
                                                            object:nil
                                                          userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        [HUD hide:YES];
    }
}
- (void)uploadData{
    NSError *error = nil;
    PFObject *newTransaction = [[PFObject alloc] initWithClassName:@"Transactions"];
    [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionAmount"] forKey:@"Amount"];
    [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionDescription"] forKey:@"Description"];
    [newTransaction setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionType"] forKey:@"TransactionType"];
    [newTransaction setObject:[[PFUser currentUser]objectForKey:@"AvatarName"] forKey:@"CreatedBy"];
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
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"transactionType"] isEqualToString:@"Payment"]){
            [newTransaction setObject:[PFUser currentUser] forKey:@"Sender"];
            [newTransaction setObject:[[PFUser currentUser] objectForKey:@"AvatarName"] forKey:@"SenderString"];
            [newTransaction setObject:[self.users objectAtIndex:selectedRow] forKey:@"Recipient"];
            [newTransaction setObject:[[self.users objectAtIndex:selectedRow] objectForKey:@"AvatarName"] forKey:@"RecipientString"];

        }else{
            [newTransaction setObject:[PFUser currentUser] forKey:@"Recipient"];
            [newTransaction setObject:[[PFUser currentUser] objectForKey:@"AvatarName"] forKey:@"RecipientString"];
            [newTransaction setObject:[[self.users objectAtIndex:selectedRow] objectForKey:@"AvatarName"] forKey:@"SenderString"];
            [newTransaction setObject:[self.users objectAtIndex:selectedRow] forKey:@"Sender"];
        }
        [newTransaction save:&error];
        
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
            
            [self performSegueWithIdentifier:@"sentSegue" sender:self];
            [HUD hide:YES];
        }}
}
@end
