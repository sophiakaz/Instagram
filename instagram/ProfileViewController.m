//
//  ProfileViewController.m
//  instagram
//
//  Created by sophiakaz on 7/11/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "PostCell.h"
#import "DetailsViewController.h"
#import "PostCollectionCell.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *numPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) PFUser *user;

@end

@implementation ProfileViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.user = PFUser.currentUser;
    self.navigationItem.title = self.user.username;
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"scripBlack"] forBarMetrics:UIBarMetricsDefault];
    
    [self fetchPosts];
    
    self.numPostsLabel.text = [@(self.posts.count) stringValue];
    self.numFollowersLabel.text = @"14";
    self.numFollowingLabel.text = @"23";
    self.bioLabel.text = @"This is my super cool and somewhat short bio!";
    self.nameLabel.text = @"FirstName LastName";
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height /2;
    self.profileView.layer.masksToBounds = YES;
    
}

- (void)fetchPosts {
    
    //[self.activityIndicator startAnimating];
    
    // construct PFQuery

    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            NSLog(@"Posts found successfully");
            self.posts = posts;
            //[self.activityIndicator stopAnimating];
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
    }];
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.row];
    PFFileObject *imageFile = post.image;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Image found successfully");
            cell.pictureView.image = [UIImage imageWithData:data];
        }
    }];
    
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showDetails"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}
*/

@end
