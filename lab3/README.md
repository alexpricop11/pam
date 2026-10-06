# Laboratorul 3 — Varianta 4

Aplicație Flutter pentru învățare, cu Cubit (flutter_bloc), date JSON locale încărcate asincron și componente reutilizabile.

Proiectul lab2 rămâne separat, fiind deja prezentat. În lab3, interfețele statice sunt înlocuite cu widgeturi interactive, păstrând tema albastru/portocaliu. A doua pagină este acum Course Overview, conform fișierului primit.

## Rulare

Din D:\pam\lab3:

    flutter pub get
    flutter run -d chrome

Pentru Android: pornește emulatorul, apoi execută flutter run.
Proiectul include și suport Windows; compilarea necesită uneltele desktop Flutter.

## Arhitectură

- assets/data/lab_v4.json — copie nemodificată a fișierului furnizat.
- lib/models/learning_data.dart — modele HomeData, LearningPlan, Course și Lesson.
- lib/repositories/learning_repository.dart — Future, async/await, rootBundle.loadString și jsonDecode; repository injectabil pentru teste.
- lib/cubit/learning_cubit.dart — starea aplicației și logica de căutare, filtrare, sortare, favorite, progres și înscriere.
- lib/screens/ — Home, Course Overview, Lesson details.
- lib/widgets/ — componente comune, mesaje pentru stări și carduri de lecții.
- lib/theme/ — tema preluată din laboratorul 2.

Flux: JSON → Repository → Cubit → BlocBuilder → UI.
BlocProvider este deasupra MaterialApp, astfel încât paginile împart aceeași stare.
setState este folosit numai pentru tabul vizual Lessons/Description.

## Cerințe implementate

- Loading: indicator în timpul citirii asincrone.
- Success: afișarea datelor și a listei de lecții.
- Empty: listă goală ori nicio potrivire, cu resetarea filtrelor.
- Error: mesaj și Try again pentru reîncărcare.
- Căutare după titlul lecției, fără diferențiere între majuscule/minuscule.
- Filtre All, Available, Locked, Completed și Favorites, combinabile cu căutarea.
- Sortare după ordinea originală, titlu, durată crescătoare sau descrescătoare.
- Adăugare/eliminare din favorite atât în listă, cât și în detalii.
- Navigare Home → Course Overview → Lesson details.
- Marcarea lecțiilor deblocate drept finalizate; lecțiile blocate rămân blocate.
- Enroll Now actualizează starea locală de înscriere.
- Pull-to-refresh pe Home și protecție contra răspunsurilor asincrone depășite.
- Layout adaptabil, listă derulabilă, tooltip-uri și imagine alternativă dacă încărcarea imaginii eșuează.

## Particularitățile datelor primite

Fișierul conține un singur curs, deci operațiile asupra listei se aplică lecțiilor.
Metadatele indică 7 lecții, dar sunt furnizate efectiv 4. Interfața arată separat numărul declarat și numărul de lecții furnizate.
Eticheta imaginii este SPOKEN ENGLISH, deși titlul cursului este React Front To back; ambele sunt păstrate din sursă.
Descrierea este goală și nu există URL-uri video. Aplicația afișează un mesaj explicit; nu simulează redarea unui video.
Datele sunt locale. Imaginea decorativă a cursului folosește URL-ul din JSON și are fallback offline.
Favoritele, progresul și înscrierea sunt păstrate în memorie în sesiunea curentă; se resetează la repornirea aplicației. Nu există plată sau înscriere pe un server.

## Scenariu de prezentare

1. Deschide aplicația și explică încărcarea JSON prin repository.
2. Apasă My courses: se deschide a doua pagină actualizată.
3. Caută Introduction, apoi un text inexistent pentru a demonstra Empty și Reset filters.
4. Combină filtrul Available cu Favorites și sortează după durată.
5. Adaugă o lecție la favorite, deschide detaliile și marcheaz-o finalizată.
6. Revino la listă și verifică filtrul Completed.
7. Deschide lecția blocată: finalizarea este dezactivată.
8. Verifică tabul Description și butonul Enroll Now.
9. Explică Error și retry folosind testul cu repository controlat.

## Verificare

    flutter analyze
    flutter test
    flutter build web

Testele verifică încărcarea și schema, erori, retry, răspunsuri concurente, lista goală, operațiile combinate asupra lecțiilor, navigarea și layout-ul la 320, 768 și 1440 pixeli.

Documentația pachetului: https://pub.dev/packages/flutter_bloc
