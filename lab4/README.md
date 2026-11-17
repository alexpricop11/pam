# Laboratorul 4 — Varianta 4

Aplicație Flutter cu servicii Web REST prin HTTP, serializare/deserializare JSON și Clean Architecture. Designul, culorile, ecranele și funcțiile laboratorului 3 sunt păstrate. Proiectul este separat în `lab4`.

## Rulare

Din `D:\\pam\\lab4`:

```powershell
flutter pub get
flutter run -d chrome
```

Pentru Android, pornește emulatorul și execută `flutter run`. Permisiunea INTERNET este declarată în manifestul principal, inclusiv pentru release. Proiectul include Android, web și Windows.

## API folosit

Varianta 4 corespunde laboratorului precedent:

- GET https://test-api-jlbn.onrender.com/lab2026/v4/feed — header, progres zilnic, planuri, invitație la învățare și meetup.
- GET https://test-api-jlbn.onrender.com/lab2026/v4/feed/details — curs, imagine, metadate, lecții, descriere și etichetele acțiunilor.

Ambele cereri pornesc concurent; rezultatul este afișat după primirea și validarea ambelor răspunsuri. Datele aplicației provin exclusiv din API. Fișierul din `test/fixtures` este folosit numai pentru testele automate și nu este înregistrat ca asset.

Serverul poate avea nevoie de timp la prima pornire. Timeout-ul este 60 de secunde pentru fiecare cerere. Aplicația gestionează răspunsurile HTTP nereușite, lipsa conexiunii, timeout, JSON invalid și schema incompletă, afișând un mesaj și butonul Try again.

## Organizare Clean Architecture

```text
lib/
  main.dart                         # compunerea și injectarea dependențelor
  core/network/api_client.dart      # HTTP, timeout, status codes, jsonDecode
  domain/
    entities/learning_data.dart     # obiecte independente de Flutter și HTTP
    repositories/                  # contractul LearningRepository
    usecases/get_learning_data.dart
    failures/                      # eroare transmisă către prezentare
  data/
    datasources/                   # endpointurile REST
    models/learning_models.dart    # fromJson, toJson, toEntity
    repositories/                  # implementarea contractului Domain
  presentation/
    cubit/                         # stări și logica interacțiunilor
    screens/                       # Home, Course Overview, Lesson details
    widgets/                       # componente comune reutilizabile
    theme/                         # tema laboratorului precedent
```

Domain nu importă Flutter, HTTP sau Data. Presentation depinde de Domain prin cazul de utilizare. Data implementează contractul Domain. Doar `main.dart` cunoaște implementările concrete și construiește dependențele. Clientul HTTP este închis la eliminarea aplicației.

## Fluxul datelor pentru prezentare

1. `LearningApp` creează clientul HTTP, sursa remote, repository-ul și `GetLearningData`, injectate în `LearningCubit`.
2. Cubit emite Loading și apelează cazul de utilizare.
3. Cazul de utilizare apelează contractul `LearningRepository.load()`.
4. Implementarea din Data cere cele două resurse prin sursa remote și `ApiClient`.
5. Serverul răspunde cu JSON; clientul verifică statusul HTTP și decodează UTF-8/JSON.
6. Modelele Data deserializează câmpurile cu `fromJson`, apoi `toEntity` construiește obiectele Domain. `toJson` permite serializarea înapoi, verificată prin teste.
7. Repository-ul întoarce `LearningData`; Cubit emite Success sau Empty.
8. `BlocBuilder` reconstruiește interfața. La eroare, Cubit emite Error, iar Try again repetă fluxul.

Reîncărcarea prin tragere pe Home execută din nou cererile HTTP. Un contor de cereri împiedică un răspuns vechi să suprascrie unul nou, iar finalizarea după închiderea Cubit-ului nu emite stări.

## Funcționalități

- Stări Loading, Success, Empty și Error, plus retry.
- Home → Course Overview → Lesson details și navigare înapoi.
- Căutare, filtre All/Available/Locked/Completed, favorite și sortare.
- Marcarea lecțiilor disponibile ca finalizate și înscriere locală.
- Componente reutilizabile: SectionCard, LoadGate, StatusMessage, FavoriteButton, LessonTile și ContentWidth.
- Layout adaptabil, liste derulabile și imagine alternativă dacă încărcarea imaginii eșuează.

Endpointurile furnizate sunt utilizate pentru citire. Favoritele, finalizarea și înscrierea modifică numai starea sesiunii curente în memorie; nu se trimit actualizări la server și nu există plată. Serializarea nu implică inventarea unor endpointuri de scriere.

Metadatele API declară 7 lecții, dar lista conține 4. Ambele numere sunt păstrate și afișate distinct. Descrierea goală are mesaj explicit. API-ul nu furnizează conținut video; aplicația permite urmărirea progresului. Eticheta SPOKEN ENGLISH și titlul React Front To back sunt preluate din date.

## Verificare

```powershell
flutter analyze
flutter test
flutter build web
dart run tool/smoke_api.dart
```

Testele folosesc un client HTTP simulat și fixture-uri pentru rezultate reproductibile, fără dependență de disponibilitatea serverului. Acoperă endpointurile și metoda GET, maparea și serializarea JSON, erori HTTP, timeout, conexiune, răspunsuri invalide, retry, concurență, stări goale, căutare/filtre/sortare/favorite/progres, navigare și layout la 320, 768 și 1440 pixeli.

`tool/smoke_api.dart` verifică separat ambele endpointuri reale și deserializarea lor; necesită internet.
