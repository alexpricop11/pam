# Laborator 1 — Calculator salariu

Aplicație Flutter pentru varianta 5. Introdu salariul brut, selectează tipul de impozitare și apasă Calculează.

Cotele sunt fictive: standard 12%, redusă 6%, scutit 0%.
Impozit = brut × cotă / 100; net = brut − impozit.
Se acceptă punctul sau virgula pentru zecimale și valori pozitive.
Modificarea datelor șterge rezultatul vechi până la următorul calcul.

## Organizare

- `lib/main.dart`: pornirea aplicației și tema.
- `lib/salary_calculator_screen.dart`: interfața și evenimentele.
- `lib/salary_calculator_widgets.dart`: formularul și cardul rezultatului.
- `lib/salary_calculator.dart`: tipurile de impozitare, validarea și calculul.
- `test/widget_test.dart`: teste simple.

## Comenzi

```sh
flutter pub get
flutter run
flutter analyze
flutter test
```
