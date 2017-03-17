# RMChartTest
实现功能：
1. 实现折线图显示
2. 实现柱状图显示
3. 折线图循环滚动的封装
4. 折线图圆圈按钮点击显示浮层

代码注释详细，可直接看代码。
1. 数据初始化，可根据实际情况作出修改
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

2. 循环滚动的数据初始化
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


3. 折线图调用
RMLineChartView *lineChartView = [[RMLineChartView alloc]initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, 200)];
lineChartView.dataLists = dataList1;
[self.view addSubview:lineChartView];

4. 柱状图调用
RMBarChartView *barChartView = [[RMBarChartView alloc]initWithFrame:CGRectMake(0, 400, APP_SCREEN_WIDTH, 200)];
    barChartView.dataLists = dataList1;
    [self.view addSubview:barChartView];

5. 折线循环滚动加标题的调用
RMLineChartScrollView *lineChartScrollView = [[RMLineChartScrollView alloc]initWithFrame:CGRectMake(0, 50, APP_SCREEN_WIDTH, 250)];
lineChartScrollView.dataLists = scrollLineArray;
[self.view addSubview:lineChartScrollView];

废话不多说直接上效果图
实现功能：
1. 实现折线图显示
2. 实现柱状图显示
3. 折线图循环滚动的封装
4. 折线图圆圈按钮点击显示浮层

代码注释详细，可直接看代码。
1. 数据初始化，可根据实际情况作出修改
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

2. 循环滚动的数据初始化
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


3. 折线图调用
RMLineChartView *lineChartView = [[RMLineChartView alloc]initWithFrame:CGRectMake(0, 100, APP_SCREEN_WIDTH, 200)];
lineChartView.dataLists = dataList1;
[self.view addSubview:lineChartView];

4. 柱状图调用
RMBarChartView *barChartView = [[RMBarChartView alloc]initWithFrame:CGRectMake(0, 400, APP_SCREEN_WIDTH, 200)];
    barChartView.dataLists = dataList1;
    [self.view addSubview:barChartView];

5. 折线循环滚动加标题的调用
RMLineChartScrollView *lineChartScrollView = [[RMLineChartScrollView alloc]initWithFrame:CGRectMake(0, 50, APP_SCREEN_WIDTH, 250)];
lineChartScrollView.dataLists = scrollLineArray;
[self.view addSubview:lineChartScrollView];

废话不多说直接上效果图
csdn:http://blog.csdn.net/qq_25303213/article/details/62884249

