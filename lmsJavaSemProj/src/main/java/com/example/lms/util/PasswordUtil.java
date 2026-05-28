package com.example.lms.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Simple wrapper around BCrypt for password hashing and verification.
 * Simple wrapper for password comparison.
 */
public class PasswordUtil {

    private PasswordUtil() { }

    public static String hash(String plainTextPassword) {
        // Hashing removed as requested. Storing plain text.
        return plainTextPassword;
    }

    public static boolean verify(String plainTextPassword, String storedPassword) {
        // Simple plain text comparison
        if (plainTextPassword == null || storedPassword == null) return false;
        return plainTextPassword.equals(storedPassword);
    }
}
