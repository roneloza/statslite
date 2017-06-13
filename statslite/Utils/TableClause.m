//
//  TableClause.m
//  sgs
//
//  Created by rone loza on 5/24/17.
//  Copyright © 2017 Novit. All rights reserved.
//

#import "TableClause.h"

@implementation TableClause

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value operatorCondition:(NSString *)operatorCondition operatorExpression:(NSString *)operatorExpression {
    
    if ((self = [super init])) {
        
        _key = key;
        _value = value;
        _operatorCondition = operatorCondition;
        _operatorExpression = operatorExpression;
    }
    
    return self;
}
@end
