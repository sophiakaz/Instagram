//
//  EditProfileViewController.h
//  instagram
//
//  Created by sophiakaz on 7/12/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
- (IBAction)tapChange:(id)sender;
- (IBAction)tapChangeText:(id)sender;
- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
