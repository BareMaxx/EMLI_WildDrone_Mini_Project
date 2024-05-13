#include <ArduinoJson.h>
#include <Servo.h>

Servo servo;
const int push_buttonPin = 2;

void setup() {
  // Initialize serial communication
  Serial.begin(115200);

  // Attach servo to pin 15
  servo.attach(15);
}

char s[100];
int push_button = 0;
int angle = 0;

void loop() {
  push_button = BOOTSEL;
  if (Serial.available() > 0) {
    // Read the JSON object from the serial port

    JsonDocument doc;
    DeserializationError error = deserializeJson(doc, Serial);

    // Check if JSON parsing was successful
    if (!error) {
      // Extract angle from JSON object
      int new_angle = doc["wiper_angle"];

      if (new_angle < 0 || new_angle > 180) {
        sprintf (s, "{\"serial\": \"angle_error\"}");
        Serial.println(s);
      } else 
      {
        angle = new_angle;
        servo.write(angle);
      }
    } else {
        sprintf (s, "{\"serial\": \"json_error\"}");
        Serial.println(s);
    }
  }
  else
  {
     sprintf (s, "{\"wiper_angle\": %d, \"rain_detect\": %d}", angle, push_button);
     Serial.println(s);
  }

  // Wait for serial input to stabilize
  delay(100);
}
