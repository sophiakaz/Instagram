//
//  ProfileDetailsViewController.h
//  instagram
//
//  Created by sophiakaz on 7/12/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileDetailsViewController : UIViewController
@property (nonatomic, strong) PFUser *user;
@end

NS_ASSUME_NONNULL_END
