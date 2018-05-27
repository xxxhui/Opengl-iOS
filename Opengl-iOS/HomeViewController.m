//
//  HomeViewController.m
//  Opengl-iOS
//
//  Created by xxxhui on 2018/5/21.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import "HomeViewController.h"
#import "TriangleViewController.h"
#import "SquareViewController.h"
#import "RegularTriangleViewController.h"
#import "OpenGLES_Ch3_6ViewController.h"

@interface HomeViewController ()

@property (copy, nonatomic) NSArray* list;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    self.list = @[@[@"TriangleViewController", @"三角形"],
                  @[@"SquareViewController", @"正方形"],
                  @[@"RegularTriangleViewController", @"正三角形"],
                  ];
}

- (void)setupUI {
    UITableView* tabView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tabView.delegate = self;
    tabView.dataSource = self;
    [self.view addSubview:tabView];
    tabView.tableFooterView = [UIView new];
    
    self.title = @"Awsome OpenGL";
}

#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [[self.list objectAtIndex:row] objectAtIndex:1];
    cell.detailTextLabel.text = @"Go";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSUInteger row = [indexPath row];
    NSString *clsName = [[self.list objectAtIndex:row] objectAtIndex:0];
    if (clsName) {
        Class viewCls = NSClassFromString(clsName);
        UIViewController *newVc = [[viewCls alloc] init];
        [self.navigationController pushViewController:newVc animated:true];
    }
}

@end
