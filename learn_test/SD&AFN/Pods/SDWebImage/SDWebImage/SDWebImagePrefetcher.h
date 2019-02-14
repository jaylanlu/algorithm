/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"

@class SDWebImagePrefetcher;

@protocol SDWebImagePrefetcherDelegate <NSObject>

@optional

/**
 * Called when an image was prefetched.
 每当一张图片预获取完后调用
 *
 * @param imagePrefetcher The current image prefetcher
 当前图片的获取器
 * @param imageURL        The image url that was prefetched
 被获取的图片链接
 * @param finishedCount   The total number of images that were prefetched (successful or not)
 获取完的图片数量（包括成功和失败的）
 * @param totalCount      The total number of images that were to be prefetched
 原本想获取的图片总数
 */
- (void)imagePrefetcher:(nonnull SDWebImagePrefetcher *)imagePrefetcher didPrefetchURL:(nullable NSURL *)imageURL finishedCount:(NSUInteger)finishedCount totalCount:(NSUInteger)totalCount;

/**
 * Called when all images are prefetched.
 所有图片获取完成后调用
 * @param imagePrefetcher The current image prefetcher
 当前图片的获取器
 * @param totalCount      The total number of images that were prefetched (whether successful or not)
 获取完的图片的数量（包括成功和失败的）
 * @param skippedCount    The total number of images that were skipped
 漏掉的（被忽略请求的图片的）数量
 */
- (void)imagePrefetcher:(nonnull SDWebImagePrefetcher *)imagePrefetcher didFinishWithTotalCount:(NSUInteger)totalCount skippedCount:(NSUInteger)skippedCount;

@end

/**
  预获取过程中调用的两个block

 @param noOfFinishedUrls 预获取完成的图片的数量（包括成功和失败的）
 @param noOfTotalUrls 原计划预获取图片的总数量
 @para noOfSkippedUrls 漏掉的图片的数量（被忽略请求的图片的数量）
 */
typedef void(^SDWebImagePrefetcherProgressBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls);
typedef void(^SDWebImagePrefetcherCompletionBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls);

/**
 * Prefetch some URLs in the cache for future use. Images are downloaded in low priority.
 预获取缓存中的一些URL以供将来使用，以低优先级模型下载图片
 */
@interface SDWebImagePrefetcher : NSObject

/**
 *  The web image manager
 网页图片管理器
 */
@property (strong, nonatomic, readonly, nonnull) SDWebImageManager *manager;

/**
 * Maximum number of URLs to prefetch at the same time. Defaults to 3.
 同时预获取图片的最大数目，默认为3
 */
@property (nonatomic, assign) NSUInteger maxConcurrentDownloads;

/**
 * SDWebImageOptions for prefetcher. Defaults to SDWebImageLowPriority.
 预加载的SDWebImageOptions,默认是低优先级
 */
@property (nonatomic, assign) SDWebImageOptions options;

/**
 * Queue options for Prefetcher. Defaults to Main Queue.
 预加载提供的队列选项，默认是主队列
 */
@property (strong, nonatomic, nonnull) dispatch_queue_t prefetcherQueue;

//代理
@property (weak, nonatomic, nullable) id <SDWebImagePrefetcherDelegate> delegate;

/**
 * Return the global image prefetcher instance.
 返回图片获取器的一个全局实例
 */
+ (nonnull instancetype)sharedImagePrefetcher;

/**
 * Allows you to instantiate a prefetcher with any arbitrary image manager.
 允许使用任何图片管理器实例化图片预获取器
 */
- (nonnull instancetype)initWithImageManager:(nonnull SDWebImageManager *)manager NS_DESIGNATED_INITIALIZER;

/**
 * Assign list of URLs to let SDWebImagePrefetcher to queue the prefetching,
 * currently one image is downloaded at a time,
 * and skips images for failed downloads and proceed to the next image in the list.
 * Any previously-running prefetch operations are canceled.
 分配URL列表使得SDWebImagePrefetcher来安排预加载队列，当前同一时间下载一张d图片，忽略被下载失败的图片并继续执行列表中的下一张图片，任何之前执行的预加载操作都会被取消
 *
 * @param urls list of URLs to prefetch
 */
- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls;

/**
 * Assign list of URLs to let SDWebImagePrefetcher to queue the prefetching,
 * currently one image is downloaded at a time,
 * and skips images for failed downloads and proceed to the next image in the list.
 * Any previously-running prefetch operations are canceled.
 *
 * @param urls            list of URLs to prefetch
 预加载的URL列表
 * @param progressBlock   block to be called when progress updates; 
 *                        first parameter is the number of completed (successful or not) requests, 
 *                        second parameter is the total number of images originally requested to be prefetched
 进度更新时block被调用，第一个参数是完成请求的个数（包括成功和失败的），第二个参数是所有预加载图片的原始请求数目
 * @param completionBlock block to be called when prefetching is completed
 *                        first param is the number of completed (successful or not) requests,
 *                        second parameter is the number of skipped requests
 预加载完成后被block调用，第一个参数是完成请求的个数（包括成功和失败的），第二个参数是被忽略的请求数目
 */
- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls
            progress:(nullable SDWebImagePrefetcherProgressBlock)progressBlock
           completed:(nullable SDWebImagePrefetcherCompletionBlock)completionBlock;

/**
 * Remove and cancel queued list
 */
- (void)cancelPrefetching;


@end
