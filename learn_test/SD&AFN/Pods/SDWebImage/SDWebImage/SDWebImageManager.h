/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageOperation.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"

typedef NS_OPTIONS(NSUInteger, SDWebImageOptions) {
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * This flag disable this blacklisting.
     通常情况下，请求失败的URL会进入黑名单，不会再次请求；该枚举禁止了这个特性，失败的URL下次已经会再次请求
     */
    SDWebImageRetryFailed = 1 << 0,

    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * leading to delayed download on UIScrollView deceleration for instance.
     默认情况下，图片会在用户交互的时候开始下载（手滑动scrollView）。这个flag禁止此特性，会在scrollview减速的时候开始下载
     */
    SDWebImageLowPriority = 1 << 1,

    /**
     * This flag disables on-disk caching after the download finished, only cache in memory
     这个flag禁止磁盘缓存，只允许内存缓存
     */
    SDWebImageCacheMemoryOnly = 1 << 2,

    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * By default, the image is only displayed once completely downloaded.
     默认情况下，图片会在下载完全后才显示，这个flag禁止了此特性，在图片下载过程中就可以显示（像网页一样，一部分一部分地显示）
     */
    SDWebImageProgressiveDownload = 1 << 3,

    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of SDWebImage leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embedded cache busting parameter.
     刷新缓存，默认情况下根据图片的URL生成的key重缓存查找图片，当没找到时才从磁盘找，没找到然后下载，但是当图片换了，URL没换时，就会出现问题，这个flag帮助解决这种情况
     */
    SDWebImageRefreshCached = 1 << 4,

    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     启动后台下载，当app进入后台时，图片继续下载，过期后就会取消
     */
    SDWebImageContinueInBackground = 1 << 5,

    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     通过设置处理存储在NSHTTPCookieStore中的cookie
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    SDWebImageHandleCookies = 1 << 6,

    /**
     * Enable to allow untrusted SSL certificates.
     * Useful for testing purposes. Use with caution in production.
     允许不受信任的SSL证书。
     用于测试目的。在生产中小心使用。
     */
    SDWebImageAllowInvalidSSLCertificates = 1 << 7,

    /**
     * By default, images are loaded in the order in which they were queued. This flag moves them to
     * the front of the queue.
     高优先级下载，默认按照队列依次下载
     */
    SDWebImageHighPriority = 1 << 8,
    
    /**
     * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
     * of the placeholder image until after the image has finished loading.
     默认情况下，在图片下载之前，placeholder图片已经下载完了，这个flag禁止了这个操作，导致图片下载完后，才开始下载placholder图片
     */
    SDWebImageDelayPlaceholder = 1 << 9,

    /**
     * We usually don't call transformDownloadedImage delegate method on animated images,
     * as most transformation code would mangle it.
     * Use this flag to transform them anyway.
     */
    SDWebImageTransformAnimatedImage = 1 << 10,
    
    /**
     * By default, image is added to the imageView after download. But in some cases, we want to
     * have the hand before setting the image (apply a filter or add it with cross-fade animation for instance)
     * Use this flag if you want to manually set the image in the completion when success
     默认情况下，图像是在下载后添加到imageView。但在某些情况下，我们想
     在设置图像之前先做某些操作(例如，应用滤镜或使用交叉淡出动画添加)
     如果想在完成时手动设置图像，请使用此标志
     */
    SDWebImageAvoidAutoSetImage = 1 << 11,
    
    /**
     * By default, images are decoded respecting their original size. On iOS, this flag will scale down the
     * images to a size compatible with the constrained memory of devices.
     * If `SDWebImageProgressiveDownload` flag is set the scale down is deactivated.
     默认情况下，图像会根据原始大小进行解码。在iOS中，这个标志会缩小图像的大小与设备的有限内存兼容。
     这个flag会导致缩小的比例将被取消。
     */
    SDWebImageScaleDownLargeImages = 1 << 12,
    
    /**
     * By default, we do not query disk data when the image is cached in memory. This mask can force to query disk data at the same time.
     * This flag is recommend to be used with `SDWebImageQueryDiskSync` to ensure the image is loaded in the same runloop.
     默认情况下，当图像缓存在内存中时，我们不会查询磁盘数据。这个掩码可以强制同时查询磁盘数据。
     此标志建议与' SDWebImageQueryDiskSync '一起使用，以确保图像被加载到同一个运行循环中。
     */
    SDWebImageQueryDataWhenInMemory = 1 << 13,
    
    /**
     * By default, we query the memory cache synchronously, disk cache asynchronously. This mask can force to query disk cache synchronously to ensure that image is loaded in the same runloop.
     * This flag can avoid flashing during cell reuse if you disable memory cache or in some other cases.
     默认情况下，我们同步查询内存缓存，异步查询磁盘缓存。这个掩码可以强制同步查询磁盘缓存，以确保在同一个runloop中加载映像。
     如果禁用内存缓存或在其他情况下禁用内存缓存，此标志可以避免在单元重用期间闪烁。
     */
    SDWebImageQueryDiskSync = 1 << 14,
    
    /**
     * By default, when the cache missed, the image is download from the network. This flag can prevent network to load from cache only.
     默认情况下，当缓存丢失时，图像将从网络下载。这个flag可阻止网络只从缓存加载。
     */
    SDWebImageFromCacheOnly = 1 << 15,
    /**
     * By default, when you use `SDWebImageTransition` to do some view transition after the image load finished, this transition is only applied for image download from the network. This mask can force to apply view transition for memory and disk cache as well.
     默认情况下，当您在图像加载完成后使用`SDWebImageTransition`来做一些视图转换时，这个转换只适用于从网络下载图像。这个掩码还可以强制为内存和磁盘缓存应用视图转换。
     */
    SDWebImageForceTransition = 1 << 16
};


