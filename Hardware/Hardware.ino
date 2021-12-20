#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <FS.h>

const String WIFI_SSID = "The Cyan One";
const String PASSWORD = "October2020"; 
byte pinD[9] = { 16, 5, 4, 0, 2, 14, 12, 13, 15 };
const int LED_PIN = LED_BUILTIN;

ESP8266WebServer server(80);

void createFile() {
  SPIFFSConfig cfg;
  cfg.setAutoFormat(false);
  SPIFFS.setConfig(cfg);
  SPIFFS.begin();
  if ( SPIFFS.exists("/database.txt") )
    Serial.println("\nexist");
}

void addToFile(String text) {
  File file = SPIFFS.open("/database.txt", "a+");
  file.println(text);
  file.close();
//  SPIFFS.end();
}
String readFromFile() {
  File file = SPIFFS.open("/database.txt", "r");
  String data = file.readString();
  file.close();
  return data;
}
String getDPinStatus() {
  String json = "[";
  for(int i=0;i<9;i++) {
    double d_value = digitalRead(pinD[i]);
    json += String(d_value);
    if(i!=8)
      json += ",";
  }
  json += "]";
  return json;
}
void handleRoot() 
{
  server.send(200, "text/plain", "hello from esp8266!");
}

void handleNotFound() {
  server.send(404, "text/plain", "Bad Request!");
}
bool isConnectedToWiFi() 
{
  return WiFi.status() == WL_CONNECTED;
}

void connectingToWiFi()
{
  String message = "Connecting to " + WIFI_SSID + "! Please Wait.";
  Serial.println(message);
  int counter = 0;
  while (!isConnectedToWiFi())
  {
    delay(1000);
    Serial.print("!");
    counter++;
  }
  message = "Connected after " + String(counter) + " seconds.";
  Serial.println(WiFi.localIP());
  Serial.print(message);
}
void mdns() {
  if (MDNS.begin("flutter-arduino")) {
    Serial.println("MDNS responder started");
  }
}
void manageAPI() {
  
  server.on("/", handleRoot);
  server.on("/pin", []() {
    server.send(200, "text/plain", "this works as well");
  });
  server.on("/getpinsstatus",[]() {
    String message = getDPinStatus();
    server.send(200, "text/plain", message);
  });
  server.on("/ledon", []() {
    digitalWrite(LED_PIN, LOW);
    server.send(200, "text/plain", "LED is on.");
  });

  server.on("/ledoff", []() {
    digitalWrite(LED_PIN, HIGH);
    server.send(200, "text/plain", "LED is off.");
  });
  
  server.on("/send", []() {
    server.send(200, "text/plain", "Succeed");
    String message = "";
    message += server.arg(0) + ": " + server.arg(1);
    addToFile(message);
  });

  server.on("/removehistory", []() {
    SPIFFS.remove("/database.txt");
    server.send(200, "text/plain", "Succeed");
  });

  server.on("/gethistory", []() {
    String history = readFromFile();
    server.send(200, "text/plain", history);
  });

  
  server.onNotFound(handleNotFound);
}


void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, PASSWORD);
  createFile();
  connectingToWiFi();
  mdns();
  manageAPI();
  server.begin();
  Serial.println("This marks the end of the setup.");
}




void loop() {
  server.handleClient();
  MDNS.update();
}
