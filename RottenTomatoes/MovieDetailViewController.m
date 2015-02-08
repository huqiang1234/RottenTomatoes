//
//  MovieDetailViewController.m
//  RottenTomatoes
//
//  Created by Charlie Hu on 2/6/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.posterTitleLabel.text = self.movie[@"title"];
  self.posterSynopsisLabel.text = self.movie[@"synopsis"];

  NSString *url = [self.movie valueForKeyPath:@"posters.thumbmail"];
  UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];

  [self.posterDetailView setImage:img];
  //[self.posterDetailView setImageWithURL:[NSURL URLWithString:url]];
  NSString *detailed_url = [[self.movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
  __weak UIImageView *weakPosterDetailView = self.posterDetailView;
  [self.posterDetailView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailed_url]] placeholderImage:img success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    [UIView transitionWithView:weakPosterDetailView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      [weakPosterDetailView setImage:image];
    } completion:nil];
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //
  }];

  self.posterTextScrollView.contentSize = CGSizeMake(375, 1000);
  [self.posterTextScrollView addSubview:self.posterTitleLabel];
  [self.posterTextScrollView addSubview:self.posterSynopsisLabel];
  [self.posterSynopsisLabel sizeToFit];
  [self.posterTextScrollView sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
