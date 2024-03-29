//
//  HeaderCell.h
//  instagram
//
//  Created by sophiakaz on 7/12/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameLabel;
- (IBAction)tapUsername:(id)sender;


@end

NS_ASSUME_NONNULL_END
