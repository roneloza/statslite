//
//  NSString+Utils.m
//  TromeEnterate
//
//  Created by RLoza on 8/13/15.
//  Copyright (c) 2015 Empresa Editora El Comercio. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utils)

- (BOOL)validateStringEmail {
    
    BOOL success = NO;
    
    if (self.length >=1) {
     
        NSArray *components = [self componentsSeparatedByString:@"@"];
        
        if (components.count == 2) {
            
            __weak NSString *user = [components objectAtIndex:0];
            __weak NSString *domain = [components objectAtIndex:1];
            
            success = user.length > 1;
            success = success ? (domain.length >= 3 &&
                                 [domain rangeOfString:@"."].location != NSNotFound): success;
        }

    }
    
    return success;
}

- (NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

- (NSURL *)URLFromString {
    
    NSURL *URL = (self.length > 0 ?  [[NSURL alloc] initWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] : nil);
    
    return URL;
}

- (NSString *)URLEncodedString
{
    __autoreleasing NSString *encodedString;
    NSString *originalString = (NSString *)self;
    encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (__bridge CFStringRef)originalString,
                                                                                          NULL,
                                                                                          (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                          kCFStringEncodingUTF8
                                                                                          );
    return encodedString;
}

- (NSString *)URLDecodedString
{
    __autoreleasing NSString *decodedString;
    NSString *originalString = (NSString *)self;
    decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                          NULL,
                                                                                                          (__bridge CFStringRef)originalString,
                                                                                                          CFSTR(""),
                                                                                                          kCFStringEncodingUTF8
                                                                                                          );
    
    return decodedString;
}

+ (NSString *)stringDBValueOrDBNullFromInt:(NSInteger)value {
    
     return (value ? [[NSString alloc] initWithFormat:@"%i", (int)value] : @"null");
}

+ (NSString *)stringDBValueOrDBNull:(id)value {
    
    NSString *stringDBValue = @"null";
    
    if ([value isKindOfClass:[NSString class]]) {
        
        stringDBValue = ([value length] > 0 ? [[NSString alloc] initWithFormat:@"'%@'", [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"]] : @"null");
    }
    else if ([value isKindOfClass:[NSNull class]]) {
        
    }
    
    return stringDBValue;
}

+ (NSString *)stringDBValueOrNil:(id)value {
    
    NSString *stringValue = nil;
    
    if ([value isKindOfClass:[NSString class]]) {
        
        stringValue = ([value length] > 0 ? [[NSString alloc] initWithFormat:@"'%@'", [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"]] : @"null");
    }
    else if ([value isKindOfClass:[NSNull class]]) {
        
    }
    
    return stringValue;
}

- (NSString *)stringByStrippingHTML {
    
    NSRange range;
    NSString *str = [self copy];
    
    while ((range = [str rangeOfString:@"<[^>]*>"
                               options:NSRegularExpressionSearch]).location != NSNotFound) {
        
        str = [str stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return str;
}

- (NSString *)stringByHTMLString {
    
    NSRange range;
    NSString *str = [self copy];
    
    NSString *sHtml = @"";
    
    // @"<([^>]+)>(.+?)</([^>]+)>"
    // <font([^>]+)>(.+?)</font>
    while ((range = [str rangeOfString:@"<([^>]+)>(.+?)</([^>]+)>"
                               options:NSRegularExpressionSearch]).location != NSNotFound) {
        
        sHtml = [sHtml stringByAppendingString:[str substringWithRange:range]];
        
        str = [str stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return sHtml;
}


+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict {
    
    NSString *queryString = nil;
    
    if (dict && dict.count > 0) {
     
        NSMutableArray *pairs = [NSMutableArray array];
        
        for (NSString *key in [dict allKeys])
        {
            id value = [dict objectForKey:key];
            
            NSString *valueDescription = [value description];
            //NSString *escapedValue = [valueDescription URLEncodedString];
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, valueDescription]];
        }
        
        queryString = [pairs componentsJoinedByString:@"&"];
    }
    
    return queryString;
}

+ (NSString*)jsonStringFrom:(NSDictionary *)dict withPrettyPrint:(BOOL)prettyPrint {
   
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:(NSJSONWritingOptions)
                        (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)stringByDecodeHTMLCharacterEntities {
    
    if ([self rangeOfString:@"&"].location == NSNotFound) {
        return self;
    }
    else {
        
        NSMutableString *escaped = [NSMutableString stringWithString:self];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [self rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", (unsigned short) (160 + i)]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
        
        // The following five are not in the 160+ range
        
        // @"&amp;"
        NSRange range = [self rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 38]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [self rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 60]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [self rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 62]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&apos;"
        range = [self rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 39]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&quot;"
        range = [self rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 34]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&ldquo;"
        range = [self rangeOfString:@"&ldquo;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&ldquo;"
                                     withString:@"\""
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&rdquo;"
        range = [self rangeOfString:@"&rdquo;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&rdquo;"
                                     withString:@"\""
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lsquo;"
        range = [self rangeOfString:@"&lsquo;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&lsquo;"
                                     withString:@"\""
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&rsquo;"
        range = [self rangeOfString:@"&rsquo;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&rsquo;"
                                     withString:@"\""
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        // @"&mdash;"
        range = [self rangeOfString:@"&mdash;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&mdash;"
                                     withString:@"--"
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&ndash;"
        range = [self rangeOfString:@"&ndash;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&ndash;"
                                     withString:@"-"
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unsigned short) tempInt] atIndex:entityRange.location];
                } else {
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unsigned short) [value intValue]] atIndex:entityRange.location];
                } i = start.location;
            } else { i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        
        return [escaped copy];    // Note this is autoreleased
    }
}

+ (NSString *)localDateStringWithName:(NSString *)name format:(NSString *)format {

//    @"dd/MM/yyyy"
//    @"dd/MM/yyyy HH:mm:ss"
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:name];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    
    //Create a date string in the local timezone
    df.timeZone = timeZone;
    
    NSString *localDateString = [df stringFromDate:[NSDate date]];
    
//    NSLog(@"date = %@", localDateString);
    
    // My local timezone is: Europe/London (GMT+01:00) offset 3600 (Daylight)
    // prints out: date = 08/12/2013 22:01
    
    return localDateString;
}

@end
