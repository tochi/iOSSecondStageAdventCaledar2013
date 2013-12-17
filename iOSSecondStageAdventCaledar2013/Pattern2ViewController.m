//
//  Pattern2ViewController.m
//  iOSSecondStageAdventCaledar2013
//
//  Created by tochi on 2013/12/16.
//  Copyright (c) 2013年 tochi. All rights reserved.
//

#import "Pattern2ViewController.h"

@interface Pattern2ViewController ()
{
@private
  NSData *_eventData;
  NSArray *_events;
}
@end

@implementation Pattern2ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _eventData = [NSMutableData new];
  NSURL *url = [NSURL URLWithString:kEventUrl];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    _eventData = [NSURLConnection sendSynchronousRequest:urlRequest
                                       returningResponse:nil
                                                   error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
      _events = [NSJSONSerialization JSONObjectWithData:_eventData
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      [self.tableView reloadData];
    });
  });
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
