# 🌤️ Weather App

A simple and user-friendly weather application built with **Flutter** and **Dart**.

The app automatically detects the user's current location and displays the current weather information for that location using the **OpenWeather API**.

## ✨ Features

* 📍 Automatically detects the user's current location
* 🏙️ Identifies the current city using location coordinates
* 🌡️ Displays current temperature
* ☁️ Displays current weather conditions
* 💨 Shows additional weather information
* 🔄 Fetches real-time weather data from OpenWeather API
* 📱 Clean and responsive Flutter interface

## 🛠️ Technologies Used

* **Flutter**
* **Dart**
* **OpenWeather API**
* **Geolocator** – used to get the device's current location
* **Geocoding** – used to convert coordinates into a readable location/city name

## 🔄 How the App Works

The application follows a simple process:

1. The app requests location permission from the user.
2. It gets the device's current latitude and longitude using **Geolocator**.
3. The coordinates are converted into a city/location name using **Geocoding**.
4. The location information is used to request weather data from the **OpenWeather API**.
5. The retrieved weather data is displayed on the screen.

## 🚀 Getting Started

### Prerequisites

Make sure you have Flutter installed on your system.

Check your Flutter installation:

```bash
flutter doctor
```

### Installation

Clone this repository:

```bash
git clone https://github.com/YOUR-USERNAME/weather_app.git
```

Navigate to the project directory:

```bash
cd weather_app
```

Install the required dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 🔑 OpenWeather API

This project uses the **OpenWeather API** to retrieve weather information.

To run the project, you need to create your own API key and configure it in the application.

**Important:** Do not upload your private API key directly to a public GitHub repository.

## 📚 What I Learned

While developing this project, I practiced:

* Building Flutter user interfaces
* Working with REST APIs
* Fetching and handling JSON data
* Using device location services
* Working with latitude and longitude
* Converting coordinates into a readable location
* Managing asynchronous operations in Dart
* Displaying dynamic API data in Flutter

## 🔮 Future Improvements

Possible improvements for the project include:

* 🌦️ 7-day weather forecast
* 🕐 Hourly weather forecast
* 🔍 Search weather by city
* 🌙 Dark mode
* 🎨 Weather-based animations
* 🔔 Weather notifications
* 🌧️ More detailed weather information

## 👨‍💻 About

This project was developed using **Flutter and Dart** as a learning and portfolio project to practice API integration, location services, and dynamic UI development.
