//
//  ASLEvaluator.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "seal/evaluator.h"

#import "ASLCipherText.h"
#import "ASLPlainText.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLRelinearizationKeys.h"
#import "ASLGaloisKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLEvaluator : NSObject

+ (instancetype _Nullable)evaluatorWith:(ASLSealContext *)context
								  error:(NSError **)error;

-(BOOL)negateInplace:(ASLCipherText *)encrypted
			   error:(NSError **)error;

-(BOOL)negateInplace:(ASLCipherText *)encrypted
		 destination:(ASLCipherText *)destination
			   error:(NSError **)error;

-(BOOL)addInplace:(ASLCipherText *)encrypted1
	   encrypted2:(ASLCipherText *)encrypted2
			error:(NSError **)error;

-(BOOL)add:(ASLCipherText *)encrypted1
encrypted2:(ASLCipherText *)encrypted2
	 error:(NSError **)error;

-(BOOL)addMany:(NSArray<ASLCipherText *> *)encrypteds
   destination:(ASLCipherText *)destination
		 error:(NSError **)error;

-(BOOL)subInplace:(ASLCipherText *)encrypted1
	   encrypted2:(ASLCipherText *)encrypted2
			error:(NSError **)error;

-(BOOL)sub:(ASLCipherText *)encrypted1
encrypted2:(ASLCipherText *)encrypted2
	 error:(NSError **)error;

-(BOOL)multiplyInplace:(ASLCipherText *)encrypted1
			encrypted2:(ASLCipherText *)encrypted2
				 error:(NSError **)error;

-(BOOL)multiplyInplace:(ASLCipherText *)encrypted1
			encrypted2:(ASLCipherText *)encrypted2
				  pool:(ASLMemoryPoolHandle *)pool
				 error:(NSError **)error;

-(BOOL)multiply:(ASLCipherText *)encrypted1
	 encrypted2:(ASLCipherText *)encrypted2
	destination:(ASLCipherText *)destination
		   pool:(ASLMemoryPoolHandle *)pool
		  error:(NSError **)error;

-(BOOL)multiply:(ASLCipherText *)encrypted1
	 encrypted2:(ASLCipherText *)encrypted2
	destination:(ASLCipherText *)destination
		  error:(NSError **)error;

-(BOOL)squareInplace:(ASLCipherText *)encrypted
			   error:(NSError **)error;

-(BOOL)squareInplace:(ASLCipherText *)encrypted
				pool:(ASLMemoryPoolHandle *)pool
			   error:(NSError **)error;

-(BOOL)square:(ASLCipherText *)encrypted
  destination:(ASLCipherText *)destination
		 pool:(ASLMemoryPoolHandle *)pool
		error:(NSError **)error;

-(BOOL)square:(ASLCipherText *)encrypted
  destination:(ASLCipherText *)destination
		error:(NSError **)error;

-(BOOL)relinearizeInplace:(ASLCipherText *)encrypted
	  relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
					error:(NSError **)error;

-(BOOL)relinearizeInplace:(ASLCipherText *)encrypted
	  relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
					 pool:(ASLMemoryPoolHandle *)pool
					error:(NSError **)error;

-(BOOL)relinearize:(ASLCipherText *)encrypted
relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
	   destination:(ASLCipherText *)destination
			 error:(NSError **)error;

-(BOOL)relinearize:(ASLCipherText *)encrypted
relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
	   destination:(ASLCipherText *)destination
			  pool:(ASLMemoryPoolHandle *)pool
			 error:(NSError **)error;

-(BOOL)modSwitchToNext:(ASLCipherText *)encrypted
		   destination:(ASLCipherText *)destination
				 error:(NSError **)error;

-(BOOL)modSwitchToNext:(ASLCipherText *)encrypted
		   destination:(ASLCipherText *)destination
				  pool:(ASLMemoryPoolHandle *)pool
				 error:(NSError **)error;

-(BOOL)modSwitchToNextInplace:(ASLCipherText *)encrypted
						 pool:(ASLMemoryPoolHandle *)pool
						error:(NSError **)error;

