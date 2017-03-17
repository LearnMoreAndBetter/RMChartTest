//
//  RMChartModel.h
//  RMChartTest
//
//  Created by CETC-Server on 17/3/17.
//  Copyright © 2017年 CETC-Server. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMChartModel : NSObject

@property (nonatomic, copy)NSString *dateTime;
@property (nonatomic, copy)NSString *value;

+ (RMChartModel *)initModelWithData:(NSDictionary *)dic;

@end
