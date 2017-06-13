//
//  Item.m
//  statslite
//
//  Created by rone shender loza aliaga on 4/16/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "Item.h"
#import <objC/message.h>

@implementation Item

@synthesize propertyListClassNames = _propertyListClassNames;
@synthesize propertyListClassValues = _propertyListClassValues;
@synthesize propertyKeyPairs = _propertyKeyPairs;

- (id)initWithTitle:(NSString *)title content:(NSString *)content {
    
    if ((self = [super init])) {
        
        _title = title;
        _content = content;
        _enabled = YES;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled {
    
    if ((self = [super init])) {
        
        _title = title;
        _content = content;
        _enabled = enabled;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled key:(NSString *)key {
    
    if ((self = [super init])) {
        
        _title = title;
        _content = content;
        _enabled = enabled;
        _key = key;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled storyBoarID:(NSString *)storyBoarID {
 
    if ((self = [super init])) {
        
        _title = title;
        _content = content;
        _enabled = enabled;
        _storyBoarID = storyBoarID;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled storyBoarID:(NSString *)storyBoarID imageNamed:(NSString *)imageNamed {
    
    if ((self = [super init])) {
        
        _title = title;
        _content = content;
        _enabled = enabled;
        _storyBoarID = storyBoarID;
        _imageNamed = imageNamed;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled imageNamed:(NSString *)imageNamed {
    
    if ((self = [super init])) {
        
        _title = title;
        _content = content;
        _enabled = enabled;
        _imageNamed = imageNamed;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    __weak Item *wkself = self;
    
    Item *object = [[NSClassFromString(NSStringFromClass([wkself class])) allocWithZone: zone] init];
    
    if ([object conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
        
        for (__weak NSString *propertyName in [object propertyListClassNames]) {
            
            SEL propertySetSelector = NSSelectorFromString([[NSString alloc] initWithFormat:@"set%@:", [propertyName capitalizedString]]);
            SEL propertyGetSelector = NSSelectorFromString(propertyName);
            
            if (class_respondsToSelector([object class], propertySetSelector)) {
                
                id (*objc_msgSendTypedGetter)(id selfObject, SEL _cmd) = (void*)objc_msgSend;
                void (*objc_msgSendTypedSetter)(id selfObject, SEL _cmd, id object) = (void*)objc_msgSend;
                
                id value = objc_msgSendTypedGetter(wkself, propertyGetSelector);
                
                //                if (value && ![value isKindOfClass:[NSNull class]]) {
                if (![value isKindOfClass:[NSNull class]]) {
                    
                    objc_msgSendTypedSetter(object, propertySetSelector, value);
                }
                
            }
        }
    }
    
    return object;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    __weak Item *wkself = self;
    
    if ([wkself conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
        
        for (__weak NSString *propertyName in [wkself propertyListClassNames]) {
            
            SEL propertySetSelector = NSSelectorFromString([[NSString alloc] initWithFormat:@"set%@:", [propertyName capitalizedString]]);
            SEL propertyGetSelector = NSSelectorFromString(propertyName);
            
            if (class_respondsToSelector([wkself class], propertySetSelector)) {
                
                id (*objc_msgSendTypedGetter)(id selfObject, SEL _cmd) = (void*)objc_msgSend;
                
                id value = objc_msgSendTypedGetter(self, propertyGetSelector);
                
                if (![value isKindOfClass:[NSNull class]]) {
                    
                    [encoder encodeObject:value forKey:propertyName];
                }
                
            }
        }
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    //    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    //    float rating = [decoder decodeFloatForKey:kRatingKey];
    //    return [self initWithTitle:title rating:rating];
    
    __weak Item *wkself = self;
    
    Item *object = [[NSClassFromString(NSStringFromClass([wkself class])) alloc] init];
    
    if ([object conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
        
        for (__weak NSString *propertyName in [object propertyListClassNames]) {
            
            SEL propertySetSelector = NSSelectorFromString([[NSString alloc] initWithFormat:@"set%@:", [propertyName capitalizedString]]);
            
            if (class_respondsToSelector([object class], propertySetSelector)) {
                
                void (*objc_msgSendTypedSetter)(id selfObject, SEL _cmd, id object) = (void*)objc_msgSend;
                
                id value = [decoder decodeObjectForKey:propertyName];
                
                if (![value isKindOfClass:[NSNull class]]) {
                    
                    objc_msgSendTypedSetter(object, propertySetSelector, value);
                }
                
            }
        }
    }
    
    return object;
}

- (NSArray *)propertyListClassNames {
    
    if (!_propertyListClassNames) {
        
        unsigned int outCount, i;
        
        objc_property_t *properties = class_copyPropertyList(NSClassFromString(NSStringFromClass([self class])), &outCount);
        NSMutableArray *propertiesArray = [[NSMutableArray alloc] initWithCapacity:outCount];
        
        for (i = 0; i < outCount; i++) {
            
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            [propertiesArray addObject:propertyName];
        }
        
        free(properties);
        
        _propertyListClassNames = [propertiesArray copy];
    }
    
    return _propertyListClassNames;
}

- (NSArray *)propertyListClassValues {
    
    if (!_propertyListClassValues) {
        
        NSMutableArray *propertiesArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        if ([self conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
            
            for (__weak NSString *propertyName in [self propertyListClassNames]) {
                
                SEL propertyGetSelector = NSSelectorFromString(propertyName);
                
                if (class_respondsToSelector([self class], propertyGetSelector)) {
                    
                    id (*objc_msgSendTypedGetter)(id selfObject, SEL _cmd) = (void*)objc_msgSend;
                    
                    id value = objc_msgSendTypedGetter(self, propertyGetSelector);
                    
                    if (value && ![value isKindOfClass:[NSNull class]]) {
                        
                        [propertiesArray addObject:value];
                    }
                    else {
                        
                        [propertiesArray addObject:[NSNull null]];
                    }
                }
            }
        }
        
        _propertyListClassValues = [propertiesArray copy];
    }
    
    return _propertyListClassValues;
}

- (NSDictionary *)propertyKeyPairs {
    
    if (!_propertyKeyPairs) {
        
        NSMutableDictionary *propertiesDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        if ([self conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
            
            for (__weak NSString *propertyName in [self propertyListClassNames]) {
                
                SEL propertyGetSelector = NSSelectorFromString(propertyName);
                
                if (class_respondsToSelector([self class], propertyGetSelector)) {
                    
                    id (*objc_msgSendTypedGetter)(id selfObject, SEL _cmd) = (void*)objc_msgSend;
                    
                    id value = objc_msgSendTypedGetter(self, propertyGetSelector);
                    
                    if (value && ![value isKindOfClass:[NSNull class]]) {
                        
                        [propertiesDictionary setValue:value forKey:propertyName];
                    }
                    else {
                        
                        [propertiesDictionary setValue:[NSNull null] forKey:propertyName];
                    }
                }
            }
        }
        
        _propertyKeyPairs = [propertiesDictionary copy];
    }
    
    return _propertyKeyPairs;
}

@end
