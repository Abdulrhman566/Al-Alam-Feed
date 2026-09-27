# 📰 News App — Flutter

A modern and clean **Flutter News App** that allows users to discover the latest news, search for specific topics, browse top headlines, read full articles, and share news with others.

The app uses **NewsAPI** to fetch real-time news and provides a simple, responsive, and user-friendly interface.

---

## 📱 Features

* 🔥 **Top Headlines**

  * Displays the latest top headlines in a horizontal scrolling list.
  * Tap any headline to open the complete article.

* 🔎 **Search News**

  * Search for news by keyword.
  * Search results are loaded dynamically from the API.

* 📰 **Latest News**

  * Displays news articles in a clean vertical list.
  * Each article includes an image, title, description, and actions.

* 📖 **Read Full Article**

  * Open the original article directly from the app.

* 📤 **Share Articles**

  * Share news articles using the device's native sharing functionality.

* 🔄 **Refresh News**

  * Refresh the latest news using the refresh button.

* 🖼️ **Image Handling**

  * Displays article images when available.
  * Shows a placeholder when an image is unavailable or fails to load.

* ⏳ **Loading States**

  * Separate loading indicators for top headlines and search results.

* ⚠️ **Error Handling**

  * Handles failed API requests and displays appropriate messages.

* 🎨 **Modern UI**

  * Clean purple-themed design.
  * Rounded cards.
  * Smooth horizontal headlines section.
  * Responsive layout.

---

## 🛠️ Technologies Used

| Technology      | Purpose                          |
| --------------- | -------------------------------- |
| Flutter         | Mobile/Web application framework |
| Dart            | Programming language             |
| NewsAPI         | News data provider               |
| HTTP            | API requests                     |
| `url_launcher`  | Open news articles               |
| `share_plus`    | Share articles                   |
| Material Design | User interface                   |

---

## 📂 Project Structure

```text
lib/
├── constants/
│   └── app_api.dart
│
├── models/
│   └── news_model.dart
│
├── screens/
│   └── home_screen.dart
│
└── main.dart
```

---

## 🔌 API

This application uses **NewsAPI** to retrieve news.

Two endpoints are used:

### Search News

```text
everything?q={query}&apiKey={API_KEY}
```

This endpoint is used when the user searches for a topic.

### Top Headlines

```text
top-headlines?country=us&apiKey={API_KEY}
```

This endpoint retrieves the current top headlines.

---

## 🔐 API Key Setup

Create your API configuration file:

```text
lib/constants/app_api.dart
```

Example:

```dart
class AppApi {
  static const String baseurl = "https://newsapi.org/v2/";
  static const String apikey = "YOUR_API_KEY";
}
```

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

### 2. Open the project

```bash
cd new_api_session
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Add your API key

Update:

```text
lib/constants/app_api.dart
```

with your NewsAPI key.

### 5. Run the application

```bash
flutter run
```

For Chrome:

```bash
flutter run -d chrome
```

---

## 📦 Dependencies

The project uses the following main packages:

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  http: ^1.6.0
  url_launcher: ^6.3.2
  share_plus: ^13.3.0
```

The app also uses:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.4
```

for generating the application launcher icon.

---

## 🎨 App UI

The application includes:

### Home Screen

The home screen contains:

1. Application title
2. Search bar
3. Top Headlines section
4. Horizontal news cards
5. Latest News section
6. News article cards

Each article card provides:

* 🖼️ Article image
* 🏷️ News category
* 📰 Article title
* 📝 Description
* 📖 Read Article button
* 📤 Share button

---

## 🔄 Application Flow

```text
                 ┌─────────────────┐
                 │    Home Screen  │
                 └────────┬────────┘
                          │
             ┌────────────┴────────────┐
             │                         │
             ▼                         ▼
      ┌──────────────┐          ┌───────────────┐
      │ Top Headlines│          │ Search News   │
      └──────┬───────┘          └───────┬───────┘
             │                          │
             └────────────┬─────────────┘
                          ▼
                   ┌─────────────┐
                   │  News API   │
                   └──────┬──────┘
                          │
                          ▼
                   ┌─────────────┐
                   │ News Results │
                   └──────┬──────┘
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
       ┌──────────────┐        ┌──────────────┐
       │ Read Article │        │ Share Article│
       └──────────────┘        └──────────────┘
```

---

## 🧠 What I Practiced

This project helped me practice several important Flutter concepts:

* REST API integration
* HTTP requests
* JSON parsing
* Creating Dart models from JSON
* `Future` and asynchronous programming
* `StatefulWidget`
* `initState()`
* `setState()`
* `CustomScrollView`
* `SliverToBoxAdapter`
* `SliverList`
* Horizontal `ListView`
* `Image.network`
* Error handling
* Search functionality
* External URL launching
* Native sharing
* Loading states
* Responsive UI design
* Flutter project organization

---

## 🔮 Future Improvements

Possible improvements for future versions:

* 🌙 Dark mode
* ❤️ Favorite/bookmark articles
* 📚 Saved articles screen
* 🗂️ News categories
* 🌍 Country selection
* 🌐 Multi-language support
* 🔔 Breaking-news notifications
* 📅 Published date and time
* 🏢 Display the article source
* ♻️ Pagination / infinite scrolling
* 💾 Local caching for offline access
* 🔐 Move API requests behind a backend service


---

## 📄 License

This project is created for learning and portfolio purposes.
