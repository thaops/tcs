# Feature Brick (GetX + Clean Architecture)

Generates a feature scaffold following Clean Architecture with GetX for presentation.

## Setup (project root)

```bash
# from project root (where mason.yaml exists)
mason get
```

## Use

```bash
mason make feature --name user_profile --scope private_app_shell
```

This will create:

```
lib/feature/<scope>/<feature>/
  data/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  binding/
  logic/
  view/
  widget/
  index.dart
  <feature>_routes.dart
```
