//
//  Pattern3ViewController.m
//  iOSSecondStageAdventCaledar2013
//
//  Created by tochi on 2013/12/16.
//  Copyright (c) 2013年 tochi. All rights reserved.
//

#import "Pattern3ViewController.h"

@interface Pattern3ViewController ()
{
@private
  NSArray *_events;
}
@end

@implementation Pattern3ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSURLSessionConfiguration *urlSessionConfiguration;
  urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfiguration];
  NSURL *url = [NSURL URLWithString:kEventUrl];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  NSURLSessionDataTask *urlSessionDataTask;
  urlSessionDataTask = [urlSession dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                   _events = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:nil];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     [self.tableView reloadData];
                                   });
                                 }];
  [urlSessionDataTask resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                          forIndexPath:indexPath];
  NSDictionary *event = _events[indexPath.row];
  cell.textLabel.text = event[@"event"][@"title"];
  
  return cell;
}

@end
