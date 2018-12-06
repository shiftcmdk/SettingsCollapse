@protocol AppsPagingViewDelegate
-(void)didSelectItemAtIndex:(int)index;
@end

@protocol AppsPagingCellDelegate
-(void)cell:(UITableViewCell *)cell didSelectItemAtIndex:(int)index;
@end

@interface AppsPagingView: UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, retain) NSMutableArray *appImages;
@property (nonatomic, assign) id<AppsPagingViewDelegate> delegate;
-(void)setImages:(NSMutableArray *)images;
-(void)setImage:(UIImage *)image atIndex:(int)index;
-(void)updateToggles:(NSSet *)enabledToggles disabledToggles:(NSSet *)disabledToggles;
@property(nonatomic, retain) UICollectionView *collectionView;
@property(nonatomic, retain) NSSet *enabledToggles;
@property(nonatomic, retain) NSSet *disabledToggles;

@end