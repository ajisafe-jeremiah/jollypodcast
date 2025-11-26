# Jolly Podcast – Flutter Coding Assessment

This is my implementation of the **Jolly Podcast App** as part of the Bloocode Technology Flutter Coding Assessment.  
The project follows a clean, scalable architecture using **BLoC**, **Repositories**, and **Services**, with API integration for login, fetching podcasts, and playing audio.


## Features Implemented

### Login Feature
- Login UI based on the provided Figma design
- API login request using the official Swagger endpoint
- Handles success/error responses
- Stores token for authenticated requests
- Displays user-friendly validation errors

### Podcast List
- Fetches a list of podcasts after successful login
- Shows podcast title + thumbnail
- Handles:
  - Loading state
  - Error state
  - Empty list state

### Podcast Player
- Opens a dedicated player page when a podcast is tapped
- Fully functional audio playback using network audio URL
- At least two podcasts are tested and playable
- Graceful error fallback if audio fails to load

---

## Project Structure

The project uses a modular, scalable architecture:

```bash
lib/
 ├── blocs/           # BLoC logic for Login, Podcasts, Player
 ├── errors/          # Error handling (API errors, network failures)
 ├── models/          # Data models (User, Podcast, etc.)
 ├── repo/            # Repository layer for API <-> bloc connection
 ├── services/        # API services using Dio/HTTP
 ├── theme/           # App colors, text styles, theming
 ├── ui/              # Screens & widgets (login, list, player)
 ├── constants.dart   # App-wide constants
 ├── router.dart      # Navigation routing
 └── main.dart        # App entry point

Chosen State Management: BLoC

Why BLoC?

Clear separation of UI & business logic
Easy to scale and maintain
Works well with events & emits for API calls and audio states
Fits perfectly into a structured architecture (services → repo → blocs)

TO run the project:

git clone: https://github.com/ajisafe-jeremiah/jollypodcast.git

cd jollypodcast

flutter pub get

flutter run

Test Credentials
Phone: 08114227399
Password: Development@101

Assumptions Made
API does not return some fields from the design, so defaults were used
Audio URLs provided in the API are valid and playable
Podcast player uses basic playback controls (advanced features not required)

Saw the mail late but here are some...
Improvements If More Time Was Provided

Add caching for podcast list

Implement more advanced audio controls:

Playback speed

Skip forward/backwards

Add unit tests & widget tests

Add shimmer/loading animations

Improve pixel-perfect UI alignment

Add dark mode support and light

Add proper failure UI (illustrations, retry buttons)