-(BOOL)modSwitchToNextInplace:(ASLCipherText *)encrypted
						error:(NSError **)error;

-(BOOL)modSwitchToNext:(ASLPlainText *)plain
				 error:(NSError **)error;

-(BOOL)modSwitchToInplace:(ASLCipherText *)encrypted
			 parametersId:(ASLParametersIdType)parametersId
					 pool:(ASLMemoryPoolHandle *)pool
					error:(NSError **)error;

-(BOOL)modSwitchToInplace:(ASLCipherText *)encrypted
			 parametersId:(ASLParametersIdType)parametersId
					error:(NSError **)error;

-(BOOL)modSwitchTo:(ASLCipherText *)encrypted
	  parametersId:(ASLParametersIdType)parametersId
	   destination:(ASLCipherText *)destination
			  pool:(ASLMemoryPoolHandle *)pool
			 error:(NSError **)error;

-(BOOL)modSwitchTo:(ASLCipherText *)encrypted
	  parametersId:(ASLParametersIdType)parametersId
	   destination:(ASLCipherText *)destination
			 error:(NSError **)error;

-(BOOL)modSwitchToInplaceWithPlain:(ASLPlainText *)plain
					  parametersId:(ASLParametersIdType)parametersId
							 error:(NSError **)error;

-(BOOL)modSwitchToWithPlain:(ASLPlainText *)plain
			   parametersId:(ASLParametersIdType)parametersId
				destination:(ASLCipherText *)destination
					  error:(NSError **)error;

-(BOOL)rescaleToNext:(ASLCipherText *)encrypted
		 destination:(ASLCipherText *)destination
				pool:(ASLMemoryPoolHandle *)pool
			   error:(NSError **)error;

-(BOOL)rescaleToNext:(ASLCipherText *)encrypted
		 destination:(ASLCipherText *)destination
			   error:(NSError **)error;

-(BOOL)rescaleToNextInplace:(ASLCipherText *)encrypted
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error;

-(BOOL)rescaleToNextInplace:(ASLCipherText *)encrypted
					  error:(NSError **)error;

-(BOOL)rescaleToInplace:(ASLCipherText *)encrypted
		   parametersId:(ASLParametersIdType)parametersId
				   pool:(ASLMemoryPoolHandle *)pool
				  error:(NSError **)error;

-(BOOL)rescaleToInplace:(ASLCipherText *)encrypted
		   parametersId:(ASLParametersIdType)parametersId
				  error:(NSError **)error;

-(BOOL)rescaleTo:(ASLCipherText *)encrypted
	parametersId:(ASLParametersIdType)parametersId
	 destination:(ASLCipherText *)destination
			pool:(ASLMemoryPoolHandle *)pool
		   error:(NSError **)error;

-(BOOL)rescaleTo:(ASLCipherText *)encrypted
	parametersId:(ASLParametersIdType)parametersId
	 destination:(ASLCipherText *)destination
		   error:(NSError **)error;

-(BOOL)multiplyMany:(NSArray<ASLCipherText*>*)encrypteds
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
		destination:(ASLCipherText *)destination
			   pool:(ASLMemoryPoolHandle *)pool
			  error:(NSError **)error;

-(BOOL)multiplyMany:(NSArray<ASLCipherText*>*)encrypteds
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
		destination:(ASLCipherText *)destination
			  error:(NSError **)error;

-(BOOL)exponentiateInplace:(ASLCipherText *)encrypted
				  exponent:(uint64_t)exponent
	   relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
					  pool:(ASLMemoryPoolHandle *)pool
					 error:(NSError **)error;

-(BOOL)exponentiateInplace:(ASLCipherText *)encrypted
				  exponent:(uint64_t)exponent
	   relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
					 error:(NSError **)error;

-(BOOL)exponentiate:(ASLCipherText *)encrypted
		   exponent:(uint64_t)exponent
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
		destination:(ASLCipherText *)destination
			   pool:(ASLMemoryPoolHandle *)pool
			  error:(NSError **)error;

