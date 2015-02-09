//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Charlie Hu on 2/4/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *movieTabBar;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UILabel *networkErrorLabel;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
  [self.tableView insertSubview:self.refreshControl atIndex:0];

  self.tableView.dataSource = self;
  self.tableView.delegate = self;

  self.images = [[NSMutableArray alloc] init];
  //self.initialMovies = [[NSMutableArray alloc] init];

  [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];

  self.tableView.rowHeight = 99;


  CGRect labelFrame = CGRectMake(0.0f, 65.0f, 375.0f, 25.0f);
  self.networkErrorLabel = [[UILabel alloc] initWithFrame:labelFrame];
  self.networkErrorLabel.text = @"Network Error";
  self.networkErrorLabel.backgroundColor = [UIColor blackColor];
  self.networkErrorLabel.textColor = [UIColor whiteColor];
  self.networkErrorLabel.font = [UIFont boldSystemFontOfSize:16.0f];
  self.networkErrorLabel.textAlignment =  NSTextAlignmentCenter;
  self.networkErrorLabel.layer.borderColor = [UIColor blackColor].CGColor;
  self.networkErrorLabel.layer.borderWidth = 1.0;
  //[self.view addSubview:self.networkErrorLabel];
  //[self.view sendSubviewToBack:self.networkErrorLabel];

  [SVProgressHUD show];

  NSURL *movieUrl = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=h5bpwkw327pp353p9wf5eh5w"];
  NSURL *dvdUrl = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=h5bpwkw327pp353p9wf5eh5w"];
  NSURL *url = movieUrl;
  self.title = @"Box Office";
  [self.view sendSubviewToBack:self.gridView];
  if (self.mediaType == DVD) {
    url = dvdUrl;
    self.title = @"DVDs";
  }


  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    if (connectionError == nil) {
      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSLog(@"response: %@", responseDictionary);
      self.movies = responseDictionary[@"movies"];
      [self.tableView reloadData];
      [self.view sendSubviewToBack:self.networkErrorLabel];
    } else {
      [self.view addSubview:self.networkErrorLabel];
    };
    [SVProgressHUD dismiss];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UIRefreshControl

- (void)onRefresh {
  NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=h5bpwkw327pp353p9wf5eh5w"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    if (connectionError == nil) {
      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSLog(@"response: %@", responseDictionary);
      self.movies = responseDictionary[@"movies"];
      [SVProgressHUD dismiss];
      [self.tableView reloadData];
      [self.view sendSubviewToBack:self.networkErrorLabel];
    } else {
      [self.view addSubview:self.networkErrorLabel];
    };
    [self.refreshControl endRefreshing];
  }];
}

#pragma mark - TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isFiltered == YES) {
    return self.filteredMovies.count;
  } else {
    return self.movies.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
  cell.imageView.image = nil;

  NSDictionary *movie = self.movies[indexPath.row];

  if (self.isFiltered == YES) {
    movie = self.filteredMovies[indexPath.row];
  }

  cell.titleLabel.text = movie[@"title"];
  cell.synopsisLabel.text = movie[@"synopsis"];

  NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
  __weak UIImageView *weakPosterView = cell.posterView;
  [cell.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    [UIView transitionWithView:weakPosterView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      [weakPosterView setImage:image];
    } completion:nil];
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //
  }];

  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
  vc.movie = self.movies[indexPath.row];
  if (self.isFiltered == YES) {
    vc.movie = self.filteredMovies[indexPath.row];
  }
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBar methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if (searchText.length == 0) {
    self.isFiltered = NO;
  } else {
    self.isFiltered = YES;
    self.filteredMovies = [[NSMutableArray alloc] init];

    for (NSDictionary *movie in self.movies) {
      NSRange movieNameRange = [movie[@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
      if (movieNameRange.location != NSNotFound) {
        [self.filteredMovies addObject:movie];
      }
    }
    [self.tableView reloadData];
  }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self.movieSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self.movieSearchBar resignFirstResponder];
  self.movieSearchBar.text = @"";
  self.isFiltered = NO;
  [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