/**
 图片下载完成的回调（外部使用，一般是在我们常使用的分类方法中使用）

 @param image 图片
 @param error 错误信息
 @param cacheType 图片获取方式（内存缓存，磁盘，网络）
 @param imageURL 图片URL
 */
typedef void(^SDExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL);


/**
 图片下载完成后回调（内部使用，仅在本类中使用）

 @param image 图片，若请求出现错误则为nil
 @param data 图片数据
 @param error 错误信息
 @param cacheType 图片获取方式（本地缓存，磁盘，网络）
 @param finished 是否下载完成
 @param imageURL 图片URL
 */
typedef void(^SDInternalCompletionBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL);


/**
把URL处理成缓存用的key

 @param url URL
 @return 处理之后的key
 */
typedef NSString * _Nullable(^SDWebImageCacheKeyFilterBlock)(NSURL * _Nullable url);

 
/**
 将图片缓存到磁盘的解码算法

 @param image 图片
 @param data 图片数据
 @param imageURL 图片URL
 @return 数据
 */
typedef NSData * _Nullable(^SDWebImageCacheSerializerBlock)(UIImage * _Nonnull image, NSData * _Nullable data, NSURL * _Nullable imageURL);


@class SDWebImageManager;

@protocol SDWebImageManagerDelegate <NSObject>

@optional

/**
 * Controls which image should be downloaded when the image is not found in the cache.
 *若缓存中没有发现该图片，控制是否去下载
 * @param imageManager The current `SDWebImageManager`
 * @param imageURL     The url of the image to be downloaded
 *
 * @return Return NO to prevent the downloading of the image on cache misses. If not implemented, YES is implied.
 返回NO是为了防止下载的图像在缓存丢失，如果没有实现该方法，就认为是YES
 */
- (BOOL)imageManager:(nonnull SDWebImageManager *)imageManager shouldDownloadImageForURL:(nullable NSURL *)imageURL;

/**
 * Controls the complicated logic to mark as failed URLs when download error occur.
 若下载失败，控制是否将改URL标记成失败的url
 * If the delegate implement this method, we will not use the built-in way to mark URL as failed based on error code;
 若代理实现了改方法，我们就不用标记改URL为失败的URL了
 @param imageManager The current `SDWebImageManager`
 @param imageURL The url of the image
 @param error The download error for the url
 @return Whether to block this url or not. Return YES to mark this URL as failed.
 返回YES标明标记成下载失败的URL
 */
- (BOOL)imageManager:(nonnull SDWebImageManager *)imageManager shouldBlockFailedURL:(nonnull NSURL *)imageURL withError:(nonnull NSError *)error;

/**
 * Allows to transform the image immediately after it has been downloaded and just before to cache it on disk and memory.
 允许在图片下载完成但没来得及存储的时候转换图片
 * NOTE: This method is called from a global queue in order to not to block the main thread.
 在Global queue中调用
 *
 * @param imageManager The current `SDWebImageManager`
 * @param image        The image to transform
 * @param imageURL     The url of the image to transform
 *
 * @return The transformed image object.
 返回转换后的图片
 */
- (nullable UIImage *)imageManager:(nonnull SDWebImageManager *)imageManager transformDownloadedImage:(nullable UIImage *)image withURL:(nullable NSURL *)imageURL;

@end

/**
 * The SDWebImageManager is the class behind the UIImageView+WebCache category and likes.
 * It ties the asynchronous downloader (SDWebImageDownloader) with the image cache store (SDImageCache).
 * You can use this class directly to benefit from web image downloading with caching in another context than
 * a UIView.
  SDWebImageManager 是UIImageView+WebCache类别后面的类，它将SDWebImageDownloader和SDImageCache绑定在一起
 *
 * Here is a simple example of how to use SDWebImageManager:
 *
 * @code

SDWebImageManager *manager = [SDWebImageManager sharedManager];
[manager loadImageWithURL:imageURL
                  options:0
                 progress:nil
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        // do something with image
                    }
                }];

 * @endcode
 */
@interface SDWebImageManager : NSObject

@property (weak, nonatomic, nullable) id <SDWebImageManagerDelegate> delegate;

@property (strong, nonatomic, readonly, nullable) SDImageCache *imageCache;
@property (strong, nonatomic, readonly, nullable) SDWebImageDownloader *imageDownloader;

