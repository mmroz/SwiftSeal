//
//  ASLEvaluatorTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-24.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLEvaluatorTests: XCTestCase {
    func testCreateWithWithContext() throws {
        XCTAssertNoThrow(try ASLEvaluator(createValidContext()))
    }
    
    // TODO - test this
    
//    func testNegate() throws {
//        let params = ASLEncryptionParameters(schemeType: .BFV)
//        try params.setPolynomialModulusDegree(64)
//        try params.setCoefficientModulus(ASLCoefficientModulus.create(64, bitSizes: [40]))
//        try params.setPlainModulusWithInteger(1 << 6)
//        let context = try ASLSealContext(encrytionParameters: params, expandModChain: false, securityLevel: .None)
//        let keyGen = try ASLKeyGenerator(context: context)
//
//        let encryptor = try ASLEncryptor(context: context, publicKey: keyGen.publicKey)
//        let decryptor = try ASLDecryptor(context: context, secretKey: keyGen.secretKey)
//        let evaluator = try ASLEvaluator(context)
//
//        let encrypted = ASLCipherText();
//        let encDestination = ASLCipherText();
//        let plain = try ASLPlainText(polynomialString: "3x^2 + 2x^1 + 1")
//        let plainDest = ASLPlainText()
//        try encryptor.encrypt(with: plain, cipherText: encrypted)
//        try encryptor.encrypt(with: plain, cipherText: encrypted)
//        try evaluator.negateInplace(encDestination)
//        try decryptor.decrypt(encDestination, destination: plainDest)
//
//        XCTAssertEqual(<#T##expression1: Equatable##Equatable#>, <#T##expression2: Equatable##Equatable#>)
//
//    }
//
//
//    func testNegate() throws {
//
//
//
//        // coefficients are negated (modulo 64)
//        Assert.AreEqual(0x3Ful, plaindest[0]);
//        Assert.AreEqual(0x3Eul, plaindest[1]);
//        Assert.AreEqual(0x3Dul, plaindest[2]);
//
//        plain = new Plaintext("6x^3 + 7x^2 + 8x^1 + 9");
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.NegateInplace(encrypted);
//        decryptor.Decrypt(encrypted, plain);
//
//        // coefficients are negated (modulo 64)
//        Assert.AreEqual(0x37ul, plain[0]);
//        Assert.AreEqual(0x38ul, plain[1]);
//        Assert.AreEqual(0x39ul, plain[2]);
//        Assert.AreEqual(0x3Aul, plain[3]);
//    }
//
//    [TestMethod]
//    public void AddTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 64,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(64, new int[] { 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted1 = new Ciphertext();
//        Ciphertext encrypted2 = new Ciphertext();
//        Ciphertext encdestination = new Ciphertext();
//
//        Plaintext plain1 = new Plaintext("5x^4 + 4x^3 + 3x^2 + 2x^1 + 1");
//        Plaintext plain2 = new Plaintext("4x^7 + 5x^6 + 6x^5 + 7x^4 + 8x^3 + 9x^2 + Ax^1 + B");
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(plain1, encrypted1);
//        encryptor.Encrypt(plain2, encrypted2);
//        evaluator.Add(encrypted1, encrypted2, encdestination);
//        decryptor.Decrypt(encdestination, plaindest);
//
//        Assert.AreEqual(12ul, plaindest[0]);
//        Assert.AreEqual(12ul, plaindest[1]);
//        Assert.AreEqual(12ul, plaindest[2]);
//        Assert.AreEqual(12ul, plaindest[3]);
//        Assert.AreEqual(12ul, plaindest[4]);
//        Assert.AreEqual(6ul, plaindest[5]);
//        Assert.AreEqual(5ul, plaindest[6]);
//        Assert.AreEqual(4ul, plaindest[7]);
//
//        plain1 = new Plaintext("1x^2 + 2x^1 + 3");
//        plain2 = new Plaintext("2x^3 + 2x^2 + 2x^1 + 2");
//
//        encryptor.Encrypt(plain1, encrypted1);
//        encryptor.Encrypt(plain2, encrypted2);
//        evaluator.AddInplace(encrypted1, encrypted2);
//        decryptor.Decrypt(encrypted1, plaindest);
//
//        Assert.AreEqual(5ul, plaindest[0]);
//        Assert.AreEqual(4ul, plaindest[1]);
//        Assert.AreEqual(3ul, plaindest[2]);
//        Assert.AreEqual(2ul, plaindest[3]);
//    }
//
//    [TestMethod]
//    public void AddPlainTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 64,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(64, new int[] { 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plain = new Plaintext("3x^2 + 2x^1 + 1");
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(new Plaintext("2x^2 + 2x^1 + 2"), encrypted);
//        evaluator.AddPlain(encrypted, plain, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        Assert.AreEqual(3ul, plaindest[0]);
//        Assert.AreEqual(4ul, plaindest[1]);
//        Assert.AreEqual(5ul, plaindest[2]);
//
//        plain.Set("1x^2 + 1x^1 + 1");
//        encryptor.Encrypt(new Plaintext("2x^3 + 2x^2 + 2x^1 + 2"), encrypted);
//        evaluator.AddPlainInplace(encrypted, plain);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        Assert.AreEqual(4ul, plaindest.CoeffCount);
//        Assert.AreEqual(3ul, plaindest[0]);
//        Assert.AreEqual(3ul, plaindest[1]);
//        Assert.AreEqual(3ul, plaindest[2]);
//        Assert.AreEqual(2ul, plaindest[3]);
//    }
//
//    [TestMethod]
//    public void AddManyTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 64,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(64, new int[] { 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext[] encrypteds = new Ciphertext[6];
//
//        for(int i = 0; i < encrypteds.Length; i++)
//        {
//            encrypteds[i] = new Ciphertext();
//            encryptor.Encrypt(new Plaintext((i + 1).ToString()), encrypteds[i]);
//        }
//
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plaindest = new Plaintext();
//        evaluator.AddMany(encrypteds, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        // 1+2+3+4+5+6
//        Assert.AreEqual(21ul, plaindest[0]);
//    }
//
//    [TestMethod]
//    public void SubTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 64,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(64, new int[] { 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted1 = new Ciphertext();
//        Ciphertext encrypted2 = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plain1 = new Plaintext("Ax^2 + Bx^1 + C");
//        Plaintext plain2 = new Plaintext("5x^3 + 5x^2 + 5x^1 + 5");
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(plain1, encrypted1);
//        encryptor.Encrypt(plain2, encrypted2);
//        evaluator.Sub(encrypted1, encrypted2, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        Assert.AreEqual(7ul, plaindest[0]);
//        Assert.AreEqual(6ul, plaindest[1]);
//        Assert.AreEqual(5ul, plaindest[2]);
//        Assert.AreEqual(0x3Bul, plaindest[3]);
//
//        plain1.Set("Ax^3 + Bx^2 + Cx^1 + D");
//        plain2.Set("5x^2 + 5x^1 + 5");
//
//        encryptor.Encrypt(plain1, encrypted1);
//        encryptor.Encrypt(plain2, encrypted2);
//        evaluator.SubInplace(encrypted1, encrypted2);
//        decryptor.Decrypt(encrypted1, plaindest);
//
//        Assert.AreEqual(8ul, plaindest[0]);
//        Assert.AreEqual(7ul, plaindest[1]);
//        Assert.AreEqual(6ul, plaindest[2]);
//        Assert.AreEqual(10ul, plaindest[3]);
//    }
//
//    [TestMethod]
//    public void SubPlainTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 64,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(64, new int[] { 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plain = new Plaintext("5x^2 + 4x^1 + 3");
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(new Plaintext("3x^1 + 4"), encrypted);
//        evaluator.SubPlain(encrypted, plain, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        Assert.AreEqual(3ul, plaindest.CoeffCount);
//        Assert.AreEqual(1ul, plaindest[0]);
//        Assert.AreEqual(0x3Ful, plaindest[1]); // -1
//        Assert.AreEqual(0x3Bul, plaindest[2]); // -5
//
//        plain.Set("6x^3 + 1x^2 + 7x^1 + 2");
//        encryptor.Encrypt(new Plaintext("Ax^2 + Bx^1 + C"), encrypted);
//        evaluator.SubPlainInplace(encrypted, plain);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        Assert.AreEqual(4ul, plaindest.CoeffCount);
//        Assert.AreEqual(10ul, plaindest[0]);
//        Assert.AreEqual(4ul, plaindest[1]);
//        Assert.AreEqual(9ul, plaindest[2]);
//        Assert.AreEqual(0x3Aul, plaindest[3]); // -6
//    }
//
//    [TestMethod]
//    public void MultiplyTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 64,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(64, new int[] { 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted1 = new Ciphertext();
//        Ciphertext encrypted2 = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(new Plaintext("1x^4 + 2x^3 + 3x^2 + 4x^1 + 5"), encrypted1);
//        encryptor.Encrypt(new Plaintext("3x^2 + 2x^1 + 1"), encrypted2);
//        evaluator.Multiply(encrypted1, encrypted2, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        // {3x^6 + 8x^5 + Ex^4 + 14x^3 + 1Ax^2 + Ex^1 + 5}
//        Assert.AreEqual(7ul, plaindest.CoeffCount);
//        Assert.AreEqual(5ul, plaindest[0]);
//        Assert.AreEqual(14ul, plaindest[1]);
//        Assert.AreEqual(26ul, plaindest[2]);
//        Assert.AreEqual(20ul, plaindest[3]);
//        Assert.AreEqual(14ul, plaindest[4]);
//        Assert.AreEqual(8ul, plaindest[5]);
//        Assert.AreEqual(3ul, plaindest[6]);
//
//        encryptor.Encrypt(new Plaintext("2x^2 + 3x^1 + 4"), encrypted1);
//        encryptor.Encrypt(new Plaintext("4x^1 + 5"), encrypted2);
//        evaluator.MultiplyInplace(encrypted1, encrypted2);
//        decryptor.Decrypt(encrypted1, plaindest);
//
//        // {8x^3 + 16x^2 + 1Fx^1 + 14}
//        Assert.AreEqual(4ul, plaindest.CoeffCount);
//        Assert.AreEqual(20ul, plaindest[0]);
//        Assert.AreEqual(31ul, plaindest[1]);
//        Assert.AreEqual(22ul, plaindest[2]);
//        Assert.AreEqual(8ul, plaindest[3]);
//    }
//
//    [TestMethod]
//    public void MultiplyManyTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 40, 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//        RelinKeys relinKeys = keygen.RelinKeys();
//
//        Ciphertext[] encrypteds = new Ciphertext[4];
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plaindest = new Plaintext();
//
//        for (int i = 0; i < encrypteds.Length; i++)
//        {
//            encrypteds[i] = new Ciphertext();
//            encryptor.Encrypt(new Plaintext((i + 1).ToString()), encrypteds[i]);
//        }
//
//        evaluator.MultiplyMany(encrypteds, relinKeys, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        Assert.AreEqual(1ul, plaindest.CoeffCount);
//        Assert.AreEqual(24ul, plaindest[0]);
//
//        Utilities.AssertThrows<ArgumentException>(() =>
//        {
//            // Uninitialized memory pool handle
//            MemoryPoolHandle pool = new MemoryPoolHandle();
//            evaluator.MultiplyMany(encrypteds, relinKeys, encdest, pool);
//        });
//    }
//
//    [TestMethod]
//    public void MultiplyPlainTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//        RelinKeys relinKeys = keygen.RelinKeys();
//
//        Ciphertext encrypted = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plain = new Plaintext("2x^2 + 1");
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(new Plaintext("3x^2 + 2"), encrypted);
//        evaluator.MultiplyPlain(encrypted, plain, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        // {6x^4 + 7x^2 + 2}
//        Assert.AreEqual(5ul, plaindest.CoeffCount);
//        Assert.AreEqual(2ul, plaindest[0]);
//        Assert.AreEqual(0ul, plaindest[1]);
//        Assert.AreEqual(7ul, plaindest[2]);
//        Assert.AreEqual(0ul, plaindest[3]);
//        Assert.AreEqual(6ul, plaindest[4]);
//
//        encryptor.Encrypt(new Plaintext("4x^1 + 3"), encrypted);
//        plain.Set("2x^2 + 1");
//        evaluator.MultiplyPlainInplace(encrypted, plain);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        // {8x^3 + 6x^2 + 4x^1 + 3}
//        Assert.AreEqual(4ul, plaindest.CoeffCount);
//        Assert.AreEqual(3ul, plaindest[0]);
//        Assert.AreEqual(4ul, plaindest[1]);
//        Assert.AreEqual(6ul, plaindest[2]);
//        Assert.AreEqual(8ul, plaindest[3]);
//
//        encryptor.Encrypt(new Plaintext("4x^1 + 3"), encrypted);
//        plain.Set("3x^5");
//        evaluator.MultiplyPlainInplace(encrypted, plain);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        // {Cx^6 + 9x^5}
//        Assert.AreEqual(7ul, plaindest.CoeffCount);
//        Assert.AreEqual(2ul, plaindest.NonZeroCoeffCount);
//        Assert.AreEqual(0ul, plaindest[0]);
//        Assert.AreEqual(0ul, plaindest[1]);
//        Assert.AreEqual(0ul, plaindest[2]);
//        Assert.AreEqual(0ul, plaindest[3]);
//        Assert.AreEqual(0ul, plaindest[4]);
//        Assert.AreEqual(9ul, plaindest[5]);
//        Assert.AreEqual(12ul, plaindest[6]);
//
//        Utilities.AssertThrows<ArgumentException>(() =>
//        {
//            // Uninitialized pool
//            MemoryPoolHandle pool = new MemoryPoolHandle();
//            evaluator.MultiplyPlain(encrypted, plain, encdest, pool);
//        });
//    }
//
//    [TestMethod]
//    public void SquareTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plain = new Plaintext("2x^2 + 3x^1 + 4");
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.Square(encrypted, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        // {4x^4 + Cx^3 + 19x^2 + 18x^1 + 10}
//        Assert.AreEqual(5ul, plaindest.CoeffCount);
//        Assert.AreEqual(16ul, plaindest[0]);
//        Assert.AreEqual(24ul, plaindest[1]);
//        Assert.AreEqual(25ul, plaindest[2]);
//        Assert.AreEqual(12ul, plaindest[3]);
//        Assert.AreEqual(4ul, plaindest[4]);
//
//        encryptor.Encrypt(new Plaintext("3x^1 + 2"), encrypted);
//        evaluator.SquareInplace(encrypted);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        // {9x^2 + Cx^1 + 4}
//        Assert.AreEqual(3ul, plaindest.CoeffCount);
//        Assert.AreEqual(4ul, plaindest[0]);
//        Assert.AreEqual(12ul, plaindest[1]);
//        Assert.AreEqual(9ul, plaindest[2]);
//    }
//
//    [TestMethod]
//    public void ExponentiateTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 40, 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//        RelinKeys relinKeys = keygen.RelinKeys();
//
//        Ciphertext encrypted = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plain = new Plaintext();
//
//        encryptor.Encrypt(new Plaintext("2x^2 + 1"), encrypted);
//        evaluator.Exponentiate(encrypted, 3, relinKeys, encdest);
//        decryptor.Decrypt(encdest, plain);
//
//        // {8x^6 + Cx^4 + 6x^2 + 1}
//        Assert.AreEqual(7ul, plain.CoeffCount);
//        Assert.AreEqual(1ul, plain[0]);
//        Assert.AreEqual(0ul, plain[1]);
//        Assert.AreEqual(6ul, plain[2]);
//        Assert.AreEqual(0ul, plain[3]);
//        Assert.AreEqual(12ul, plain[4]);
//        Assert.AreEqual(0ul, plain[5]);
//        Assert.AreEqual(8ul, plain[6]);
//
//        encryptor.Encrypt(new Plaintext("3x^3 + 2"), encrypted);
//        evaluator.ExponentiateInplace(encrypted, 4, relinKeys);
//        decryptor.Decrypt(encrypted, plain);
//
//        // {11x^12 + 18x^9 + 18x^6 + 20x^3 + 10}
//        Assert.AreEqual(13ul, plain.CoeffCount);
//        Assert.AreEqual(16ul, plain[0]);
//        Assert.AreEqual(0ul, plain[1]);
//        Assert.AreEqual(0ul, plain[2]);
//        Assert.AreEqual(32ul, plain[3]);
//        Assert.AreEqual(0ul, plain[4]);
//        Assert.AreEqual(0ul, plain[5]);
//        Assert.AreEqual(24ul, plain[6]);
//        Assert.AreEqual(0ul, plain[7]);
//        Assert.AreEqual(0ul, plain[8]);
//        Assert.AreEqual(24ul, plain[9]);
//        Assert.AreEqual(0ul, plain[10]);
//        Assert.AreEqual(0ul, plain[11]);
//        Assert.AreEqual(17ul, plain[12]);
//    }
//
//    [TestMethod]
//    public void ApplyGaloisTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 8,
//            PlainModulus = new SmallModulus(257),
//            CoeffModulus = CoeffModulus.Create(8, new int[] { 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//        GaloisKeys galoisKeys = keygen.GaloisKeys(galoisElts: new ulong[] { 1ul, 3ul, 5ul, 15ul });
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Plaintext plain = new Plaintext("1");
//        Plaintext plaindest = new Plaintext();
//        Ciphertext encrypted = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.ApplyGalois(encrypted, galoisElt: 1, galoisKeys: galoisKeys, destination: encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        Assert.AreEqual(1ul, plaindest.CoeffCount);
//        Assert.AreEqual(1ul, plaindest[0]);
//
//        plain.Set("1x^1");
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.ApplyGalois(encrypted, galoisElt: 1, galoisKeys: galoisKeys, destination: encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        // {1x^1}
//        Assert.AreEqual(2ul, plaindest.CoeffCount);
//        Assert.AreEqual(0ul, plaindest[0]);
//        Assert.AreEqual(1ul, plaindest[1]);
//
//        evaluator.ApplyGalois(encdest, galoisElt: 3, galoisKeys: galoisKeys, destination: encrypted);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        // {1x^3}
//        Assert.AreEqual(4ul, plaindest.CoeffCount);
//        Assert.AreEqual(0ul, plaindest[0]);
//        Assert.AreEqual(0ul, plaindest[1]);
//        Assert.AreEqual(0ul, plaindest[2]);
//        Assert.AreEqual(1ul, plaindest[3]);
//
//        evaluator.ApplyGalois(encrypted, galoisElt: 5, galoisKeys: galoisKeys, destination: encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        // {100x^7}
//        Assert.AreEqual(8ul, plaindest.CoeffCount);
//        Assert.AreEqual(0ul, plaindest[0]);
//        Assert.AreEqual(0ul, plaindest[1]);
//        Assert.AreEqual(0ul, plaindest[2]);
//        Assert.AreEqual(0ul, plaindest[3]);
//        Assert.AreEqual(0ul, plaindest[4]);
//        Assert.AreEqual(0ul, plaindest[5]);
//        Assert.AreEqual(0ul, plaindest[6]);
//        Assert.AreEqual(256ul, plaindest[7]);
//
//        plain.Set("1x^2");
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.ApplyGaloisInplace(encrypted, 1, galoisKeys);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        // {1x^2}
//        Assert.AreEqual(3ul, plaindest.CoeffCount);
//        Assert.AreEqual(0ul, plaindest[0]);
//        Assert.AreEqual(0ul, plaindest[1]);
//        Assert.AreEqual(1ul, plaindest[2]);
//
//        evaluator.ApplyGaloisInplace(encrypted, 3, galoisKeys);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        // {1x^6}
//        Assert.AreEqual(7ul, plaindest.CoeffCount);
//        Assert.AreEqual(0ul, plaindest[0]);
//        Assert.AreEqual(0ul, plaindest[1]);
//        Assert.AreEqual(0ul, plaindest[2]);
//        Assert.AreEqual(0ul, plaindest[3]);
//        Assert.AreEqual(0ul, plaindest[4]);
//        Assert.AreEqual(0ul, plaindest[5]);
//        Assert.AreEqual(1ul, plaindest[6]);
//
//        evaluator.ApplyGaloisInplace(encrypted, 5, galoisKeys);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        // {100x^6}
//        Assert.AreEqual(7ul, plaindest.CoeffCount);
//        Assert.AreEqual(0ul, plaindest[0]);
//        Assert.AreEqual(0ul, plaindest[1]);
//        Assert.AreEqual(0ul, plaindest[2]);
//        Assert.AreEqual(0ul, plaindest[3]);
//        Assert.AreEqual(0ul, plaindest[4]);
//        Assert.AreEqual(0ul, plaindest[5]);
//        Assert.AreEqual(256ul, plaindest[6]);
//    }
//
//    [TestMethod]
//    public void TransformPlainToNTTTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 40, 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        Evaluator evaluator = new Evaluator(context);
//
//        Plaintext plain = new Plaintext("0");
//        Plaintext plaindest = new Plaintext();
//        Assert.IsFalse(plain.IsNTTForm);
//
//        evaluator.TransformToNTT(plain, context.FirstParmsId, plaindest);
//        Assert.IsTrue(plaindest.IsZero);
//        Assert.IsTrue(plaindest.IsNTTForm);
//        Assert.IsTrue(plaindest.ParmsId == context.FirstParmsId);
//
//        plain = new Plaintext("1");
//        Assert.IsFalse(plain.IsNTTForm);
//
//        evaluator.TransformToNTTInplace(plain, context.FirstParmsId);
//        Assert.IsTrue(plain.IsNTTForm);
//
//        for (ulong i = 0; i < 256; i++)
//        {
//            Assert.AreEqual(1ul, plain[i]);
//        }
//    }
//
//    [TestMethod]
//    public void TransformEncryptedToNTTTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Ciphertext encdest2 = new Ciphertext();
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(new Plaintext("0"), encrypted);
//        Assert.IsFalse(encrypted.IsNTTForm);
//
//        evaluator.TransformToNTT(encrypted, encdest);
//        Assert.IsTrue(encdest.IsNTTForm);
//
//        evaluator.TransformFromNTT(encdest, encdest2);
//        Assert.IsFalse(encdest2.IsNTTForm);
//
//        decryptor.Decrypt(encdest2, plaindest);
//        Assert.AreEqual(1ul, plaindest.CoeffCount);
//        Assert.AreEqual(0ul, plaindest[0]);
//        Assert.AreEqual(context.FirstParmsId, encdest2.ParmsId);
//
//        encryptor.Encrypt(new Plaintext("1"), encrypted);
//        Assert.IsFalse(encrypted.IsNTTForm);
//
//        evaluator.TransformToNTTInplace(encrypted);
//        Assert.IsTrue(encrypted.IsNTTForm);
//
//        evaluator.TransformFromNTTInplace(encrypted);
//        Assert.IsFalse(encrypted.IsNTTForm);
//
//        decryptor.Decrypt(encrypted, plaindest);
//
//        Assert.AreEqual(1ul, plaindest.CoeffCount);
//        Assert.AreEqual(1ul, plaindest[0]);
//        Assert.AreEqual(context.FirstParmsId, encrypted.ParmsId);
//    }
//
//    [TestMethod]
//    public void ModSwitchToNextTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 30, 30, 30 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: true,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted = new Ciphertext(context);
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plain = new Plaintext();
//
//        plain.Set("0");
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.ModSwitchToNext(encrypted, encdest);
//        decryptor.Decrypt(encdest, plain);
//
//        Assert.AreEqual(1ul, plain.CoeffCount);
//        Assert.AreEqual(0ul, plain[0]);
//
//        plain.Set("1");
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.ModSwitchToNextInplace(encrypted);
//        decryptor.Decrypt(encrypted, plain);
//
//        Assert.AreEqual(1ul, plain.CoeffCount);
//        Assert.AreEqual(1ul, plain[0]);
//    }
//
//    [TestMethod]
//    public void ModSwitchToTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 30, 30, 30, 30 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: true,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted = new Ciphertext(context);
//        Ciphertext encdest = new Ciphertext(context);
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(new Plaintext("1"), encrypted);
//        ParmsId destParmsId = context.FirstContextData.NextContextData
//            .NextContextData.ParmsId;
//
//        evaluator.ModSwitchTo(encrypted, context.FirstParmsId, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        Assert.IsTrue(encrypted.ParmsId == context.FirstParmsId);
//        Assert.IsTrue(encdest.ParmsId == context.FirstParmsId);
//        Assert.AreEqual(1ul, plaindest.CoeffCount);
//        Assert.AreEqual(1ul, plaindest[0]);
//
//        evaluator.ModSwitchTo(encrypted, destParmsId, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//
//        Assert.IsTrue(encrypted.ParmsId == context.FirstParmsId);
//        Assert.IsTrue(encdest.ParmsId == destParmsId);
//        Assert.AreEqual(1ul, plaindest.CoeffCount);
//        Assert.AreEqual(1ul, plaindest[0]);
//
//        encryptor.Encrypt(new Plaintext("3x^2 + 2x^1 + 1"), encrypted);
//        evaluator.ModSwitchToInplace(encrypted, context.FirstParmsId);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        Assert.IsTrue(encrypted.ParmsId == context.FirstParmsId);
//        Assert.AreEqual(3ul, plaindest.CoeffCount);
//        Assert.AreEqual(1ul, plaindest[0]);
//        Assert.AreEqual(2ul, plaindest[1]);
//        Assert.AreEqual(3ul, plaindest[2]);
//
//        evaluator.ModSwitchToInplace(encrypted, destParmsId);
//        decryptor.Decrypt(encrypted, plaindest);
//
//        Assert.IsTrue(encrypted.ParmsId == destParmsId);
//        Assert.AreEqual(3ul, plaindest.CoeffCount);
//        Assert.AreEqual(1ul, plaindest[0]);
//        Assert.AreEqual(2ul, plaindest[1]);
//        Assert.AreEqual(3ul, plaindest[2]);
//    }
//
//    [TestMethod]
//    public void ModSwitchToPlainTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.CKKS)
//        {
//            PolyModulusDegree = 1024,
//            CoeffModulus = CoeffModulus.Create(1024, new int[] { 40, 40, 40, 40, 40 })
//        };
//
//        SEALContext context = new SEALContext(parms,
//            expandModChain: true,
//            secLevel: SecLevelType.None);
//        CKKSEncoder encoder = new CKKSEncoder(context);
//        KeyGenerator keygen = new KeyGenerator(context);
//        SecretKey secretKey = keygen.SecretKey;
//        PublicKey publicKey = keygen.PublicKey;
//        RelinKeys relinKeys = keygen.RelinKeys();
//
//        Encryptor encryptor = new Encryptor(context, publicKey);
//        Evaluator evaluator = new Evaluator(context);
//        Decryptor decryptor = new Decryptor(context, secretKey);
//
//        double scale = parms.CoeffModulus.Last().Value;
//        Plaintext coeff1 = new Plaintext();
//        Plaintext coeff2 = new Plaintext();
//        Plaintext coeff3 = new Plaintext();
//        encoder.Encode(2.0, scale, coeff1);
//        encoder.Encode(3.0, scale, coeff2);
//        encoder.Encode(1.0, scale, coeff3);
//
//        Ciphertext encX1 = new Ciphertext();
//        Ciphertext encX2 = new Ciphertext();
//        Ciphertext encX3 = new Ciphertext();
//        encryptor.Encrypt(coeff1, encX1);
//        evaluator.Square(encX1, encX3);
//        evaluator.MultiplyPlain(encX1, coeff2, encX2);
//        evaluator.RelinearizeInplace(encX3, relinKeys);
//        evaluator.RescaleToNextInplace(encX3);
//        evaluator.RelinearizeInplace(encX2, relinKeys);
//        evaluator.RescaleToInplace(encX2, encX3.ParmsId);
//
//        evaluator.ModSwitchToInplace(coeff3, encX3.ParmsId);
//        evaluator.ModSwitchToNextInplace(coeff2);
//
//        evaluator.MultiplyPlainInplace(encX3, coeff3);
//
//        Plaintext result = new Plaintext();
//        decryptor.Decrypt(encX3, result);
//        Assert.IsNotNull(result);
//
//        List<double> destination = new List<double>();
//        encoder.Decode(result, destination);
//
//        Assert.IsNotNull(destination);
//        foreach(double val in destination)
//        {
//            Assert.AreEqual(4.0, val, delta: 0.001);
//        }
//
//        encoder.Decode(coeff2, destination);
//
//        foreach(double val in destination)
//        {
//            Assert.AreEqual(3.0, val, delta: 0.001);
//        }
//
//        decryptor.Decrypt(encX2, result);
//        encoder.Decode(result, destination);
//
//        foreach (double val in destination)
//        {
//            Assert.AreEqual(6.0, val, delta: 0.001);
//        }
//    }
//
//    [TestMethod]
//    public void RotateMatrixTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 8,
//            PlainModulus = new SmallModulus(257),
//            CoeffModulus = CoeffModulus.Create(8, new int[] { 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//        GaloisKeys galoisKeys = keygen.GaloisKeys();
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//        BatchEncoder encoder = new BatchEncoder(context);
//
//        Plaintext plain = new Plaintext();
//        List<ulong> vec = new List<ulong>
//        {
//            1, 2, 3, 4,
//            5, 6, 7, 8
//        };
//
//        encoder.Encode(vec, plain);
//
//        Ciphertext encrypted = new Ciphertext();
//        Ciphertext encdest = new Ciphertext();
//        Plaintext plaindest = new Plaintext();
//
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.RotateColumns(encrypted, galoisKeys, encdest);
//        decryptor.Decrypt(encdest, plaindest);
//        encoder.Decode(plaindest, vec);
//
//        Assert.IsTrue(AreCollectionsEqual(vec, new List<ulong>
//        {
//            5, 6, 7, 8,
//            1, 2, 3, 4
//        }));
//
//        evaluator.RotateRows(encdest, -1, galoisKeys, encrypted);
//        decryptor.Decrypt(encrypted, plaindest);
//        encoder.Decode(plaindest, vec);
//
//        Assert.IsTrue(AreCollectionsEqual(vec, new List<ulong>
//        {
//            8, 5, 6, 7,
//            4, 1, 2, 3
//        }));
//
//        evaluator.RotateRowsInplace(encrypted, 2, galoisKeys);
//        decryptor.Decrypt(encrypted, plaindest);
//        encoder.Decode(plaindest, vec);
//
//        Assert.IsTrue(AreCollectionsEqual(vec, new List<ulong>
//        {
//            6, 7, 8, 5,
//            2, 3, 4, 1
//        }));
//
//        evaluator.RotateColumnsInplace(encrypted, galoisKeys);
//        decryptor.Decrypt(encrypted, plaindest);
//        encoder.Decode(plaindest, vec);
//
//        Assert.IsTrue(AreCollectionsEqual(vec, new List<ulong>
//        {
//            2, 3, 4, 1,
//            6, 7, 8, 5
//        }));
//    }
//
//    [TestMethod]
//    public void RelinearizeTest()
//    {
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.BFV)
//        {
//            PolyModulusDegree = 128,
//            PlainModulus = new SmallModulus(1 << 6),
//            CoeffModulus = CoeffModulus.Create(128, new int[] { 40, 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//        RelinKeys relinKeys = keygen.RelinKeys();
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//
//        Ciphertext encrypted1 = new Ciphertext(context);
//        Ciphertext encrypted2 = new Ciphertext(context);
//        Plaintext plain1 = new Plaintext();
//        Plaintext plain2 = new Plaintext();
//
//        plain1.Set(0);
//        encryptor.Encrypt(plain1, encrypted1);
//        evaluator.SquareInplace(encrypted1);
//        evaluator.RelinearizeInplace(encrypted1, relinKeys);
//        decryptor.Decrypt(encrypted1, plain2);
//
//        Assert.AreEqual(1ul, plain2.CoeffCount);
//        Assert.AreEqual(0ul, plain2[0]);
//
//        plain1.Set("1x^10 + 2");
//        encryptor.Encrypt(plain1, encrypted1);
//        evaluator.SquareInplace(encrypted1);
//        evaluator.RelinearizeInplace(encrypted1, relinKeys);
//        evaluator.SquareInplace(encrypted1);
//        evaluator.Relinearize(encrypted1, relinKeys, encrypted2);
//        decryptor.Decrypt(encrypted2, plain2);
//
//        // {1x^40 + 8x^30 + 18x^20 + 20x^10 + 10}
//        Assert.AreEqual(41ul, plain2.CoeffCount);
//        Assert.AreEqual(16ul, plain2[0]);
//        Assert.AreEqual(32ul, plain2[10]);
//        Assert.AreEqual(24ul, plain2[20]);
//        Assert.AreEqual(8ul,  plain2[30]);
//        Assert.AreEqual(1ul,  plain2[40]);
//    }
//
//    [TestMethod]
//    public void RotateVectorTest()
//    {
//        int slotSize = 4;
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.CKKS)
//        {
//            PolyModulusDegree = 2 * (ulong)slotSize,
//            CoeffModulus = CoeffModulus.Create(2 * (ulong)slotSize, new int[] { 40, 40, 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//        GaloisKeys galoisKeys = keygen.GaloisKeys();
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//        CKKSEncoder encoder = new CKKSEncoder(context);
//
//        const double delta = 1ul << 30;
//
//        Ciphertext encrypted = new Ciphertext();
//        Plaintext plain = new Plaintext();
//
//        List<Complex> input = new List<Complex>
//        {
//            new Complex(1, 1),
//            new Complex(2, 2),
//            new Complex(3, 3),
//            new Complex(4, 4)
//        };
//
//        List<Complex> output = new List<Complex>();
//
//        encoder.Encode(input, context.FirstParmsId, delta, plain);
//
//        int shift = 1;
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.RotateVectorInplace(encrypted, shift, galoisKeys);
//        decryptor.Decrypt(encrypted, plain);
//        encoder.Decode(plain, output);
//
//        for (int i = 0; i < slotSize; i++)
//        {
//            Assert.AreEqual(input[(i + shift) % slotSize].Real, Math.Round(output[i].Real), delta: 0.1);
//            Assert.AreEqual(input[(i + shift) % slotSize].Imaginary, Math.Round(output[i].Imaginary), delta: 0.1);
//        }
//
//        encoder.Encode(input, context.FirstParmsId, delta, plain);
//        shift = 3;
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.RotateVectorInplace(encrypted, shift, galoisKeys);
//        decryptor.Decrypt(encrypted, plain);
//        encoder.Decode(plain, output);
//
//        for (int i = 0; i < slotSize; i++)
//        {
//            Assert.AreEqual(input[(i + shift) % slotSize].Real, Math.Round(output[i].Real), delta: 0.1);
//            Assert.AreEqual(input[(i + shift) % slotSize].Imaginary, Math.Round(output[i].Imaginary), delta: 0.1);
//        }
//    }
//
//    [TestMethod]
//    public void ComplexConjugateTest()
//    {
//        int slotSize = 4;
//        EncryptionParameters parms = new EncryptionParameters(SchemeType.CKKS)
//        {
//            PolyModulusDegree = 2 * (ulong)slotSize,
//            CoeffModulus = CoeffModulus.Create(2 * (ulong)slotSize, new int[] { 40, 40, 40, 40 })
//        };
//        SEALContext context = new SEALContext(parms,
//            expandModChain: false,
//            secLevel: SecLevelType.None);
//        KeyGenerator keygen = new KeyGenerator(context);
//        GaloisKeys galoisKeys = keygen.GaloisKeys();
//
//        Encryptor encryptor = new Encryptor(context, keygen.PublicKey);
//        Decryptor decryptor = new Decryptor(context, keygen.SecretKey);
//        Evaluator evaluator = new Evaluator(context);
//        CKKSEncoder encoder = new CKKSEncoder(context);
//
//        const double delta = 1ul << 30;
//
//        Ciphertext encrypted = new Ciphertext();
//        Plaintext plain = new Plaintext();
//
//        List<Complex> input = new List<Complex>
//        {
//            new Complex(1, 1),
//            new Complex(2, 2),
//            new Complex(3, 3),
//            new Complex(4, 4)
//        };
//
//        List<Complex> output = new List<Complex>();
//
//        encoder.Encode(input, context.FirstParmsId, delta, plain);
//        encryptor.Encrypt(plain, encrypted);
//        evaluator.ComplexConjugateInplace(encrypted, galoisKeys);
//        decryptor.Decrypt(encrypted, plain);
//        encoder.Decode(plain, output);
//
//        for (int i = 0; i < slotSize; i++)
//        {
//            Assert.AreEqual(input[i].Real, output[i].Real, delta: 0.1);
//            Assert.AreEqual(-input[i].Imaginary, output[i].Imaginary, delta: 0.1);
//        }
//    }
    
    
    private func createValidContext() throws -> ASLSealContext {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        try params.setPolynomialModulusDegree(8192)
        try params.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(8192))
        try params.setPlainModulusWithInteger(65537)
        return try ASLSealContext(encrytionParameters: params)
    }
}