-(BOOL)exponentiate:(ASLCipherText *)encrypted
		   exponent:(uint64_t)exponent
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
		destination:(ASLCipherText *)destination
			  error:(NSError **)error;

-(BOOL)addPlainInplace:(ASLCipherText *)encrypted
				 plain:(ASLPlainText *)plain
				 error:(NSError **)error;

-(BOOL)addPlain:(ASLCipherText *)encrypted
		  plain:(ASLPlainText *)plain
	destination:(ASLCipherText *)destination
		  error:(NSError **)error;

-(BOOL)subPlainInplace:(ASLCipherText *)encrypted
				 plain:(ASLPlainText *)plain
				 error:(NSError **)error;

-(BOOL)subPlain:(ASLCipherText *)encrypted
		  plain:(ASLPlainText *)plain
	destination:(ASLCipherText *)destination
		  error:(NSError **)error;

-(BOOL)multiplyPlainInplace:(ASLCipherText *)encrypted
					  plain:(ASLPlainText *)plain
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error;

-(BOOL)multiplyPlainInplace:(ASLCipherText *)encrypted
					  plain:(ASLPlainText *)plain
					  error:(NSError **)error;

-(BOOL)multiplyPlain:(ASLCipherText *)encrypted
			   plain:(ASLPlainText *)plain
		 destination:(ASLCipherText *)destination
				pool:(ASLMemoryPoolHandle *)pool
			   error:(NSError **)error;

-(BOOL)multiplyPlain:(ASLCipherText *)encrypted
			   plain:(ASLPlainText *)plain
		 destination:(ASLCipherText *)destination
			   error:(NSError **)error;

-(BOOL)transformToNttInplace:(ASLPlainText *)plain
				parametersId:(ASLParametersIdType)parametersId
						pool:(ASLMemoryPoolHandle *)pool
					   error:(NSError **)error;

-(BOOL)transformToNttInplace:(ASLPlainText *)plain
				parametersId:(ASLParametersIdType)parametersId
					   error:(NSError **)error;

-(BOOL)transformToNtt:(ASLPlainText *)plain
		 parametersId:(ASLParametersIdType)parametersId
	   destinationNtt:(ASLPlainText *)destinationNtt
				 pool:(ASLMemoryPoolHandle *)pool
				error:(NSError **)error;

-(BOOL)transformToNtt:(ASLPlainText *)plain
		 parametersId:(ASLParametersIdType)parametersId
	   destinationNtt:(ASLPlainText *)destinationNtt
				error:(NSError **)error;

-(BOOL)transformToNttInplace:(ASLCipherText *)encrypted
					   error:(NSError **)error;

-(BOOL)transformToNtt:(ASLCipherText *)encrypted
	   destinationNtt:(ASLCipherText *)destinationNtt
				error:(NSError **)error;

-(BOOL)transformFromNttInplace:(ASLCipherText *)encryptedNtt
						 error:(NSError **)error;

-(BOOL)transformFromNtt:(ASLCipherText *)encryptedNtt
			destination:(ASLCipherText *)destination
				  error:(NSError **)error;

-(BOOL)applyGaloisInplace:(ASLCipherText *)encrypted
			galoisElement:(uint64_t)galoisElement
				galoisKey:(ASLGaloisKeys *)galoisKey
					 pool:(ASLMemoryPoolHandle *)pool
					error:(NSError **)error;

-(BOOL)applyGaloisInplace:(ASLCipherText *)encrypted
			galoisElement:(uint64_t)galoisElement
				galoisKey:(ASLGaloisKeys *)galoisKey
					error:(NSError **)error;

-(BOOL)applyGalois:(ASLCipherText *)encrypted
	 galoisElement:(uint64_t)galoisElement
		 galoisKey:(ASLGaloisKeys *)galoisKey
	   destination:(ASLCipherText *)destination
			  pool:(ASLMemoryPoolHandle *)pool
			 error:(NSError **)error;

