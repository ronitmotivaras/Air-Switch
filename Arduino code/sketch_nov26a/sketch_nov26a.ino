#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

const char* ssid = "Galaxy A15 5G";
const char* password = "Abcd1234";

// Pins
const int lightPin = D5;   // Pin for light
const int fanPin = D6;     // Pin for fan (PWM)

// Web Server
ESP8266WebServer server(80);

// Variable to store the current state
bool isLightOn = false;
int fanSpeed = 0; // 0 means off, values from 1-1023 for speed

void setup() {
  Serial.begin(115200);
  pinMode(D4, OUTPUT);
  pinMode(lightPin, OUTPUT);
  pinMode(fanPin, OUTPUT);
  digitalWrite(lightPin, LOW);
  analogWrite(fanPin, 0); // Set fan to 0 speed initially

  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println(WiFi.localIP());
  digitalWrite(D4, LOW);

  // Light control endpoint
  server.on("/light", HTTP_GET, []() {
    String state = server.arg("state"); // Get the 'state' argument
    server.sendHeader("Access-Control-Allow-Origin", "*"); // Add CORS headers
    server.sendHeader("Access-Control-Allow-Methods", "GET"); // Allow GET method

    if (state == "on") {
      digitalWrite(lightPin, HIGH);
      isLightOn = true; // Update light status
      server.send(200, "text/plain", "Light turned ON");
    } else if (state == "off") {
      digitalWrite(lightPin, LOW);
      isLightOn = false; // Update light status
      server.send(200, "text/plain", "Light turned OFF");
    } else {
      server.send(400, "text/plain", "Invalid state. Use 'on' or 'off'.");
    }
  });

  // Fan control endpoint
  server.on("/fan", HTTP_GET, []() {
    String speed = server.arg("speed"); // Get the 'speed' argument
    server.sendHeader("Access-Control-Allow-Origin", "*"); // Add CORS headers
    server.sendHeader("Access-Control-Allow-Methods", "GET"); // Allow GET method
    if (speed.length() > 0) {
      int pwmValue = speed.toInt();
      if (pwmValue >= 0 && pwmValue <= 1023) {
        analogWrite(fanPin, pwmValue);
        fanSpeed = pwmValue; // Update fan speed status
        server.send(200, "text/plain", "Fan speed set to " + speed);
      } else {
        server.send(400, "text/plain", "Invalid speed. Use values between 0 and 1023.");
      }
    } else {
      server.send(400, "text/plain", "Missing 'speed' parameter.");
    }
  });

  // Light status endpoint
  server.on("/status/light", HTTP_GET, []() {
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.sendHeader("Access-Control-Allow-Methods", "GET");

    if (isLightOn) {
      server.send(200, "text/plain", "Light is ON");
    } else {
      server.send(200, "text/plain", "Light is OFF");
    }
  });

  // Fan status endpoint
  server.on("/status/fan", HTTP_GET, []() {
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.sendHeader("Access-Control-Allow-Methods", "GET");

    if (fanSpeed == 0) {
      server.send(200, "text/plain", "Fan is OFF");
    } else {
      server.send(200, "text/plain", "Fan is ON with speed " + String(fanSpeed));
    }
  });

  server.begin();
}

void loop() {
  server.handleClient();
}
