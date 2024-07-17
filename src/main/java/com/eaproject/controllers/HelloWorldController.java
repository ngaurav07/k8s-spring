package com.eaproject.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
    @GetMapping("/hello")
    public ResponseEntity<String> printHelloWorld(){
        return new ResponseEntity<>("Hello I am running.", HttpStatus.OK);
    }

    @GetMapping("/api/v3/hello")
    public ResponseEntity<String> printHelloWorldv3(){
        return new ResponseEntity<>("Hello I am running in v3.", HttpStatus.OK);
    }

}
