//
//  RMChartModel.m
//  RMChartTest
//
//  Created by CETC-Server on 17/3/17.
//  Copyright © 2017年 CETC-Server. All rights reserved.
//

#import "RMChartModel.h"

@implementation RMChartModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+ (RMChartModel *)initModelWithData:(NSDictionary *)dic{
    RMChartModel *model = [[RMChartModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
