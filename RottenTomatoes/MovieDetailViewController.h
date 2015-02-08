//
//  MovieDetailViewController.h
//  RottenTomatoes
//
//  Created by Charlie Hu on 2/6/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *posterDetailView;
@property (weak, nonatomic) IBOutlet UILabel *posterTitleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *posterTextScrollView;
@property (weak, nonatomic) IBOutlet UILabel *posterSynopsisLabel;
@property (nonatomic, strong) NSDictionary *movie;

@end
