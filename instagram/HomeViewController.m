//
//  HomeViewController.m
//  instagram
//
//  Created by sophiakaz on 7/9/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import "HomeViewController.h"
#import "SignInViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "PostCell.h"
#import "DetailsViewController.h"
#import "ProfileDetailsViewController.h"
#import "HeaderCell.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (IBAction)tapLogout:(id)sender;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation HomeViewController
NSString *HeaderViewIdentifier = @"TableViewHeaderView";
NSInteger limit;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    limit = 5;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:activityIndicator];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
    
    [self fetchPosts];
    
    UIImage *image = [UIImage imageNamed:@"logo.jpg"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView.contentMode = UIViewContentModeScaleAspectFit;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fetchPosts {
    
    [self.activityIndicator startAnimating];
    
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = limit;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            NSLog(@"Posts found successfully");
            self.posts = posts;
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


- (IBAction)tapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged out successfully");
            [self performSegueWithIdentifier: @"showSignUp" sender:nil];
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    Post *post = self.posts[indexPath.section];
    cell.post = post;
    cell.captionLabel.text = post.caption;
    cell.usernameLabel2.text = post.author.username;
    cell.numLikesLabel.text = [[post.likeCount stringValue] stringByAppendingString:@" likes"];
    cell.numCommentsLabel.text = [[post.commentCount stringValue] stringByAppendingString:@" comments"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"showDetails"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.section];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    
    else if ([segue.identifier isEqualToString:@"showProfile"]){
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        ProfileDetailsViewController *profileDetailsViewController = [segue destinationViewController];
        Post *post = self.posts[indexPath.section];
        profileDetailsViewController.user = post.author;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    Post *post = self.posts[section];
    [cell.usernameLabel setTitle:post.author.username forState:UIControlStateNormal];
    [cell.usernameLabel setTitle:post.author.username forState:UIControlStateSelected];
    
    NSDate *createdAtDate = [post createdAt];
    cell.timeLabel.text = [self TimeSince:createdAtDate];
    
    PFFileObject *imageFile = [post.author objectForKey:@"profileImage"];
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Image found successfully");
            cell.profileView.image = [UIImage imageWithData:data];
        }
    }];
    
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.height /2;
    cell.profileView.layer.masksToBounds = YES;
    return cell;
    
}
 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54;
}

- (NSString *)TimeSince:(NSDate *)dateTime{
    NSDictionary *timeScale = @{@"sec"  :@1,
                                @"min"  :@60,
                                @"hr"   :@3600,
                                @"day"  :@86400,
                                @"week" :@605800,
                                @"month":@2629743,
                                @"year" :@31556926};
    NSString *scale;
    int timeSince = 0-(int)[dateTime timeIntervalSinceNow];
    if (timeSince < 60) {
        scale = @"sec";
    } else if (timeSince < 3600) {
        scale = @"min";
    } else if (timeSince < 86400) {
        scale = @"hr";
    } else if (timeSince < 605800) {
        scale = @"day";
    } else if (timeSince < 2629743) {
        scale = @"week";
    } else if (timeSince < 31556926) {
        scale = @"month";
    } else {
        scale = @"year";
    }
    
    timeSince = timeSince/[[timeScale objectForKey:scale] integerValue];
    NSString *s = @"";
    if (timeSince > 1) {
        s = @"s";
    }
    
    return [NSString stringWithFormat:@"%d %@%@", timeSince, scale, s];
}

-(void)loadMoreData{
    
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    limit = limit+5;
    postQuery.limit = limit;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            if (posts.count > self.posts.count) {
                NSLog(@"Posts found successfully");
                self.isMoreDataLoading = false;
                self.posts = posts;
                [self.tableView reloadData];
            }
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}

@end
