//
//  BadgeView.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/27/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "BadgeView.h"
#import "BadgeViewCell.h"
#import <Parse/Parse.h>
#import "UIImage+RoundedImage.h"
#import "BadgeViewController.h"
@interface BadgeView ()
@property (retain, nonatomic) NSArray *badges;
@end
@implementation BadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.badges = [[NSArray alloc] init];
    NSError *error = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:@"ReloadBadges"
                                               object:nil];
    PFQuery *badgeQuery = [PFQuery queryWithClassName:@"Badges"];
    [badgeQuery whereKey:@"Recipients" containsAllObjectsInArray:[NSArray arrayWithObject:[PFUser currentUser]]];
    PFQuery *everyoneQuery = [PFQuery queryWithClassName:@"Badges"];
    [everyoneQuery whereKey:@"Everyone" equalTo:@YES];
    PFQuery *allQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:badgeQuery,everyoneQuery, nil]];
    self.badges = [allQuery findObjects:&error];
    if(error){
        NSString *errorString = [error localizedDescription];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:errorString
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        //return 0;
    }
    return [self.badges count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BadgeViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"badgeCell" forIndexPath:indexPath];
    PFFile *badgeImage = [[self.badges objectAtIndex:indexPath.row] objectForKey:@"imageFile"];
    cell.badgeImageView.image = [UIImage roundedImageWithImage:[UIImage imageWithData:[badgeImage getData]]];
    cell.badgeLabel.text = [[self.badges objectAtIndex:indexPath.row] objectForKey:@"BadgeName"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BadgeViewController *detailController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"badgeView"];
    UIPopoverController *badgePop = [[UIPopoverController alloc] initWithContentViewController:detailController];
    detailController.badgeTitle.text = [[_badges objectAtIndex:indexPath.row] objectForKey:@"BadgeName"];
    [detailController.badgeDescription setFont:[UIFont fontWithName:@"Avenir Next Condensed" size:17.0]];
    detailController.badgeDescription.text = [[_badges objectAtIndex:indexPath.row] objectForKey:@"BadgeDescription"];
    [badgePop.contentViewController.view bringSubviewToFront:detailController.badgeTitle];
    CGRect frame = [collectionView convertRect:[collectionView cellForItemAtIndexPath:indexPath].frame toView:self];
    [badgePop presentPopoverFromRect:CGRectMake(frame.origin.x-85, frame.origin.y-190, 300, 300) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

@end
