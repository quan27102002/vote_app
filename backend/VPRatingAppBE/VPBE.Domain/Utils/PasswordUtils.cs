using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Utils
{
    public static class PasswordUtils
    {
        private static readonly int keySize = 64;
        private static readonly int iterations = 350000;
        private static readonly HashAlgorithmName algorithm = HashAlgorithmName.SHA512;
        public static string HashPassword(string password, out byte[] salt)
        {
            salt = RandomNumberGenerator.GetBytes(keySize);

            var hash = Rfc2898DeriveBytes.Pbkdf2(Encoding.UTF8.GetBytes(password), salt, iterations, algorithm, keySize);

            return Convert.ToHexString(hash);
        }

        public static bool VerifyPassword(string password, string hash, byte[] salt)
        {
            var hashToCompare = Rfc2898DeriveBytes.Pbkdf2(password, salt, iterations, algorithm, keySize);
            return CryptographicOperations.FixedTimeEquals(hashToCompare, Convert.FromHexString(hash));
        }
    }
}
