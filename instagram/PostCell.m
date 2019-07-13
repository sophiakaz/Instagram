//
//  PostCell.m
//  instagram
//
//  Created by sophiakaz on 7/10/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)tapLike:(id)sender {
    int value = [self.post.likeCount intValue];
    self.post.likeCount = [NSNumber numberWithInt:value + 1];
    self.numLikesLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:@" likes"];
    UIImage *img = [UIImage imageNamed:@"like-red"];
    [self.likeButton setImage:img forState:UIControlStateNormal];
    [self.post saveInBackground];
}

- (IBAction)tapComment:(id)sender {
    int value = [self.post.commentCount intValue];
    self.post.commentCount = [NSNumber numberWithInt:value + 1];
    self.numCommentsLabel.text = [[self.post.commentCount stringValue] stringByAppendingString:@" comments"];
    [self.post saveInBackground];
}
@end
