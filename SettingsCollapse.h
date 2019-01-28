#import "AppsPagingView.h"
#import "CustomHeaderFooterView.h"

@interface PSSpecifier : NSObject

@property (nonatomic,retain) NSString * identifier;
-(void)performControllerLoadAction;
-(BOOL)isEqualToSpecifier:(id)arg1;

@end

@interface PSTableCell : UITableViewCell <AppsPagingViewDelegate>

@property (nonatomic, retain) AppsPagingView *pagingView;
@property (nonatomic, assign) id<AppsPagingCellDelegate> delegate;
-(id)getLazyIcon;
-(id)blankIcon;
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
-(void)refreshCellContentsWithSpecifier:(id)arg1;
-(void)setSpecifier:(PSSpecifier *)arg1;
-(void)setupPagingView;
-(void)layout;
-(id)iconImageView;

@end

@interface PSListController: UIViewController {
    NSMutableArray* _groups;
    NSMutableDictionary* _specifiersByID;
}

-(id)getGroupSpecifierForSpecifierID:(id)arg1;
-(id)specifiersInGroup:(long long)arg1;
-(NSRange)rangeOfSpecifiersInGroupID:(id)arg1;
-(BOOL)performLoadActionForSpecifier:(id)arg1;
-(id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
-(id)indexPathForSpecifier:(id)arg1;
-(id)specifierAtIndexPath:(id)arg1;
-(id)specifierForID:(id)arg1;

@end

@interface PSUIPrefsListController: PSListController <CustomHeaderFooterViewDelegate, AppsPagingCellDelegate>

-(id)table;
-(long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2;
-(void)insertOrderedSpecifier:(id)arg1 animated:(BOOL)arg2;
-(id)specifiers;
-(void)_showControllerFromSpecifier:(id)arg1;
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2;
-(void)_setAirplaneMode:(BOOL)arg1;
+(BOOL)airplaneMode;

@end

@interface UIImage ()

+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3 ;
+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 ;

@end