-(BOOL)applyGalois:(ASLCipherText *)encrypted
	 galoisElement:(uint64_t)galoisElement
		 galoisKey:(ASLGaloisKeys *)galoisKey
	   destination:(ASLCipherText *)destination
			 error:(NSError **)error;

-(BOOL)rotateRowsInplace:(ASLCipherText *)encrypted
				   steps:(int)steps
			   galoisKey:(ASLGaloisKeys *)galoisKey
					pool:(ASLMemoryPoolHandle *)pool
				   error:(NSError **)error;

-(BOOL)rotateRowsInplace:(ASLCipherText *)encrypted
				   steps:(int)steps
			   galoisKey:(ASLGaloisKeys *)galoisKey
				   error:(NSError **)error;

-(BOOL)rotateRows:(ASLCipherText *)encrypted
			steps:(int)steps
		galoisKey:(ASLGaloisKeys *)galoisKey
	  destination:(ASLCipherText *)destination
			 pool:(ASLMemoryPoolHandle *)pool
			error:(NSError **)error;

-(BOOL)rotateRows:(ASLCipherText *)encrypted
			steps:(int)steps
		galoisKey:(ASLGaloisKeys *)galoisKey
	  destination:(ASLCipherText *)destination
			error:(NSError **)error;

-(BOOL)rotateColumnsInplace:(ASLCipherText *)encrypted
				  galoisKey:(ASLGaloisKeys *)galoisKey
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error;

-(BOOL)rotateColumnsInplace:(ASLCipherText *)encrypted
				  galoisKey:(ASLGaloisKeys *)galoisKey
					  error:(NSError **)error;

-(BOOL)rotateColumns:(ASLCipherText *)encrypted
		   galoisKey:(ASLGaloisKeys *)galoisKey
		 destination:(ASLCipherText *)destination
				pool:(ASLMemoryPoolHandle *)pool
			   error:(NSError **)error;

-(BOOL)rotateColumns:(ASLCipherText *)encrypted
		   galoisKey:(ASLGaloisKeys *)galoisKey
		 destination:(ASLCipherText *)destination
			   error:(NSError **)error;

-(BOOL)rotateVectorInplace:(ASLCipherText *)encrypted
					 steps:(int)steps
				 galoisKey:(ASLGaloisKeys *)galoisKey
					  pool:(ASLMemoryPoolHandle *)pool
					 error:(NSError **)error;

-(BOOL)rotateVectorInplace:(ASLCipherText *)encrypted
					 steps:(int)steps
				 galoisKey:(ASLGaloisKeys *)galoisKey
					 error:(NSError **)error;

-(BOOL)rotateVector:(ASLCipherText *)encrypted
			  steps:(int)steps
		  galoisKey:(ASLGaloisKeys *)galoisKey
		destination:(ASLCipherText *)destination
			   pool:(ASLMemoryPoolHandle *)pool
			  error:(NSError **)error;

-(BOOL)rotateVector:(ASLCipherText *)encrypted
			  steps:(int)steps
		  galoisKey:(ASLGaloisKeys *)galoisKey
		destination:(ASLCipherText *)destination
			  error:(NSError **)error;

-(BOOL)complexConjugateInplace:(ASLCipherText *)encrypted
					 galoisKey:(ASLGaloisKeys *)galoisKey
						  pool:(ASLMemoryPoolHandle *)pool
						 error:(NSError **)error;

-(BOOL)complexConjugateInplace:(ASLCipherText *)encrypted
					 galoisKey:(ASLGaloisKeys *)galoisKey
						 error:(NSError **)error;

-(BOOL)complexConjugate:(ASLCipherText *)encrypted
			  galoisKey:(ASLGaloisKeys *)galoisKey
			destination:(ASLCipherText *)destination
				   pool:(ASLMemoryPoolHandle *)pool
				  error:(NSError **)error;

-(BOOL)complexConjugate:(ASLCipherText *)encrypted
			  galoisKey:(ASLGaloisKeys *)galoisKey
			destination:(ASLCipherText *)destination
				  error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
