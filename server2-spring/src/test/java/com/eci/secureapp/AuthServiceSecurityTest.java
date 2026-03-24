package com.eci.secureapp;

import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.eci.secureapp.dto.AuthRequest;
import com.eci.secureapp.model.AppUser;
import com.eci.secureapp.repository.UserRepository;
import com.eci.secureapp.service.AuthService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootTest(properties = {
        "security.jwt.secret=THIS_IS_A_TEST_SECRET_WITH_MORE_THAN_32_CHARACTERS",
        "server.ssl.enabled=false"
})
class AuthServiceSecurityTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    void registerShouldStoreHashedPassword() {
        String username = "security_test_user";
        String rawPassword = "DemoPass123!";

        AuthRequest request = new AuthRequest();
        request.setUsername(username);
        request.setPassword(rawPassword);

        authService.register(request);

        AppUser user = userRepository.findByUsername(username).orElseThrow();

        assertNotEquals(rawPassword, user.getPasswordHash());
        assertTrue(passwordEncoder.matches(rawPassword, user.getPasswordHash()));
    }
}
