//
//  DetailsViewController.m
//  instagram
//
//  Created by sophiakaz on 7/11/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import "DetailsViewController.h"
#import "Post.h"
#import "Parse/Parse.h"
#import "PostCell.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel2;
- (IBAction)tapLike:(id)sender;
- (IBAction)tapComment:(id)sender;



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = self.post.author.username;
    self.usernameLabel2.text = self.post.author.username;
    self.numLikesLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:@" likes"];
    self.numCommentsLabel.text = [[self.post.commentCount stringValue] stringByAppendingString:@" comments"];
    self.captionLabel.text = self.post.caption;
    
    PFFileObject *imageFile = self.post.image;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Image found successfully");
            self.pictureView.image = [UIImage imageWithData:data];
        }
    }];
    
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height /2;
    self.profileView.layer.masksToBounds = YES;

    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)tapLike:(id)sender {
}

- (IBAction)tapComment:(id)sender {
}
@end
