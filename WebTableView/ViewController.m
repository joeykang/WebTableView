//
//  ViewController.m
//  WebTableView
//
//  Created by EL on 2014-04-28.
//  Copyright (c) 2014 EL. All rights reserved.
//

#import "ViewController.h"
#import "UIIMageView+AFNetworking.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.restaurantNameLabel.text = [self.restaurantDetail objectForKey:@"name"];
    self.restaurantAddressLabel.text = [self.restaurantDetail objectForKey:@"formatted_address"];
    [self.restaurantImageView setImageWithURL:[NSURL URLWithString:[self.restaurantDetail objectForKey:@"icon"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
