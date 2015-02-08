//
//  MoviesViewController.h
//  RottenTomatoes
//
//  Created by Charlie Hu on 2/4/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MediaType) {
  MOVIE,
  DVD
};

@interface MoviesViewController : UIViewController
@property (nonatomic) MediaType mediaType;
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;

//@property (nonatomic, strong) NSMutableArray *initialMovies;
@property (nonatomic, strong) NSMutableArray *filteredMovies;
@property BOOL isFiltered;

@end
