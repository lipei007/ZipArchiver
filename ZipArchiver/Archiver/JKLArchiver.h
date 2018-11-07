//
//  JKLArchiver.h
//  ZipArchiver
//
//  Created by Jack on 2018/11/7.
//  Copyright © 2018年 Jack Template. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JKLArchiver : NSObject

/**
 * @brief 解压离线下载的压缩包
 * @param path 待解压文件路径
 * @param to 解压至目标文件夹
 * @param password 解压密码，可为空
 * @return 解压是否成功
 */
+ (BOOL)jkl_unzipOfflineZip:(NSString *)path toDir:(NSString *)to withPassword:(NSString *)password;

/**
 * @brief 压缩文件/文件夹
 * @param file 被压缩文件/文件夹
 * @param password 压缩密码，可谓空
 * @return 压缩是否成功
 */
+ (BOOL)jkl_zipFile:(NSString *)file withPassword:(NSString *)password;

/**
 * @brief 压缩文件/文件夹
 * @param files 被压缩文件/文件夹路径 数组
 * @param path 压缩文件存放路径
 * @param password 压缩密码，可谓空
 * @return 压缩是否成功
 */
+ (BOOL)jkl_zipFiles:(NSArray<NSString *> *)files toPath:(NSString *)path withPassword:(NSString *)password;

@end
