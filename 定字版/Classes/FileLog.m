//
//  FileLog.m
//  customize
//
//  Created by MC374 on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileLog.h"
#import "FileManager.h"

@implementation FileLog

+ (NSString*)logFilePath {
    //非越狱版路径
//#ifndef CRACK
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    //越狱版路径
//#else
//    NSString *documentsDirectory = @"/var/root/Media/xiaodao/";
//#endif
//    NSString *logDir = [documentsDirectory stringByAppendingPathComponent:@"logs"];    
//    BOOL isDir = YES;
//    //如果logs文件夹存不存在，则创建
//    if([[NSFileManager defaultManager] fileExistsAtPath:logDir isDirectory:&isDir] == NO)
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:nil];
//    }
	[FileManager removeFile:@"log.log"];
	[FileManager createFile:@"log.log"];
	NSString *logPath = [FileManager getFilePath:@"log.log"];

    //以当天的时间为文件名，文件名后缀为.log
//    NSString *fileName =[NSString stringWithFormat:@"%@.log",@"log"];
//    NSString *logPath = [logDir stringByAppendingPathComponent:fileName];
    return logPath;
}

+ (void)startLog {
    freopen([[self logFilePath] cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

+ (void)finishLog { 
    fflush(stderr);
    dup2(dup(STDERR_FILENO), STDERR_FILENO);
    close(dup(STDERR_FILENO));
 }

+ (BOOL)deleteLogFile {
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[self logFilePath] error:nil];
    return success;
 }
@end
