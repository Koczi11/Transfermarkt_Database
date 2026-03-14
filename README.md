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
