# Basic Flutter Weather Application

## Introduction
The application developed here focused on the principles of the Flutter framework accordinly to their documentation [1]. Along side that, this experiment focused a lot on making the application web friendly, therefore, all routing and navegation is done using the library goRouter [2] as reccommended by the Flutter documentation. Together with that, the Home route is protected using the redict property of goRouter which, althoug the user still can bypass it if they really want, it allows for better usability since if a user accessess a page that needs authentication, the application will redirect them to the login page if they are not authenticated.

## Structure
The application follows a basic structure; in the beggining the user may sign-in out sign-up and after authentication they are presented with their current temperature on their location; if they did not allow for their location, the application will fail greatfully displaying a message on the page. In addition to that, the reader may notice that OOP was used where possible and also complex logics such as requesting user location and weather were placed in specific services for better understanding by other developers.

## Authentation
The authentication provider being used in this application is Supabase through their official Flutter API [3]. The user can sign-up and sign-in with email and password; due to the limited scope of this application, the email confirmation functionality made available by Supabase was not implemented

## Difficulties during development
Although the author of this project had already developed other applications using the Flutter Framework, all of those were very limited in scope and had one or two pages with no more than 4 widgets on it. Together with that, the large prior experience of the author with Web frameworks was not very useful here due to the big differences between designing styles in the Flutter framework compared to major web frameworks like Angular, React and Vue.

## Improvements
The major improvement point for this project is on the Home page that displays the Weather. Although it correctly displays the weather on a pleasent and pretty manner, its code is all concentrated on one Widget. The work to segregate this big Widget into smaller ones is not hard, but due to time constraints, this project focused on other bits such as documenting. Another thing that could be improved, also in the Home page, is the Skeleton Widget; due to lack of knowledge on more advanced concepts of the framework, this project requested an LLM to generate the code for the Skeleton and, although minor adjustments were made to the generated code, it is still necessary to refactore it in order to increase its readability and coerence with the rest of the code. For last, but not last, it would be necessary a back-end to ensure safe access to the Openweather API because currently the API ID can be public accessible by the user even though this project is using environment variables to load them at runtime.

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