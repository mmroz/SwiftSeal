# Swift Seal

An Objective-C++ wrapper around  [Microsoft Seal](https://github.com/microsoft/SEAL) with ergonomic Swift bindings. The framework prodvides out of the box Swift functionality to perofm homorphic encrytions and perform arithmetic operations on encoded data. It is written as a swift package and currently supported on iOS.

# Table of Contents
* [Requirements](#requirements)
* [Getting Started](#getting-started)
    * [Installation](#installation)
    * [Examples](#asl-examples)
* [Components](#components)
   * [ASLSchemeType](#asl-schemeType)
   * [ASLEncryptionParameters](#asl-encryption-parameters)
   * [ASLSealContext](#asl-seal-context")
   * [ASLKeyGenerator](#asl-key-generator)
   * [ASLPlainText](#asl-plain-text)
   * [ASLCipherText](#asl-cipher-text)
   * [ASLBatchEncoder](#asl-batchEncoder)
   * [ASLCKKSEncoder](#asl-ckksEncoder)
   * [ASLIntegerEncoder](#asl-integerEncoder)
   * [ASLEncryptor](#asl-encryptor)
   * [ASLEvaluator](#asl-evaluator)
   * [ASLDecryptor](#asl-decryptor)
* [Learn More](#learn-more)
* [Getting Help](#getting-help)


# Requirements <a name="requirements"></a>

The framework has no minimum version.

# Getting Started <a name="getting-started"></a>

* [Microsoft Seal](https://github.com/microsoft/SEAL) 

### Installation <a name="installation"></a>

Checkout the Microsoft Seal libaray on the `contrib` branch

```
git clone -b contrib https://github.com/microsoft/SEAL.git
cd SEAL
make .
cmake . -DSEAL_USE_ZLIB=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Debug
```
This will build SEAL without ZLIB and in Debug mode and generate PKGConfig file.

Then install AppleSeal via SPM. Create a new Xcode project and navigate to `File > Swift Packages > Add Package Dependency`. Enter the url `https://github.com/mmroz/AppleSeal.git` and tap `Next` and choose the master branch.

### Examples <a name="asl-examples"></a>

AppleSeal has a number of examples that are used to show basic usage of Swift Seal. The [Examples in AppleSeal](https://github.com/mmroz/SwiftSeal/tree/master/Tests/AppleSealTests/Examples). These are meant to replicate the [Examples in SEAL](https://github.com/microsoft/SEAL/tree/master/native/examples)

# Components <a name="components"></a>

### ASLSchemeType  <a name="asl-schemeType"></a>
Supports BFV and CKKS encoding types through ASLSchemeTypeBFV and  ASLSchemeTypeCKKS, respectively.

### ASLEncryptionParameters  <a name="asl-encryption-parameters"></a>

The parameters used for the encryption most importantly polynomialModulus, coefficientModulus and plainModulus.

### ASLSealContext  <a name="asl-seal-context"></a>

A heavyweight class constructed from the ASLEncryptionParameters.

### ASLKeyGenerator  <a name="asl-key-generator"></a>

Generates matching secret key and public key also used to construct Galois Keys and Relinearization Keys.

### ASLPlainText  <a name="asl-plain-text"></a>

Class to store a plaintext element.

### ASLCipherText  <a name="asl-cipher-text"></a>

Class to store a ciphertext element.

### ASLBatchEncoder <a name="asl-batchEncoder"></a>

Provides functionality for CRT batching

### ASLCKKSEncoder <a name="asl-ckksEncoder"></a>

Provides functionality for encoding vectors of complex or real numbers into
plaintext polynomials to be encrypted and computed on using the CKKS scheme.

### ASLIntegerEncoder <a name="asl-integerEncoder"></a>

Encodes integers into plaintext polynomials that Encryptor can encrypt

### ASLEncryptor  <a name="asl-encryptor"></a>

Encrypts Plaintext objects into Ciphertext objects.

### ASLEvaluator  <a name="asl-evaluator"></a>

Provides operations on ciphertexts.

### ASLDecryptor  <a name="asl-decryptor"></a>

Decrypts Ciphertext objects into Plaintext objects

# Learn More <a name="learn-more"></a>

Learn more about Homomorphic Encrytion and [Seal](https://www.microsoft.com/en-us/research/project/microsoft-seal/)

# Getting Help <a name="getting-help"></a>

Feel free to open up issues about questions, problems, or ideas. Always looking for more contributions!
