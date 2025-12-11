# Swift Piscine: The Trinity of Mobile Fundamentals

> *"What is a coding portfolio without a Calculator, a Note app, and a Weather app?"*

At first glance, these projects might seem like the standard "Hello World" of mobile development—banal, even clichéd. But look closer. These aren't just apps; they are the **three pillars** upon which every robust mobile skillset is built. They represent the journey from internal logic, to external communication, to user identity.

This repository is a collection of 42 School "Piscine" subjects, solved with a focus on modern **SwiftUI**, **Clean Architecture**, and **Scalability**.

---

## 🧠 The Calculator: Logic & Layout
**Project**: `calculator_app` (Day 00)

![Calculator App](img/Calc.png)

A calculator is deceptively simple. It forces you to confront the chaos of user state. It is the pure distillation of **Internal Logic**.

*   **The Challenge**: Managing complex state transitions (operands, operators, decimals) without creating a "Massive View Controller".
*   **The Solution**:
    *   **MVVM Architecture**: Strict separation of the calculation engine (Model) from the View, mediated by a ViewModel to sanitise inputs.
    *   **SwiftUI Layouts**: deeply nested `VStack` and `HStack` grids that adapt responsibly.
    *   **State Management**: Using `@Published` properties to drive UI updates reactively, ensuring the display is always in sync with the data.

**Key Tech**: `SwiftUI`, `MVVM`, `Grid/Stacks`, `Error Handling`.

---

## 🌍 The Weather App: Senses & Networking
**Project**: `medium_weather_app` / `advanced_weather_app` (Day 01-03)

![Weather App](img/Weather.png)

If the Calculator is the brain, the Weather App is the **Senses**. It breaks the isolation of the device, teaching it to speak to the outside world.

*   **The Challenge**: The real world is messy. APIs fail, networks lag, and locations change. The app must process asynchronous data streams gracefully.
*   **The Solution**:
    *   **Async/Await**: Modern concurrency to handle network requests without "callback hell".
    *   **OpenMeteo API**: Interfacing with a RESTful service, parsing raw JSON into type-safe Swift structs using `Codable`.
    *   **CoreLocation**: Handling dangerous permissions and accessing the device's GPS hardware.
    *   **State Orchestration**: Handling `Loading`, `Success`, and `Error` states to keep the user informed during network latency.

**Key Tech**: `URLSession`, `Async/Await`, `Codable`, `CoreLocation`, `Dependancy Injection`.

---

## 🔐 The Diary App: Identity & Persistence
**Project**: `diary_app` (Day 04-05)

![Diary App](img/notes.png)

The final pillar is **Memory**. A Notes app transforms a temporary experience into a permanent one. It introduces the user as a distinct entity.

*   **The Challenge**: Data needs to survive the app closing. More importantly, it needs to be secure and tied to a specific individual.
*   **The Solution**:
    *   **Firebase Authentication**: Implementing full OAuth 2.0 flows (Google & GitHub Sign-In) to manage secure user sessions.
    *   **Reactive Flow**: Using `Combine` authentication listeners to automatically route the user between Login and Home screens based on session state.
    *   **Complex UI**: Custom modal presentations (`FormPopup`) and deep navigation stacks.
    *   **Security**: Handling tokens and user credentials safely.

**Key Tech**: `Firebase Auth` (OAuth), `GoogleSignIn`, `Combine`, `Secure Storage`, `Custom Modals`.

---

## 🛠 Tech Stack Overview

| Category | Technologies Used |
| :--- | :--- |
| **UI Framework** | SwiftUI, UIKit Integration |
| **Architecture** | MVVM (Model-View-ViewModel) |
| **Concurrency** | Async/Await, Combine |
| **Networking** | URLSession, REST APIs, JSON Parsing |
| **Backend/Auth** | Firebase Auth, OAuth (Google/GitHub) |
| **Hardware** | CoreLocation (GPS) |

---

### Conclusion
This repository isn't just a list of exercises. It is a progression from **controlling the screen** (Calculator), to **connecting to the world** (Weather), to **recognizing the user** (Diary). These are the fundamental atoms of every major app you use today.
