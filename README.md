# DressedAT 

**DressedAT** is a mobile application that helps users track their outfits and avoid repeating the same dress in similar places or with the same people.

## Features

* Upload daily outfit photos
* Add descriptions, location, and people involved
* Store outfit history securely
* Detect previously worn similar outfits
* Notify users to avoid repeating outfits in the same context

## Tech Stack

* **Flutter** – Mobile application development
* **Supabase** – Backend, authentication, and database
* **Riverpod / Providers** – State management

## How It Works

1. User uploads an outfit image with details.
2. The app stores the information in the database.
3. When a new outfit is uploaded, the system checks past entries.
4. If a similar outfit was worn in a similar context, the app notifies the user.

## Project Structure

```
lib/
 ├ core/
 ├ features/
 │   ├ auth/
 │   └ outfit/
 ├ home/
 ├ shared/
 └ main.dart
```

## Future Improvements

* AI-based outfit similarity detection
* Image-based outfit recognition
* Smart outfit recommendations

## Author

Muhammad Awais
