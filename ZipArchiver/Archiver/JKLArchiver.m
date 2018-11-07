//
//  JKLArchiver.m
//  ZipArchiver
//
//  Created by Jack on 2018/11/7.
//  Copyright © 2018年 Jack Template. All rights reserved.
//

#import "JKLArchiver.h"
#import "ZipArchive.h"

@implementation JKLArchiver


/**
 * @brief 解压离线下载的压缩包
 * @param path 待解压文件路径
 * @param to 解压至目标文件夹
 * @param password 解压密码，可为空
 * @return 解压是否成功
 */
+ (BOOL)jkl_unzipOfflineZip:(NSString *)path toDir:(NSString *)to withPassword:(NSString *)password {
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    BOOL zipRes = NO;
    if (password) {
        zipRes = [zip UnzipOpenFile:path Password:password];
    } else {
        zipRes = [zip UnzipOpenFile:path];
    }
    
    if (zipRes) {
        zipRes = [zip UnzipFileTo:to overWrite:YES];
    }
    [zip UnzipCloseFile];
    
    return zipRes;
}

/**
 * @brief 压缩文件/文件夹
 * @param file 被压缩文件/文件夹
 * @param password 压缩密码，可谓空
 * @return 压缩是否成功
 */
+ (BOOL)jkl_zipFile:(NSString *)file withPassword:(NSString *)password {
    if (file.length == 0) {
        return NO;
    }

    NSFileManager *fm = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:file isDirectory:&isDir]) {
        
        NSString *zipFile = [file stringByAppendingPathExtension:@"zip"];
        
        ZipArchive *zip = [[ZipArchive alloc] init];
        if (password) {
            [zip CreateZipFile2:zipFile Password:password];
        } else {
            [zip CreateZipFile2:zipFile];
        }
        
        NSString *name = file.lastPathComponent;
        if (isDir) {
            
            NSArray<NSString *> *subPathArr = [fm subpathsAtPath:file];
            [subPathArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *subPath = [file stringByAppendingPathComponent:obj];
                BOOL subPathIsDir = NO;
                if ([fm fileExistsAtPath:subPath isDirectory:&subPathIsDir] && !subPathIsDir) {
                    
                    [zip addFileToZip:subPath newname:[name stringByAppendingPathComponent:obj]];
                }
            }];
            
        } else {
            
            [zip addFileToZip:file newname:name];
        }
        
        [zip CloseZipFile2];
        
        return YES;
    }
    
    
    return NO;
}

/**
 * @brief 压缩文件/文件夹
 * @param files 被压缩文件/文件夹路径 数组
 * @param path 压缩文件存放路径
 * @param password 压缩密码，可谓空
 * @return 压缩是否成功
 */
+ (BOOL)jkl_zipFiles:(NSArray<NSString *> *)files toPath:(NSString *)path withPassword:(NSString *)password {
    
    if (files == nil || files.count == 0 || path == nil) {
        return NO;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *parent = [path stringByDeletingLastPathComponent];
    BOOL isParentDir = NO;
    if ([fm fileExistsAtPath:parent isDirectory:&isParentDir] && isParentDir) {
        
    } else {
        NSError *err = nil;
        [fm createDirectoryAtPath:parent withIntermediateDirectories:YES attributes:nil error:&err];
        if (err) {
            NSLog(@"error: %@",err);
            return NO;
        }
    }
    
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:path isDirectory:&isDir] && !isDir) {
        NSError *err = nil;
        [fm removeItemAtPath:path error:&err];
        if (err) {
            NSLog(@"error: %@",err);
            return NO;
        }
    }
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    if (password) {
        [zip CreateZipFile2:path Password:password];
    } else {
        [zip CreateZipFile2:path];
    }
    
    [files enumerateObjectsUsingBlock:^(NSString * _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
       
        BOOL isDir = NO;
        if ([fm fileExistsAtPath:file isDirectory:&isDir]) {
            
            NSString *name = file.lastPathComponent;
            if (isDir) {
                
                NSArray<NSString *> *subPathArr = [fm subpathsAtPath:file];
                [subPathArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSString *subPath = [file stringByAppendingPathComponent:obj];
                    BOOL subPathIsDir = NO;
                    if ([fm fileExistsAtPath:subPath isDirectory:&subPathIsDir] && !subPathIsDir) {
                        
                        [zip addFileToZip:subPath newname:[name stringByAppendingPathComponent:obj]];
                    }
                }];
                
            } else {
                
                [zip addFileToZip:file newname:name];
            }
        }
        
    }];
    
    [zip CloseZipFile2];
    
    return YES;
}


@end
