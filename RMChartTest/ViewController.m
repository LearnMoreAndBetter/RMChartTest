//
//  ViewController.m
//  RMChartTest
//
//  Created by CETC-Server on 17/3/16.
//  Copyright © 2017年 CETC-Server. All rights reserved.
//

#import "ViewController.h"
#import "RMLineChartView.h"
#import "RMBarChartView.h"
#import "RMChartModel.h"
#import "RMLineChartScrollView.h"


#define APP_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define APP_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array1 = @[@{@"dateTime":@"01/01", @"value" : @"1"},
                        @{@"dateTime":@"01/02", @"value" : @"4"},
                        @{@"dateTime":@"01/03", @"value" : @"1"},
                        @{@"dateTime":@"01/04", @"value" : @"5"},
                        @{@"dateTime":@"01/05", @"value" : @"16"},
                        @{@"dateTime":@"01/06", @"value" : @"12"},
                        @{@"dateTime":@"01/07", @"value" : @"20"},
                        @{@"dateTime":@"01/08", @"value" : @"2"}];
    NSMutableArray *dataList1 = [NSMutableArray array];
    for (NSDictionary *dic in array1) {
        RMChartModel *model = [RMChartModel initModelWithData:dic];
        [dataList1 addObject:model];
    }
    
    NSArray *array2 = @[@{@"dateTime":@"01/09", @"value" : @"2"},
                        @{@"dateTime":@"01/10", @"value" : @"14"},
                        @{@"dateTime":@"01/11", @"value" : @"11"},
                        @{@"dateTime":@"01/12", @"value" : @"15"},
                        @{@"dateTime":@"01/13", @"value" : @"1"},
                        @{@"dateTime":@"01/14", @"value" : @"3"},
                        @{@"dateTime":@"01/15", @"value" : @"20"},
                        @{@"dateTime":@"01/16", @"value" : @"2"}];
    NSMutableArray *dataList2 = [NSMutableArray array];
    for (NSDictionary *dic in array2) {
        RMChartModel *model = [RMChartModel initModelWithData:dic];
        [dataList2 addObject:model];
    }
    
    NSArray *array3 = @[@{@"dateTime":@"01/19", @"value" : @"3"},
                        @{@"dateTime":@"01/20", @"value" : @"14"},
                        @{@"dateTime":@"01/21", @"value" : @"11"},
                        @{@"dateTime":@"01/22", @"value" : @"15"},
                        @{@"dateTime":@"01/23", @"value" : @"1"},
                        @{@"dateTime":@"01/24", @"value" : @"3"},
                        @{@"dateTime":@"01/25", @"value" : @"20"},
                        @{@"dateTime":@"01/26", @"value" : @"2"}];
    NSMutableArray *dataList3 = [NSMutableArray array];
    for (NSDictionary *dic in array3) {
        RMChartModel *model = [RMChartModel initModelWithData:dic];
        [dataList3 addObject:model];
    }
    
    NSArray *array4 = @[@{@"dateTime":@"02/09", @"value" : @"4"},
                        @{@"dateTime":@"02/10", @"value" : @"14"},
                        @{@"dateTime":@"02/11", @"value" : @"11"},
                        @{@"dateTime":@"02/12", @"value" : @"15"},
                        @{@"dateTime":@"02/13", @"value" : @"1"},
                        @{@"dateTime":@"02/14", @"value" : @"3"},
                        @{@"dateTime":@"02/15", @"value" : @"20"},
                        @{@"dateTime":@"02/16", @"value" : @"2"}];
    NSMutableArray *dataList4 = [NSMutableArray array];
    for (NSDictionary *dic in array4) {
        RMChartModel *model = [RMChartModel initModelWithData:dic];
        [dataList4 addObject:model];
    }
    
    NSArray *array5 = @[@{@"dateTime":@"02/19", @"value" : @"5"},
                        @{@"dateTime":@"02/20", @"value" : @"14"},
                        @{@"dateTime":@"02/21", @"value" : @"11"},
                        @{@"dateTime":@"02/22", @"value" : @"15"},
                        @{@"dateTime":@"02/23", @"value" : @"1"},
                        @{@"dateTime":@"02/24", @"value" : @"3"},
                        @{@"dateTime":@"02/25", @"value" : @"20"},
                        @{@"dateTime":@"02/26", @"value" : @"2"}];
    NSMutableArray *dataList5 = [NSMutableArray array];
    for (NSDictionary *dic in array5) {
        RMChartModel *model = [RMChartModel initModelWithData:dic];
        [dataList5 addObject:model];
    }
    
    NSArray *scrollLineArray = @[@{@"title" : @"图一",
                                    @"list" : dataList1},
                                @{@"title" : @"图二",
                                    @"list" : dataList2},
                                @{@"title" : @"图三",
                                    @"list" : dataList3},
                                @{@"title" : @"图四",
                                    @"list" : dataList4},
                                @{@"title" : @"图五",
                                    @"list" : dataList5}
                                                ];
    
    RMLineChartScrollView *lineChartScrollView = [[RMLineChartScrollView alloc]initWithFrame:CGRectMake(0, 50, APP_SCREEN_WIDTH, 250)];
    lineChartScrollView.dataLists = scrollLineArray;
    [self.view addSubview:lineChartScrollView];
    
    /*
    RMLineChartView *lineChartView = [[RMLineChartView alloc]initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, 200)];
    lineChartView.dataLists = dataList1;
    [self.view addSubview:lineChartView];*/
    
    RMBarChartView *barChartView = [[RMBarChartView alloc]initWithFrame:CGRectMake(0, 400, APP_SCREEN_WIDTH, 200)];
    barChartView.dataLists = dataList1;
    [self.view addSubview:barChartView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
