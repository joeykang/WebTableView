//
//  TableViewController.m
//  WebTableView
//
//  Created by EL on 2014-04-28.
//  Copyright (c) 2014 EL. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "UIKit+AFNetworking.h"

@interface TableViewController ()
@property (strong, nonatomic) NSArray *googlePlacesArrayFromAFNetworking;
@property (strong, nonatomic) NSArray *finishedGooglePlacesArray;
@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    [self makeRestaurantRequests];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeRestaurantRequests {
    NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants+in+Toronto&sensor=false&key=AIzaSyDsCc_Vm6Y2-lZDWrT1Y-C_8xNBmVufXhA"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.googlePlacesArrayFromAFNetworking = [responseObject objectForKey:@"results"];
        [self.tableView reloadData];
        //NSLog(@"The Array: %@",self.googlePlacesArrayFromAFNetworking);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.googlePlacesArrayFromAFNetworking count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WebCell" forIndexPath:indexPath];
    
    NSDictionary *tempDic = [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDic objectForKey:@"name"];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    //[cell.imageView setImageWithURL:[NSURL URLWithString:[tempDic objectForKey:@"icon"]] placeholderImage:placeholderImage];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[tempDic objectForKey:@"icon"]]];
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest: request
                          placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                              weakCell.imageView.image = image;
                              [weakCell setNeedsLayout];
                          } failure:nil
     ];
    
    if ([tempDic objectForKey:@"rating"] != NULL) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Rating: %@ of 5", [tempDic objectForKey:@"rating"]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Not Rated"];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ViewController *viewController = [segue destinationViewController];
    viewController.restaurantDetail = [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
}


@end
