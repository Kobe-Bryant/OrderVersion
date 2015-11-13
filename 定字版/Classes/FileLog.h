//
//  FileLog.h
//  customize
//
//  Created by MC374 on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileLog : NSObject
+ (NSString*)logFilePath;
+ (void)startLog;
+ (void)finishLog;
+ (BOOL)deleteLogFile;
@end
