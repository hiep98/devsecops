package com.devsecops;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@RestController
public class NumericController {

	private final Logger logger = LoggerFactory.getLogger(getClass());
	private static final String baseURL = "http://node-service:5000/plusone";
	
	RestTemplate restTemplate = new RestTemplate();
	
	@RestController
	public class compare {

		@GetMapping("/")
		public String welcome() {
			return "Kubernetes DevSecOps";
		}

		@GetMapping("/compare/{value}")
		public String compareToFifty(@PathVariable int value) {
			String message = "Could not determine comparison";
			if (value > 50) {
				message = "Greater than 50";
			} else {
				message = "Smaller than or equal to 50";
			}
			return message;
		}

		@GetMapping("/increment/{value}")
		public int increment(@PathVariable int value) {
			ResponseEntity<String> responseEntity = restTemplate.getForEntity(baseURL + '/' + value, String.class);
			String response = responseEntity.getBody();
			logger.info("Value Received in Request - " + value);
			logger.info("Node Service Response - " + response);
			return Integer.parseInt(response);
		}
	}

}
@ControllerAdvice
public class CustomExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> handleException(Exception ex, WebRequest request) {
        // log the error message
        log.error("Unexpected error occurred: {}", ex.getMessage());

        // create a custom error response
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(), "An unexpected error occurred");

        return handleExceptionInternal(ex, errorResponse, new HttpHeaders(), HttpStatus.INTERNAL_SERVER_ERROR, request);
    }

    @ExceptionHandler(YourCustomException.class)
    public ResponseEntity<Object> handleCustomException(YourCustomException ex, WebRequest request) {
        // log the error message with the specific details
        log.error("Your custom exception occurred: {}", ex.getMessage());

        // create a custom error response with the specific details
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage());

        return handleExceptionInternal(ex, errorResponse, new HttpHeaders(), HttpStatus.BAD_REQUEST, request);
    }
}

public class ErrorResponse {
    private int status;
    private String message;

    // constructor, getters and setters
}
