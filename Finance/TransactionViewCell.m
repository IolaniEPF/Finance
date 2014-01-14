//
//  TransactionViewCell.m
//  Finance
//
//  Created by Blake Tsuzaki on 8/29/13.
//  Copyright (c) 2013 Blake Tsuzaki. All rights reserved.
//

#import "TransactionViewCell.h"

@implementation TransactionViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_bigLabel release];
    [_littleLabel release];
    [_amountLabel release];
    [super dealloc];
}
@end
