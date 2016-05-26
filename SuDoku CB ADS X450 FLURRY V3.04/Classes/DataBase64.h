//
//  NSData+Base64.h
//  msmestorage
//
//  Created by Sergey Teryokhin on 7/2/08.
//  Copyright 2008 imacdev@mac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (MBBase64)

+ (id) dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;

@end
