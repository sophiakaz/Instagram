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
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
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
    NSDate *createdAtDate = [self.post createdAt];
    self.timeLabel.text = [self AgoStringFromTime:createdAtDate];
    
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

- (NSString *)AgoStringFromTime:(NSDate *)dateTime{
    NSDictionary *timeScale = @{@"sec"  :@1,
                                @"min"  :@60,
                                @"hr"   :@3600,
                                @"day"  :@86400,
                                @"week" :@605800,
                                @"month":@2629743,
                                @"year" :@31556926};
    NSString *scale;
    int timeAgo = 0-(int)[dateTime timeIntervalSinceNow];
    if (timeAgo < 60) {
        scale = @"sec";
    } else if (timeAgo < 3600) {
        scale = @"min";
    } else if (timeAgo < 86400) {
        scale = @"hr";
    } else if (timeAgo < 605800) {
        scale = @"day";
    } else if (timeAgo < 2629743) {
        scale = @"week";
    } else if (timeAgo < 31556926) {
        scale = @"month";
    } else {
        scale = @"year";
    }
    
    timeAgo = timeAgo/[[timeScale objectForKey:scale] integerValue];
    NSString *s = @"";
    if (timeAgo > 1) {
        s = @"s";
    }
    
    return [NSString stringWithFormat:@"%d %@%@", timeAgo, scale, s];
}

- (IBAction)tapLike:(id)sender {
}

- (IBAction)tapComment:(id)sender {
}
@end
