// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NTENote.h instead.

#import <CoreData/CoreData.h>


extern const struct NTENoteAttributes {
	__unsafe_unretained NSString *body;
	__unsafe_unretained NSString *entityId;
	__unsafe_unretained NSString *title;
} NTENoteAttributes;

extern const struct NTENoteRelationships {
} NTENoteRelationships;

extern const struct NTENoteFetchedProperties {
} NTENoteFetchedProperties;






@interface NTENoteID : NSManagedObjectID {}
@end

@interface _NTENote : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NTENoteID*)objectID;





@property (nonatomic, strong) NSString* body;



//- (BOOL)validateBody:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* entityId;



//- (BOOL)validateEntityId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _NTENote (CoreDataGeneratedAccessors)

@end

@interface _NTENote (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBody;
- (void)setPrimitiveBody:(NSString*)value;




- (NSString*)primitiveEntityId;
- (void)setPrimitiveEntityId:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
