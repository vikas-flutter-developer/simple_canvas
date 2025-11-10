# 🖋️ Simple Canvas

> A Flutter project for a **Text Editor Assignment**, designed to let users freely add, move, and style text on a canvas — with full local persistence.

---

## 📱 About the Project

**Simple Canvas** is a Flutter-based text editor app that allows users to:
- Add multiple text elements
- Move them around the screen
- Apply font styles and sizes dynamically
- Save their layout using local SQLite storage  


---

## ✨ Features

✅ **Persistent Storage**  
All text items, styles, and positions are saved using a **local SQLite database**, automatically reloaded each time the app is opened.

✅ **Dynamic Toolbar**  
A context-aware toolbar appears when an item is selected, and hides when no text is active.

✅ **Move Text**  
Intuitively drag and drop text widgets anywhere on the canvas.

✅ **Undo / Redo**  
A complete history stack for all major actions — add, move, style, or delete text — and revert anytime.

✅ **Rich Text Styling**
- Change **font family** (from Google Fonts)
- Toggle **Bold**, **Italic**, and **Underline**
- Adjust **font size** using `+` and `-`
- Type a **custom font size** directly into a text field

✅ **Delete Text**  
Remove selected text instantly using the toolbar’s trash icon.

✅ **Clean Architecture**  
Organized into clear `screens/` and `widgets/` directories for better maintainability.

---

## 🛠️ Tech Stack

| Category | Technology |
|-----------|-------------|
| **Framework** | Flutter |
| **Language** | Dart |
| **Database** | sqflite |
| **Fonts** | google_fonts |
| **File System Access** | path_provider |
| **Icons** | cupertino_icons |
| **State Management** | setState (built-in) |

---

## 📂 Project Structure

The project is organized into a clean, scalable structure:

```
lib/
├── main.dart             # App entry point, theme setup
├── helpers/
│   └── database_helper.dart # All SQLite logic (CRUD)
├── models/
│   └── text_item.dart      # Data model for a text item (with toMap/fromMap)
├── screens/
│   └── text_editor_screen.dart # Main screen, holds all state and business logic
└── widgets/
    ├── canvas_header.dart   # Top bar (Undo, Redo)
    ├── editor_canvas.dart   # The interactive canvas with draggable text
    └── editor_toolbar.dart  # The dynamic bottom toolbar (Add/Edit)