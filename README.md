# 👔 DressedAT — Your AI-Powered Digital Wardrobe

### **Never repeat an outfit to the same place twice.**

DressedAT is a sophisticated wardrobe management application designed for the modern professional. It goes beyond simple "closet logging" by implementing a tracking engine that remembers exactly what you wore, when you wore it, and who saw you in it. 

Built with **Flutter** and powered by **Riverpod**, this app demonstrates high-level state management and scalable mobile architecture.

---

## ✨ Key Features

- **Digital Closet:** Catalog your entire wardrobe with categorized tags (Formal, Casual, Winter, etc.).
- **Smart Event Tracking:** Log outfits against specific events and locations.
- **"Anti-Repeat" Logic:** Intelligent reminders and history checks to ensure outfit variety across different social circles.
- **Cloud-Synced Identity:** Secure user authentication and real-time database integration (Supabase/Firebase).
- **Advanced State Management:** Robust implementation using **Riverpod** for a reactive and bug-free user experience.

---

## 🛠️ Technical Stack & Architecture

- **Frontend:** Flutter & Dart
- **State Management:** **Riverpod** (Refactored from Provider for better testability and logic separation).
- **Backend:** Supabase / Firebase (Authentication & Relational Database).
- **Architecture:** Feature-first folder structure (Clean Architecture principles).
- **UI/UX:** Modern, minimalist interface with a focus on speed and ease of logging.

---

## 🧠 Why DressedAT?

This project was built to solve the "what should I wear?" fatigue while showcasing complex data relationships. 
- **The Challenge:** Handling many-to-many relationships between *Garments*, *Outfits*, and *Events*.
- **The Solution:** A reactive state model that updates globally whenever a new event is logged, ensuring the "Last Worn" metadata is always accurate.

---

## 🚀 Installation

1. **Clone the repo:**
   ```bash
   git clone [https://github.com/MuhammadAwaisGill/DressedAT.git](https://github.com/MuhammadAwaisGill/DressedAT.git)
