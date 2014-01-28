//
//  SearchResultsViewController.m
//  FavoritePhotos
//
//  Created by Marcial Galang on 1/27/14.
//  Copyright (c) 2014 Marc Galang. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "SearchCell.h"

@interface SearchResultsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    __weak IBOutlet UICollectionView *searchCollectionView;
    __weak IBOutlet UITextField *searchTextField;
    NSMutableArray *searchPhotos;
}
@end

@implementation SearchResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    searchPhotos = [NSMutableArray new];
}

- (IBAction)onSearchButtonPressed:(id)sender {
    [searchTextField resignFirstResponder];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=371ef1fb785973b15b7f696937cf2084&tags=%@&license=1%%2C2%%2C3%%2C4%%2C5%%2C6&sort=interestingness-desc&per_page=10&page=1&format=json&nojsoncallback=1",searchTextField.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSArray *arrayOfPictureData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"photos"][@"photo"];
         
         int i = 0;
         for (i=0; i<10; i++) {
             
             NSDictionary *pictureData = [arrayOfPictureData objectAtIndex:i];
             float farm = [pictureData[@"farm"] floatValue];
             NSString *server = pictureData[@"server"];
             NSString *id = pictureData[@"id"];
             NSString *secret = pictureData[@"secret"];
             NSString *imageURL = [NSString stringWithFormat:@"http://farm%.0f.staticflickr.com/%@/%@_%@.jpg",farm,server,id,secret];
             [searchPhotos addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
             NSLog(@"image searchphotos =%@",imageURL);
             
         }
         [searchCollectionView reloadData];
         NSLog(@"%@",searchPhotos);
     }];
    
}

-(UIImage *) favoritePhoto
{
    int row = [searchCollectionView.indexPathsForSelectedItems[0] row];
    return searchPhotos[row];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return searchPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCellReuseID" forIndexPath:indexPath];
    cell.imageView.image = searchPhotos[indexPath.row];
    return cell;
}





@end