/**
 * The cache filter is a block used each time SDWebImageManager need to convert an URL into a cache key. This can
 * be used to remove dynamic part of an image URL.
 每当SDWebImageManager需要覆盖缓存的URL时调用该block，去掉URL里面的动态部分
 * The following example sets a filter in the application delegate that will remove any query-string from the
 * URL before to use it as a cache key:
 *
 * @code

SDWebImageManager.sharedManager.cacheKeyFilter = ^(NSURL * _Nullable url) {
    url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
    return [url absoluteString];
};

 * @endcode
 */
@property (nonatomic, copy, nullable) SDWebImageCacheKeyFilterBlock cacheKeyFilter;

/**
 * The cache serializer is a block used to convert the decoded image, the source downloaded data, to the actual data used for storing to the disk cache. If you return nil, means to generate the data from the image instance, see `SDImageCache`.
 * For example, if you are using WebP images and facing the slow decoding time issue when later retriving from disk cache again. You can try to encode the decoded image to JPEG/PNG format to disk cache instead of source downloaded data.
 * @note The `image` arg is nonnull, but when you also provide a image transformer and the image is transformed, the `data` arg may be nil, take attention to this case.
 * @note This method is called from a global queue in order to not to block the main thread.
 * @code
 SDWebImageManager.sharedManager.cacheSerializer = ^NSData * _Nullable(UIImage * _Nonnull image, NSData * _Nullable data, NSURL * _Nullable imageURL) {
    SDImageFormat format = [NSData sd_imageFormatForImageData:data];
    switch (format) {
        case SDImageFormatWebP:
            return image.images ? data : nil;
        default:
            return data;
    }
 };
 * @endcode
 * The default value is nil. Means we just store the source downloaded data to disk cache.
 */
@property (nonatomic, copy, nullable) SDWebImageCacheSerializerBlock cacheSerializer;

/**
 * Returns global SDWebImageManager instance.
 *
 * @return SDWebImageManager shared instance
 */
+ (nonnull instancetype)sharedManager;

/**
 * Allows to specify instance of cache and image downloader used with image manager.
 允许用图像下载器、缓存实例化图像管理器
 
 * @return new instance of `SDWebImageManager` with specified cache and downloader.
 */
- (nonnull instancetype)initWithCache:(nonnull SDImageCache *)cache downloader:(nonnull SDWebImageDownloader *)downloader NS_DESIGNATED_INITIALIZER;

/**
 * Downloads the image at the given URL if not present in cache or return the cached version otherwise.
 *若缓存中没有，则下载图像，否则返回缓存版本
 * @param url            The URL to the image
 * @param options        A mask to specify options to use for this request
 * @param progressBlock  A block called while image is downloading
 *                       @note the progress block is executed on a background queue
 * @param completedBlock A block called when operation has been completed.
 *
 *   This parameter is required.
 * 
 *   This block has no return value and takes the requested UIImage as first parameter and the NSData representation as second parameter.
 *   In case of error the image parameter is nil and the third parameter may contain an NSError.
 *
 *   The forth parameter is an `SDImageCacheType` enum indicating if the image was retrieved from the local cache
 *   or from the memory cache or from the network.
 *
 *   The fith parameter is set to NO when the SDWebImageProgressiveDownload option is used and the image is
 *   downloading. This block is thus called repeatedly with a partial image. When image is fully downloaded, the
 *   block is called a last time with the full image and the last parameter set to YES.
 *
 *   The last parameter is the original image URL
 *
 * @return Returns an NSObject conforming to SDWebImageOperation. Should be an instance of SDWebImageDownloaderOperation
 */
- (nullable id <SDWebImageOperation>)loadImageWithURL:(nullable NSURL *)url
                                              options:(SDWebImageOptions)options
                                             progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                                            completed:(nullable SDInternalCompletionBlock)completedBlock;

/**
 * Saves image to cache for given URL
 *根据给定的URL将图像缓存
 * @param image The image to cache
 * @param url   The URL to the image
 *
 */

- (void)saveImageToCache:(nullable UIImage *)image forURL:(nullable NSURL *)url;

/**
 * Cancel all current operations
 取消当前所有操作
 */
- (void)cancelAll;

/**
 * Check one or more operations running
 检查一个或多个操作是否在执行
 */
- (BOOL)isRunning;

/**
 *  Async check if image has already been cached
 异步检测图像是否已经被缓存
 *
 *  @param url              image url
 *  @param completionBlock  the block to be executed when the check is finished
 *  
 *  @note the completion block is always executed on the main queue
 completion block 一般在主队列上执行
 */
- (void)cachedImageExistsForURL:(nullable NSURL *)url
                     completion:(nullable SDWebImageCheckCacheCompletionBlock)completionBlock;

/**
 *  Async check if image has already been cached on disk only
 *异步检测图像是否已经被存储在磁盘上
 *  @param url              image url
 *  @param completionBlock  the block to be executed when the check is finished
 *
 *  @note the completion block is always executed on the main queue
  completion block 一般在主队列上执行
 */
- (void)diskImageExistsForURL:(nullable NSURL *)url
                   completion:(nullable SDWebImageCheckCacheCompletionBlock)completionBlock;


/**
 *Return the cache key for a given URL
 根据URL返回cache key
 */
- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url;

@end
