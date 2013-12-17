//
//  Pattern1ViewController.m
//  iOSSecondStageAdventCaledar2013
//
//  Created by tochi on 2013/12/16.
//  Copyright (c) 2013年 tochi. All rights reserved.
//

#import "Pattern1ViewController.h"

@interface Pattern1ViewController () <NSURLConnectionDataDelegate>
{
@private
  NSMutableData *_eventData;
  NSArray *_events;
}
@end

@implementation Pattern1ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _eventData = [NSMutableData new];
  NSURL *url = [NSURL URLWithString:kEventUrl];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:urlRequest
                                                                 delegate:self];
  if (urlConnection) {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  }
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

#pragma mark - NSURLConnection delegate.

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
  [_eventData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  _events = [NSJSONSerialization JSONObjectWithData:_eventData
                                            options:NSJSONReadingAllowFragments
                                              error:nil];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  });
}

@end
