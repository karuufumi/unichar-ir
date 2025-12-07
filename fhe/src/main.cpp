#include <seal/seal.h>
#include <iostream>
#include <vector>

using namespace std;
using namespace seal;

int main() {
    // ===============================
    // 1. CKKS parameters
    // ===============================
    size_t poly_modulus_degree = 8192;
    double scale = pow(2.0, 40);

    EncryptionParameters parms(scheme_type::ckks);
    parms.set_poly_modulus_degree(poly_modulus_degree);
    parms.set_coeff_modulus(CoeffModulus::Create(
        poly_modulus_degree, { 60, 40, 40, 60 }
    ));

    SEALContext context(parms);
    cout << "SEAL CKKS context created." << endl;

    // ===============================
    // 2. Key generation (API changed in SEAL 4.x)
    // ===============================
    KeyGenerator keygen(context);

    PublicKey public_key;
    keygen.create_public_key(public_key);

    SecretKey secret_key = keygen.secret_key();

    RelinKeys relin_keys;
    keygen.create_relin_keys(relin_keys);

    Encryptor encryptor(context, public_key);
    Decryptor decryptor(context, secret_key);
    Evaluator evaluator(context);
    CKKSEncoder encoder(context);

    // ===============================
    // 3. Encode and Encrypt
    // ===============================
    vector<double> vec1 = {1.0, 2.0, 3.0};
    vector<double> vec2 = {4.0, 5.0, 6.0};

    Plaintext p1, p2;
    encoder.encode(vec1, scale, p1);
    encoder.encode(vec2, scale, p2);

    Ciphertext c1, c2;
    encryptor.encrypt(p1, c1);
    encryptor.encrypt(p2, c2);

    cout << "Vectors encrypted." << endl;

    // ===============================
    // 4. Homomorphic addition
    // ===============================
    Ciphertext c_add;
    evaluator.add(c1, c2, c_add);

    // ===============================
    // 5. Decrypt + decode result
    // ===============================
    Plaintext plain_result;
    decryptor.decrypt(c_add, plain_result);

    vector<double> result;
    encoder.decode(plain_result, result);

    cout << "Result: ";
    for (double x : result) {
        cout << x << " ";
    }
    cout << endl;

    return 0;
}