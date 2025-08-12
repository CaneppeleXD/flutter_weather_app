# Basic Flutter Weather Application

## Introduction
The application developed here focused on the principles of the Flutter framework according to their documentation [1]. Alongside that, this experiment focused a lot on making the application web-friendly; therefore, all routing and navigation are done using the library goRouter [2] as recommended by the Flutter documentation. Together with that, the Home route is protected using the redirect property of goRouter, which, although the user still can bypass it if they want, allows for better usability since if a user accesses a page that needs authentication, the application will redirect them to the login page if they are not authenticated.

## Structure
The application follows a basic structure; in the beginning, the user may sign out or sign up, and after authentication, they are presented with their current temperature at their location; if they have not allowed for their location, the application will fail gracefully, displaying a message on the page. In addition to that, the reader may notice that OOP was used where possible, and also complex logics such as requesting user location and weather were placed in specific services for better understanding by other developers.

## Authentation
The authentication provider being used in this application is Supabase through their official Flutter API [3]. The user can sign up and sign in with email and password; due to the limited scope of this application, the email confirmation functionality made available by Supabase was not implemented

## Difficulties during development
Although the author of this project had already developed other applications using the Flutter Framework, all of those were very limited in scope and had one or two pages with no more than 4 widgets on them. Together with that, the large prior experience of the author with Web frameworks was not very useful here due to the big differences between designing styles in the Flutter framework compared to major web frameworks like Angular, React, and Vue.

## Improvements
The major improvement point for this project is on the Home page, which displays the Weather. Although it correctly displays the weather in a pleasant and pretty manner, its code is all concentrated on one Widget. The work to segregate this big Widget into smaller ones is not hard, but due to time constraints, this project focused on other bits, such as documenting. Another thing that could be improved, also in the Home page, is the Skeleton Widget; due to lack of knowledge on more advanced concepts of the framework, this project requested an LLM to generate the code for the Skeleton and, although minor adjustments were made to the generated code, it is still necessary to refactore it to increase its readability and coerence with the rest of the code. Last, but not least, it would be necessary to have a back-end to ensure safe access to the OpenWeather API because currently, the API ID can be publicly accessible by the user, even though this project is using environment variables to load them at runtime.

## Running Instructions

- Configured .env file
- Execute ``` flutter pub get ```
- Execute ``` flutter run ```

## References
 - [1] https://docs.flutter.dev/get-started/codelab
 - [2] https://pub.dev/documentation/go_router/latest/topics/Navigation-topic.html
 - [3] https://supabase.com/docs/reference/dart/introduction

## Demonstration Video
https://youtu.be/PPa7nbJLpgk