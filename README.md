# 🎮 **30 Games Collection**
### **Mini-Game Collection Framework** (Godot 4)

Die 30 Games Collection ist ein **modulares Mini-Game-Framework** auf Basis von **Godot 4**,\
bestehend aus einem globalen **Launcher** und mehreren eigenständig spielbaren Mini-Games.\
Das Projekt dient dem Training darin zu lernen wie man Spiele entwickelt.

🎯 Ziel des Projekts ist es, systematisch zu lernen, wie Spieleentwicklung funktioniert,\
von Architektur über Gameplay-Logik bis hin zu UI, Audio und Projektorganisation.

Das Projekt ist als **Lernpfad- & Experimentierumgebung** aufgebaut.

***

## 📌 **Projektüberblick**

- **Engine:** Godot 4.x
- **Genre:** Arcade / Casual / Skill-based
- **Zielplattformen:** Desktop, Android (Mobile-first)
- **Projektart:** Launcher + modulare Mini-Games
- **Status:** Work in Progress / Lernprojekt

**Jedes Mini-Game:**
- lebt in einem eigenen Ordner
- kann unabhängig vom Launcher entwickelt werden
- nutzt gemeinsame Systeme & Konventionen
- dient dazu, ein konkretes Spieleentwicklungs-Thema zu erlernen

Testbare Builds werden als APK und Desktop-Executable über die GitHub-Releases bereitgestellt

***

## 🎓 **Lernziele des Projekts**

Dieses Projekt dient dem Training in folgenden Bereichen:

- Strukturierung größerer Godot-Projekte
- Modularisierung von Gameplay
- Event-basierte Kommunikation (Signals)
- Trennung von Gameplay, UI und Systemen
- Wiederverwendbare Systeme (Audio, Scores, Settings)
- Umgang mit mehreren Spielen in einem Projekt

***

## 🧠 **Architektur-Philosophie**

### **Leitprinzipien**

- **Lose Kopplung**
  - Keine hart kodierten Node-Pfade
  - Zugriff über Gruppen & Signals

- **Separation of Concerns**
  - Gameplay ≠ UI
  - UI ≠ Systeme
  - Systeme sind unabhängig vom Spiel

- **Modulare Mini-Games**
  - Jedes Spiel ist isoliert
  - Gemeinsame Infrastruktur über den Launcher

- **Event-basiert**
  - Kommunikation erfolgt über Signals
  - Kein direktes Abfragen fremder Nodes

***

## 🚀 **Launcher-Konzept**

Der Launcher ist verantwortlich für:
- Initialisierung des Projekts
- Anzeige der verfügbaren Mini-Games
- Laden & Entladen von Spielen
- Gemeinsame Systeme (z. B. Audio, Settings)
- Mini-Games kennen den Launcher nicht direkt.

***

## 🧩 **Mini-Game-Konzept**

Jedes Mini-Game:
- liegt unter res://Games/
- besitzt eine eigene Root-Szene
- ist technisch isoliert
- kann theoretisch standalone gestartet werden
- folgt denselben strukturellen Konventionen


**Juicy Jutsu** ist das erste Mini-Game und dient als Referenz-Implementierung.

***

## 🔊 **Assets & Audio**

⚠️ Audio-Assets sowohl Soundeffekte als auch Musik sind nicht Teil des Repositories.

Gründe:
- Dateigröße
- Lizenzrechtliche Einschränkungen
- werden teilweise später ersetzt

Fehlende Assets müssen lokal ergänzt werden.

***

## 📦 **Releases & Test-Builds**

Zu Lern- und Testzwecken wird es regelmäßige Releases geben.

Diese enthalten:
- 📱 **Android APKs**
- 🖥️ **Desktop Builds (Windows `.exe`)**

Die Builds dienen dazu:
- den aktuellen Entwicklungsstand zu testen
- Game Feel & Bedienung auszuprobieren
- Fortschritte zwischen einzelnen Mini-Games zu vergleichen

⚠️ **Hinweis:**  
Die Releases sind experimentell, nicht final und können:
- unfertige Features enthalten
- Platzhalter-Assets nutzen
- sich zwischen Versionen stark verändern

Feedback und Tests sind willkommen.

***

## 📄 **Lizenz & Nutzung**
Dieses Projekt dient primär zu Lern- und Übungszwecken.

***

## 📁 **Projektstruktur**

Die Projektstruktur ist bewusst klar getrennt und soll so beibehalten werden:

```text
res://
├─ Assets/              # Gemeinsame Assets (optional)
│
├─ executables/         # Exportierte Builds (nicht versioniert)
│
├─ Games/               # Alle Mini-Games
│  └─ juicyjutsu/
│     ├─ gameplay/      # Gameplay-Logik (Spawner, Entities, Score)
│     ├─ ui/            # Spielinterne UI (HUD, Menüs)
│     ├─ systems/       # Spielspezifische Systeme
│     ├─ assets/        # Game-spezifische Assets
│     └─ juicy_jutsu.tscn  # GameRoot-Szene
│
├─ Launcher/            # Globaler Launcher
│  ├─ Launcher_UI/      # UI des Launchers
│  ├─ Main/             # Boot / Entry Scene
│  └─ Main_Menu/        # Spielauswahl & Navigation
│
├─ default_bus_layout.tres
├─ export_presets.cfg
├─ icon.svg
└─ README.md