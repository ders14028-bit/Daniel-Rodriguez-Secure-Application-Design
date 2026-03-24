package com.eci.secureapp.controller;

import java.security.Principal;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public Map<String, String> hello(Principal principal) {
        return Map.of(
                "message", "Hola, endpoint protegido funcionando correctamente",
                "user", principal.getName()
        );
    }
}
