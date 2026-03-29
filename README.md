# Transfermarkt

## Opis Projektu
Projekt ten to w pełni funkcjonalna, relacyjna baza danych wzorowana na popularnym serwisie Transfermarkt. System służy do zarządzania informacjami o świecie piłki nożnej: od zawodników, trenerów i klubów, przez statystyki meczowe, kontrakty, aż po śledzenie skomplikowanych transferów. Baza uwzględnia również system ról (użytkownicy i administratorzy z różnymi poziomami uprawnień) oraz funkcje społecznościowe (ulubione kluby, zawodnicy i ligi).

## Struktura Bazy Danych
Projekt składa się z kilkunastu powiązanych ze sobą tabel. Główne obszary domeny to:
* **Użytkownicy i Uprawnienia:** Tabele `user`, `admin`, `admin_permissions` oraz tabele preferencji.
* **Kluby i Ligi:** Tabele `club`, `league`, `club_stats`, `club_trophy`, `trophy`.
* **Personalia:** Tabele `player`, `coach`, `oldboys`.
* **Kontrakty i Transfery:** Tabele `player_contract`, `coach_contract`, `transfer`.
* **Rozgrywki:** Tabele `match`, `player_match_stats`.

## Zastosowane Technologie i Zaawansowane Mechanizmy SQL
W projekcie zaimplementowano szereg zaawansowanych mechanizmów silnika MariaDB/MySQL w celu optymalizacji i automatyzacji działania systemu:

* **Wyzwalacze (Triggers):** Automatyzacja logiki biznesowej. Triggery `OLD_PLAYER_INSERT` oraz `OLD_PLAYER_UPDATE` automatycznie przenoszą lub aktualizują dane zawodników powyżej 40 roku życia w specjalnej tabeli `oldboys`.
* **Funkcje (Functions):** Zhermetyzowane algorytmy do obliczeń finansowych i statystycznych (np. `calculate_manager_fee`, `TransferTax`, `calculate_goals_per_90`). Funkcje wykorzystują wbudowane mechanizmy obsługi wyjątków (Exception Handlers).
* **Procedury Składowane (Stored Procedures):** Zautomatyzowane procesy modyfikacji danych, np. `update_player_value` do bezpiecznej aktualizacji wartości rynkowej zawodnika.
* **Partycjonowanie Tabel (Table Partitioning):** Tabela `oldboys` jest partycjonowana metodą RANGE na podstawie roku urodzenia zawodników (partycje dekadowe), co znacznie przyspiesza przeszukiwanie danych historycznych.
* **Wersjonowanie Systemowe (System-Versioned Temporal Tables):** Włączone dla tabel `transfer` oraz `admin`. Pozwala na śledzenie pełnej historii zmian (np. kwot transferowych) i zapytania typu "stan na dany moment w przeszłości" (tzw. Time Travel SQL).
* **Wydarzenia (Events):** Skonfigurowany event `admin_check`, który uruchamia się cyklicznie co 24 godziny.
* **Wyszukiwanie Pełnotekstowe (Full-Text Search):** Indeksy `FULLTEXT` założone na nazwy klubów oraz nazwiska zawodników, umożliwiające szybkie i zaawansowane wyszukiwanie tekstowe.
* **Zaawansowane Zapytania (DQL):** Zapisane w tabeli `!shared_queries` przykłady użycia wyrażeń tablicowych (CTE), zapytań rekurencyjnych (np. śledzenie pełnej ścieżki transferowej zawodnika) oraz funkcji okna (Window Functions) do tworzenia rankingów.

<br>

--- 

## English Version

## Project Description
This project is a fully functional relational database modeled on the popular Transfermarkt website. The system is used to manage information about the world of football: from players, coaches and clubs, through match statistics and contracts, to tracking complex transfers. The database also incorporates a role system (users and administrators with varying privilege levels) and social features (favorite clubs, players and leagues).

## Database Structure
The project consists of over a dozen interconnected tables. The main domain areas are:
* **Users and Permissions:** `user`, `admin`, `admin_permissions` tables and preference tables.
* **Clubs and Leagues:** `club`, `league`, `club_stats`, `club_trophy`, `trophy` tables.
* **Personnel:** `player`, `coach`, `oldboys` tables.
* **Contracts and Transfers:** `player_contract`, `coach_contract`, `transfer` tables.
* **Competitions:** `match` and `player_match_stats` tables.

## Technologies Used and Advanced SQL Mechanisms
The project implements a range of advanced MariaDB/MySQL engine mechanisms to optimize and automate the system's operations:

* **Triggers:** Automation of business logic. The `OLD_PLAYER_INSERT` and `OLD_PLAYER_UPDATE` triggers automatically move or update data of players over 40 years old in a dedicated `oldboys` table.
* **Functions:** Encapsulated algorithms for financial and statistical calculations (e.g. `calculate_manager_fee`, `TransferTax`, `calculate_goals_per_90`). The functions utilize built-in Exception Handlers.
* **Stored Procedures:** Automated data modification processes, e.g. `update_player_value` for safe updates of a player's market value.
* **Table Partitioning:** The `oldboys` table is partitioned using the RANGE method based on the players' birth years (decadal partitions), which significantly speeds up historical data retrieval.
* **System-Versioned Temporal Tables:** Enabled for the `transfer` and `admin` tables. This allows for tracking the full history of changes (e.g. transfer amounts) and executing queries for the state as of a specific moment in the past (so-called Time Travel SQL).
* **Events:** A configured `admin_check` event that runs cyclically every 24 hours.
* **Full-Text Search:** `FULLTEXT` indexes applied to club names and player surnames, enabling fast and advanced text searching.
* **Advanced Queries (DQL):** Saved in the `!shared_queries` table are examples of using Common Table Expressions (CTE), recursive queries (e.g. tracking a player's full transfer path) and Window Functions to create rankings.


