#include <Arduino.h>
#include <Wire.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd(7, 8, 9, 10, 11, 12);
String incomingString = "";
int buzzer = 2;

void setup() {
  Serial.begin(9600);
  lcd.begin(16, 2);
  pinMode(buzzer, OUTPUT);
}

void notifingBeep() {
  unsigned char i;
  for(i=0;i<50;i++) {
  digitalWrite(buzzer, HIGH);
  delay(10);
  digitalWrite(buzzer, LOW);
  delay(10);
  }
}

void got_email(String subject) {

  //Initial two beeps to alert user to incoming email
  notifingBeep();
  delay(200);
  notifingBeep();

  lcd.setCursor(0, 0);
  lcd.print("You've got mail!");
  delay(5000);

  int str_len = subject.length() + 1;
  char char_array[str_len];
  subject.toCharArray(char_array, str_len);
  unsigned int i;

  lcd.clear();
  lcd.setCursor(16, 1);
  lcd.autoscroll();
  for (i = 0; i < sizeof(char_array) - 1; i++){
    lcd.print(char_array[i]);
    delay(500);
  }

  //Last beep to inform user of end of email
  notifingBeep();
}

void loop() {
  if(Serial.available() > 0) {
    incomingString = Serial.readString();
    got_email(incomingString);
  }
}
