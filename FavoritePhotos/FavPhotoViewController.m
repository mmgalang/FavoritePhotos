//
//  ViewController.m
//  FavoritePhotos
//
//  Created by Marcial Galang on 1/27/14.
//  Copyright (c) 2014 Marc Galang. All rights reserved.
//

#import "FavPhotoViewController.h"
#import "SearchCell.h"
#import "SearchResultsViewController.h"

@interface FavPhotoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *favoritePhotos;
    __weak IBOutlet UICollectionView *favoritePhotosCollectionView;
}
@end

@implementation FavPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    favoritePhotos = [NSMutableArray new];
    [self load];
}

-(void)save
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"photos.plist"];
    [favoritePhotos writeToURL:plist atomically:YES];
    
    [userDefaults setObject:[NSDate date] forKey:@"Last Saved"];
}

-(void) load
{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"photos.plist"];
    favoritePhotos = [NSMutableArray arrayWithContentsOfURL:plist] ?: [NSMutableArray new];
}

-(NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask] firstObject];
}

-(IBAction)unWindFromSearchResultsViewController:(UIStoryboardSegue *)segue
  {
      SearchResultsViewController *viewController = segue.sourceViewController;
      NSIndexPath *indexPath;
      
      [favoritePhotos addObject:[viewController favoritePhoto]];
       indexPath = [NSIndexPath indexPathForRow:favoritePhotos.count -1 inSection:0];
      [favoritePhotosCollectionView insertItemsAtIndexPaths:@[indexPath]];
       
  }
  
  

  
  -(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return favoritePhotos.count;
}
  
  -(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavPhotoReuseID" forIndexPath:indexPath];
    cell.imageView.image = favoritePhotos[indexPath.row];
    return cell;
}
  @end
