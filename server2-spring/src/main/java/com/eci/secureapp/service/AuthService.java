package com.eci.secureapp.service;

import com.eci.secureapp.dto.AuthRequest;
import com.eci.secureapp.dto.AuthResponse;
import com.eci.secureapp.model.AppUser;
import com.eci.secureapp.repository.UserRepository;
import com.eci.secureapp.security.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
    }

    public AuthResponse register(AuthRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("El usuario ya existe");
        }

        AppUser appUser = new AppUser();
        appUser.setUsername(request.getUsername());
        appUser.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        userRepository.save(appUser);

        String token = jwtUtil.generateToken(appUser.getUsername());
        return new AuthResponse(token, appUser.getUsername());
    }

    public AuthResponse login(AuthRequest request) {
        AppUser appUser = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new IllegalArgumentException("Credenciales inválidas"));

        boolean valid = passwordEncoder.matches(request.getPassword(), appUser.getPasswordHash());
        if (!valid) {
            throw new IllegalArgumentException("Credenciales inválidas");
        }

        String token = jwtUtil.generateToken(appUser.getUsername());
        return new AuthResponse(token, appUser.getUsername());
    }
}
