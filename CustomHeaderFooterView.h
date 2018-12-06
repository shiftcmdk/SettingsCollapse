#import <libcolorpicker.h>

@protocol CustomHeaderFooterViewDelegate
-(void)didTapButtonAtIndex:(NSInteger)index;
@end

@interface CustomHeaderFooterView: UITableViewHeaderFooterView

@property(nonatomic, retain) UIButton *expandHideButton;
@property(nonatomic, retain) UIVisualEffectView *visualEffectView;
@property (nonatomic, assign) id<CustomHeaderFooterViewDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL useChevron;

@end