% This file is encoded in UTF-8.

% Φόρτωση εξωτερικών πληροφοριών δεν γίνεται, θεωρείται ότι έγιναν από main.pl.

/* ---------------------------------------------------------------------------------- *|
|* -- Εύρεση διαμερίσματος που ικανοποιούν τις απαιτήσεις του υποψήφιου ενοικιαστή -- *|
|* ---------------------------------------------------------------------------------- */ 

%% satisfies_rent_requirements/11
%% satisfies_rent_requirements(At_Center, Max_Rent_Center,Floor_Area, Min_Area, Max_Rent_Suburbs, Bonus_Area, Garden_Area, Bonus_Garden, Max_Rent, Rent, Max_Rent).
%% Επιτυγχάνει αν ικανοποιεί απαιτήσεις σχετικά με το ενοίκιο δεδομένου ότι είναι στα προάστια ή όχι.
%% Επιπλέον, επιστρέφει το μέγιστο ποσό που είναι διατίθεται ο ενοικιαστής να δώσει για αυτό το σπίτι.
 
% Αν βρίσκεται στο κέντρο.
satisfies_rent_requirements(yes, Max_Rent_Center, Floor_Area, Min_Area, _, Bonus_Area, Garden_Area, Bonus_Garden, Max_Rent, Rent, New_Limited_Max_Rent) :- 
    % Υπολογισμός του μέγιστου ποσού που διατίθεται να πληρώσει με συνυπολογισμό των επιπλέον τετραγωνικών και κήπου.
    New_Max_Rent_Center is Max_Rent_Center + Bonus_Area * (Floor_Area - Min_Area) + Bonus_Garden * Garden_Area,

    % Το Max_Rent μας δίνει το άνω όριο διαθέσιμου ποσού, δηλαδή το "νέο" μέγιστου ποσού πρέπει να περιοριστεί βάσει του άνω ορίου.
    New_Limited_Max_Rent is min(New_Max_Rent_Center, Max_Rent),

    % Το ενοίκιο του διαμερίσματος πρέπει να είναι μικρότερο ή ίσο από το μέγιστο του διαθέσιμου ποσού που διατίθεται να δώσει ενώ παράλληλα το νέο μέγιστο να είναι.
    New_Limited_Max_Rent >= Rent.

% Αν βρίσκεται στα προάστια.
satisfies_rent_requirements(no, _, Floor_Area, Min_Area, Max_Rent_Suburbs, Bonus_Area, Garden_Area, Bonus_Garden, Max_Rent, Rent, New_Limited_Max_Rent) :- 
    % Υπολογισμός του μέγιστου ποσού που διατίθεται να πληρώσει με συνυπολογισμό των επιπλέον τετραγωνικών και κήπου.
    New_Max_Rent_Suburbs is Max_Rent_Suburbs + Bonus_Area * (Floor_Area - Min_Area) + Bonus_Garden * Garden_Area,

    % Το Max_Rent μας δίνει το άνω όριο διαθέσιμου ποσού, δηλαδή το "νέο" μέγιστου ποσού πρέπει να περιοριστεί βάσει του άνω ορίου.
    New_Limited_Max_Rent is min(New_Max_Rent_Suburbs, Max_Rent),

    % Το ενοίκιο του διαμερίσματος πρέπει να είναι μικρότερο ή ίσο από το μέγιστο του διαθέσιμου ποσού που διατίθεται να δώσει ενώ παράλληλα το νέο μέγιστο να είναι.
    New_Limited_Max_Rent >= Rent.

%% compatible_house/9
%% compatible_house(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House, Max_Rent).
%% Επιτυγχάνει για διαμέρισμα με διεύθυνση House_Address, το οποίο ικανοποιεί τους δοθέντες περιορισμούς.
%% Το "Max_Rent" περιέχει το μέγιστο ποσό (ενοίκιο) που είναι διατίθεται ο ενοικιαστής να δώσει για αυτό το σπίτι.

compatible_house(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House, Max_Rent) :-
    % "Δίνω" τιμές στις μεταβλητές που αργότερα θα ελέγξω.
    house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent),

    % Απαιτήσεις σχετικά με το διαμέρισμα.
    Sleeping_Quarters >= Min_Sleeping_Quarters,
    Floor_Area >= Min_Area,
    (Floor < Elevator_Limit ; Has_Elevator == yes),
    Allows_Pets == Requires_Pets,

    % Απαιτήσεις σχετικά με το ενοίκιο.
    satisfies_rent_requirements(At_Center, Max_Rent_Center,Floor_Area, Min_Area, Max_Rent_Suburbs, Bonus_Area, Garden_Area, Bonus_Garden, Max_Rent, Rent, Max_Rent),
    House = house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent).

%% compatible_houses/8
%% compatible_houses(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House_List).
%% Βρίσκει και επιστρέφει μία λίστα με τα σπίτια που ικανοποιούν τις απαιτήσεις του ενοικιαστή.
compatible_houses(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House_List) :-
    findall(House, compatible_house(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House, _Max_Rent), House_List).


%% compatible_houses_w_maxrent/9
%% compatible_houses(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House_List, Maxrent_List).
%% Βρίσκει και επιστρέφει μία λίστα με σπίτια που ικανοποιούν τις απαιτήσεις του ενοικιαστή (House_List). 
%% Παράλληλα, επιστρέφει και λίστα (Maxrent_List) με ζεύγη σπιτιών και μεγίστου διατιθέμενου ενοικίου για αυτά, τα οποία ικανοποιούν τις απαιτήσεις του ενοικιαστή. Τα ζεύγη που περιέχει η λίστα έχουν την μορφή
%% house_maxrent(House, Max_Rent).
compatible_houses_w_maxrent(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House_List, Maxrent_List) :-
    % Βρίσκω όλα τα σπίτια και τα μέγιστα διατιθέμενα ενοίκια.
    findall(house_maxrent(House, Max_Rent), compatible_house(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House, Rent, Max_Rent), House_Maxrent_List),

    % Βρίσκω όλα τα συμβατά σπίτια από τα ζεύγη.
    findall(House, select(house_maxrent(House, _Max_Rent), House_Maxrent_List, _Rest), House_List).


/* ----------------------------------------------- *|
|* -- Εύρεση φθηνότερων διαμερισμάτων απο λίστα -- *|
|* ----------------------------------------------- */ 

%% find_cheaper_aux/4
%% find_cheaper_aux(House_List, Min_Rent, Temp_Cheapest_House_List, Cheapest_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια και το ελάχιστο νοίκι αυτών (House_List, Min_Rent) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με το φτηνότερο ενοίκιο (Cheapest_House_List) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το φτηνότερο ενοίκιο). Η μεταβλητή Temp_Cheapest_House_List περιέχει προσωρινά τα σπίτια με το ελάχιστο ενοίκιο για λόγους απόδοσης μνήμης.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, προφανώς, είναι φθηνότερο (της λίστας) δεδομένου ότι έχει νοίκι το όρισμα και προστίθεται στην λίστα ελαχίστων.
find_cheaper_aux([X], Min_Rent, Temp_Cheapest_House_List, [X | Temp_Cheapest_House_List]) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent),
    Rent =:= Min_Rent.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, προφανώς, δεν είναι φθηνότερο (της λίστας) δεδομένου ότι δεν έχει νοίκι το όρισμα.
find_cheaper_aux([X], Min_Rent, Temp_Cheapest_House_List, Temp_Cheapest_House_List) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent),
    Rent =\= Min_Rent.

% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή έχει τιμή ελαχίστου ενοικίου.
find_cheaper_aux([X | Tail], Min_Rent, Temp_Cheapest_House_List, Min_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent),
    Rent =:= Min_Rent,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το ελάχιστο ενοίκιο αποτελείται από αυτό το στοιχείο (εφόσον διαπιστώθηκε ως ελάχιστο) και
    % των ελαχίστων της υπόλοιπης λίστας.
    find_cheaper_aux(Tail, Min_Rent, [X | Temp_Cheapest_House_List],  Min_Houses).
    

% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή έχει τιμή ελαχίστου ενοικίου.
find_cheaper_aux([X | Tail], Min_Rent, Temp_Cheapest_House_List, Min_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent),
    Rent =\= Min_Rent,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το ελάχιστο ενοίκιο αποτελείται μόνο (εφόσον διαπιστώθηκε ως μή ελάχιστο) των ελαχίστων της υπόλοιπης λίστας.
    find_cheaper_aux(Tail, Min_Rent, Temp_Cheapest_House_List, Min_Houses).


%% cheapest_house/3
%% cheapest_house(X, Y, Cheapest).
%% Δέχεται σαν είσοδο δύο σπίτια (X, Y) και "επιστρέφει" εκείνο με το μικρότερο ενοίκιο (Cheapest).

% Περίπτωση X =< Y.
cheapest_house(X, Y, X) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, X_Rent),

    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    Y = house(_, _, _, _, _, _, _, _, Y_Rent),

    X_Rent =< Y_Rent.


% Περίπτωση X > Y.
cheapest_house(X, Y, Y) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, X_Rent),

    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    Y = house(_, _, _, _, _, _, _, _, Y_Rent),

    X_Rent > Y_Rent.


%% find_cheapest_rent/2
%% find_cheapest_rent(House_List, Cheapest_Rent).
%% Παίρνει ως είσοδο μια λίστα από σπίτια (House_List) και επιστρέφει το ελάχιστο νοίκι αυτών (Cheapest_Rent).
%% Σημείωση: Στην κορυφή της λίστας αποθηκεύεται το προσωρινό ελάχιστο για λόγους απόδοσης.

% Περίπτωση με κενή λίστα για λόγους συμβατότητας με αυτή.
% "Επιστρέφεται" -1 λόγω (αυθάιρετης) σύμβασης.
find_cheapest_rent([], -1).

% Τερματική συνήκη: Άν έχω ένα στοιχείο, τότε αυτό είναι ελάχιστο.
find_cheapest_rent([X], Rent) :- 
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent).

% Αναδρομικός κανόνας: Αν έχω πάνω από ένα στοιχείο, τότε θα συγκρίνω τα δύο κορυφαία και θα "κρατήσω" ως νέα κορυφή το ελάχιστο, απορρίπτοντας το άλλο.
find_cheapest_rent([X, Y | Tail], Cheapest_Rent) :- 
    % Εύρεση του φθηνότερου σπιτιού.
    cheapest_house(X, Y, Z),

    % Αναδρομικός κανόνας.
    find_cheapest_rent([Z | Tail], Cheapest_Rent).

%% find_cheaper/2
%% find_cheaper(House_List, Cheapest_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια (House_List) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με το φτηνότερο ενοίκιο (Cheapest_House_List) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το φτηνότερο ενοίκιο).

% Αν έχω λίστα με ένα κανένα σπίτι, τότε, προφανώς, δεν υπάρχει φθηνότερο (της λίστας).
% Ορίζεται για λόγους συμβατότητας με κενή λίστα (αν το δούμε με την λογική ότι "αφαιρεί τα όχι φτηνότερα σπίτια", η κενή λίστα είναι συμβατή).
find_cheaper([], []).

find_cheaper(House_List, Cheapest_House_List) :-
    find_cheapest_rent(House_List, Min_Rent),
    find_cheaper_aux(House_List, Min_Rent, [], Cheapest_House_List).



/* ------------------------------------------------------- *|
|* -- Εύρεση διαμερισμάτων με μεγαλύτερο κήπο από λίστα -- *|
|* ------------------------------------------------------- */ 

%% find_biggest_garden_aux/4
%% find_biggest_garden_aux(House_List, Max_Garden_Area, Temp_Biggest_Garden_House_List, Biggest_Garden_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια και το μέγιστο εμβαδόν κήπου (House_List, Max_Garden_Area) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με τον μεγαλύτερο κήπο (Biggest_Garden_House_List) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το μεγαλύτερο κήπο). Η μεταβλητή Temp_Biggest_Garden_House_List περιέχει προσωρινά τα σπίτια με το μεγαλύτερο κήπο για λόγους απόδοσης μνήμης.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, προφανώς, είναι εκείνο με τον μεγαλύτερο κήπο (της λίστας) δεδομένου ότι έχει όρισμα το μέγεθος του κήπου
% και προστίθεται στην λίστα αποτελέσματος.
find_biggest_garden_aux([X], Max_Garden_Area, Temp_Biggest_Garden_House_List, [X | Temp_Biggest_Garden_House_List]) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, Garden_Area, _),
    Garden_Area =:= Max_Garden_Area.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, δεν είναι εκείνο με τον μεγαλύτερο κήπο (της λίστας) αν δεν έχει όρισμα το μέγιστο μέγεθος του κήπου
% και δεν προστίθεται στην λίστα αποτελέσματος.
find_biggest_garden_aux([X], Max_Garden_Area, Temp_Biggest_Garden_House_List, Temp_Biggest_Garden_House_List) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, Garden_Area, _),
    Garden_Area =\= Max_Garden_Area.

% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή έχει τον μεγαλύτερο κήπο.
find_biggest_garden_aux([X | Tail], Max_Garden_Area, Temp_Biggest_Garden_House_List, Max_Garden_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, Garden_Area, _),
    Garden_Area =:= Max_Garden_Area,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το μεγαλύτερο κήπο αποτελείται από αυτό το στοιχείο (εφόσον διαπιστώθηκε ως ελάχιστο) και
    % των ελαχίστων της υπόλοιπης λίστας.
    find_biggest_garden_aux(Tail, Max_Garden_Area, [X | Temp_Biggest_Garden_House_List],  Max_Garden_Houses).


% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή έχει τον μεγαλύτερο κήπο.
find_biggest_garden_aux([X | Tail], Max_Garden_Area, Temp_Biggest_Garden_House_List, Max_Garden_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, Garden_Area, _),
    Garden_Area =\= Max_Garden_Area,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με τον μεγαλύτερο κήπο αποτελείται μόνο (εφόσον διαπιστώθηκε ως μή ελάχιστο) των ελαχίστων της υπόλοιπης λίστας.
    find_biggest_garden_aux(Tail, Max_Garden_Area, Temp_Biggest_Garden_House_List, Max_Garden_Houses).


%% biggest_garden_house/3
%% biggest_garden_house(X, Y, Z).
%% Δέχεται σαν είσοδο δύο σπίτια (X, Y) και "επιστρέφει" εκείνο με τον μεγαλύτερο κήπο (Z).

% Περίπτωση X =< Y.
biggest_garden_house(X, Y, X) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, X_Garden_Area, _),

    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    Y = house(_, _, _, _, _, _, _, Y_Garden_Area, _),

    X_Garden_Area >= Y_Garden_Area.


% Περίπτωση X > Y.
biggest_garden_house(X, Y, Y) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, X_Garden_Area, _),

    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    Y = house(_, _, _, _, _, _, _, Y_Garden_Area, _),

    X_Garden_Area < Y_Garden_Area.


%% find_biggest_garden_area/2
%% find_biggest_garden_area(House_List, Biggest_Garden_Area).
%% Παίρνει ως είσοδο μια λίστα από σπίτια (House_List) και επιστρέφει την μέγιστο εμβαδόν κήπου (τετραγωνικά) αυτών (Biggest_Garden_Area).
%% Σημείωση: Στην κορυφή της λίστας αποθηκεύεται το προσωρινό μέγιστο για λόγους απόδοσης.

% Περίπτωση με κενή λίστα για λόγους συμβατότητας με αυτή.
% "Επιστρέφεται" -1 λόγω (αυθάιρετης) σύμβασης.
find_biggest_garden_area([], -1).

% Τερματική συνήκη: Άν έχω ένα στοιχείο, τότε αυτό είναι ελάχιστο.
find_biggest_garden_area([X], Garden_Area) :- 
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, Garden_Area, _).

% Αναδρομικός κανόνας: Αν έχω πάνω από ένα στοιχείο, τότε θα συγκρίνω τα δύο κορυφαία και θα "κρατήσω" ως νέα κορυφή το ελάχιστο, απορρίπτοντας το άλλο.
find_biggest_garden_area([X, Y | Tail], Biggest_Garden_Area) :- 
    % Εύρεση του φθηνότερου σπιτιού.
    biggest_garden_house(X, Y, Z),

    % Αναδρομικός κανόνας.
    find_biggest_garden_area([Z | Tail], Biggest_Garden_Area).


%% find_biggest_garden/2
%% find_biggest_garden_aux(House_List, Biggest_Garden_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια (House_List, ) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με τον μεγαλύτερο κήπο (Biggest_Garden_House_List) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το μεγαλύτερο κήπο).

% Αν έχω λίστα με ένα κανένα σπίτι, τότε, προφανώς, δεν υπάρχει εκείνο με τον μεγαλύτερο κήπο (της λίστας).
% Ορίζεται για λόγους συμβατότητας με κενή λίστα (αν το δούμε με την λογική ότι "αφαιρεί εκείνα με όχι τον μεγαλύτερο κήπο", η κενή λίστα είναι συμβατή).
find_biggest_garden([], []).

find_biggest_garden(House_List, Biggest_Garden_House_List) :-
    find_biggest_garden_area(House_List, Biggest_Garden_Area),
    find_biggest_garden_aux(House_List, Biggest_Garden_Area, [], Biggest_Garden_House_List).

/* ---------------------------------------------------------- *|
|* -- Εύρεση διαμερισμάτων με μεγαλύτερο εμβαδόν απο λίστα -- *|
|* ---------------------------------------------------------- */ 

%% find_biggest_house/4
%% find_biggest_house(House_List, Max_Area, Temp_Biggest_House_List, Biggest_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια και το μέγιστο εμβαδόν (House_List, Max_Area) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με το μεγαλύτερο εμβαδόν (Biggest_House_List) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το μεγαλύτερο κήπο). Η μεταβλητή Temp_Biggest_House_List περιέχει προσωρινά τα σπίτια με το μεγαλύτερο κήπο για λόγους απόδοσης μνήμης.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, προφανώς, είναι εκείνο με το μεγαλύτερο εμβαδόν (της λίστας) δεδομένου ότι έχει όρισμα το μέγεθος του κήπου
% και προστίθεται στην λίστα αποτελέσματος.
find_biggest_house([X], Max_Area, Temp_Biggest_House_List, [X | Temp_Biggest_House_List]) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, House_Area, _, _, _, _, _, _),
    House_Area =:= Max_Area.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, δεν είναι εκείνο με το μεγαλύτερο εμβαδόν (της λίστας) αν δεν έχει όρισμα το μέγιστο εμβαδόν
% και δεν προστίθεται στην λίστα αποτελέσματος.
find_biggest_house([X], Max_Area, Temp_Biggest_House_List, Temp_Biggest_House_List) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, House_Area, _, _, _, _, _, _),
    House_Area =\= Max_Area.

% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή έχει το μεγαλύτερο εμβαδόν.
find_biggest_house([X | Tail], Max_Area, Temp_Biggest_House_List, Max_Area_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, House_Area, _, _, _, _, _, _),
    House_Area =:= Max_Area,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το μεγαλύτερο κήπο αποτελείται από αυτό το στοιχείο (εφόσον διαπιστώθηκε ως ελάχιστο) και
    % των ελαχίστων της υπόλοιπης λίστας.
    find_biggest_house(Tail, Max_Area, [X | Temp_Biggest_House_List],  Max_Area_Houses).

    

% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή έχει το μεγαλύτερο εμβαδόν.
find_biggest_house([X | Tail], Max_Area, Temp_Biggest_House_List, Max_Area_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, House_Area, _, _, _, _, _, _),
    House_Area =\= Max_Area,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το μεγαλύτερο εμβαδόν αποτελείται μόνο (εφόσον διαπιστώθηκε ως μή ελάχιστο) των ελαχίστων της υπόλοιπης λίστας.
    find_biggest_house(Tail, Max_Area, Temp_Biggest_House_List, Max_Area_Houses).


%% house_with_biggest_area/3
%% house_with_biggest_area(X, Y, Z).
%% Δέχεται σαν είσοδο δύο σπίτια (X, Y) και "επιστρέφει" εκείνο με το μεγαλύτερο εμβαδόν (Z).

% Περίπτωση X < Y.
house_with_biggest_area(X, Y, X) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, X_House_Area, _, _, _, _, _, _),

    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    Y = house(_, _, Y_House_Area, _, _, _, _, _, _),

    X_House_Area >= Y_House_Area.


% Περίπτωση X > Y.
house_with_biggest_area(X, Y, Y) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, X_House_Area, _, _, _, _, _, _),

    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    Y = house(_, _, Y_House_Area, _, _, _, _, _, _),

    X_House_Area < Y_House_Area.


%% find_biggest_house_area/2
%% find_biggest_house_area(House_List, Biggest_House_Area).
%% Παίρνει ως είσοδο μια λίστα από σπίτια (House_List) και επιστρέφει την μέγιστη επιφάνεια (τετραγωνικά) αυτών (Biggest_House_Area).
%% Σημείωση: Στην κορυφή της λίστας αποθηκεύεται το προσωρινό μέγιστο για λόγους απόδοσης.

% Περίπτωση με κενή λίστα για λόγους συμβατότητας με αυτή.
% "Επιστρέφεται" -1 λόγω (αυθάιρετης) σύμβασης.
find_biggest_house_area([], -1).


% Τερματική συνθήκη: Άν έχω ένα στοιχείο, τότε αυτό είναι ελάχιστο.
find_biggest_house_area([X], House_Area) :- 
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, House_Area, _, _, _, _, _, _).

% Αναδρομικός κανόνας: Αν έχω πάνω από ένα στοιχείο, τότε θα συγκρίνω τα δύο κορυφαία και θα "κρατήσω" ως νέα κορυφή το ελάχιστο, απορρίπτοντας το άλλο.
find_biggest_house_area([X, Y | Tail], Biggest_House_Area) :- 
    % Εύρεση του φθηνότερου σπιτιού.
    house_with_biggest_area(X, Y, Z),

    % Αναδρομικός κανόνας.
    find_biggest_house_area([Z | Tail], Biggest_House_Area).

%% find_biggest_house/2
%% find_biggest_house(House_List, Biggest_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια (House_List) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με το μεγαλύτερο εμβαδόν (Biggest_House_List) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το μεγαλύτερο κήπο).

% Αν έχω λίστα με ένα κανένα σπίτι, τότε, προφανώς, δεν υπάρχει εκείνο με το μεγαλύτερο εμβαδόν (της λίστας).
% Ορίζεται για λόγους συμβατότητας με κενή λίστα (αν το δούμε με την λογική ότι "αφαιρεί εκείνα με όχι το μεγαλύτερο εμβαδόν", η κενή λίστα είναι συμβατή).
find_biggest_house([], []).

find_biggest_house(House_List, Biggest_House_List) :-
    find_biggest_house_area(House_List, Biggest_House_Area),
    find_biggest_house(House_List, Biggest_House_Area, [], Biggest_House_List).


/* ---------------------------------------------------- *|
|* -- Εύρεση καλύτερου διαμερίσματος για έναν πελάτη -- *|
|* ---------------------------------------------------- */ 

%% extract_addrlist_from_houselist_aux/3
%% extract_addrlist_from_houselist_aux(Houses, Temp_Addreses, Addresses).
%% Δέχεται σαν είσοδο μία λίστα από σπίτια (Houses) και μία λίστα με ημιτελής λίστα διευθύνσεων επιστρέφει μία ολοκληρωμένη λίστα με τα ονόματα οδών των σπιτιών (Addresses).

% Περίπτωση κενής λίστας: Μηδενικός αριθμός από σπίτια έχει μηδενικό αριθμό από νέες διευθύνσεις.
extract_addrlist_from_houselist_aux([], Y, Y).

% Περίπτωση με ένα η περισσότερα στοιχεία: Αναδρομικά.
extract_addrlist_from_houselist_aux([X | Tail], Temp_Addreses, Result) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τη διεύθυνση του).
    X = house(Address, _, _, _, _, _, _, _, _),
    extract_addrlist_from_houselist_aux(Tail, [Address | Temp_Addreses], Result).


%% extract_addrlist_from_houselist/2
%% extract_addrlist_from_houselist(Houses, Addresses).
%% Δέχεται σαν είσοδο μία λίστα από σπίτια (Houses) και επιστρέφει μία λίστα με τα ονόματα οδών εκείνων (Addresses).

% Περίπτωση κενής λίστας: Μηδενικός αριθμός από σπίτια έχει μηδενικό αριθμό από διευθύνσεις.
extract_addrlist_from_houselist([], []).

% Περίπτωση με ένα η περισσότερα στοιχεία.
extract_addrlist_from_houselist(Houses, Addresses) :-
    %  Απλά δίνω αρχικές τιμές και "ξεκινάω" το extract_addrlist_from_houselist_aux.
    extract_addrlist_from_houselist_aux(Houses, [], Addresses).

%% find_best_house/2
%% find_best_house(Houses, Recommended_House_Addresses).
%% Δέχεται σαν είσοδο μία λίστα από σπίτια (Houses) με ένα ή περισσότερα διαμερίσματα (με ολόκληρους τους συναρτησιακούς όρους house/9)
%% και επιστρέφει λίστα με τις διευθύνσεις (Recommended_House_Addresses) των καλύτερων (προτεινόμενων) σπιτιών, σύμφωνα με τις κοινές-για-όλους προτιμήσεις.
find_best_house(Houses, Recommended_House_Addresses) :- 
    % "Φιλτράρισμα" των ικανοποιητικών σπιτιών και αφαίρεση εκείνων με το μη ελάχιστο ενοίκιο.
    find_cheaper(Houses, Cheapest_Rent_Houses),

    % "Φιλτράρισμα" των σπιτιών με ελάχιστο ενοίκιο και αφαίρεση εκείνων με τον όχι μεγαλύτερο κήπο.
    find_biggest_garden(Cheapest_Rent_Houses, Cheapest_Rent_Biggest_Garden_Houses),

    % "Φιλτράρισμα" των σπιτιών με ελάχιστο ενοίκιο και κήπο μέγιστου εμβαδού και αφαίρεση εκείνων με τον όχι μεγαλύτερο εμβαδό (χώρου).
    find_biggest_house(Cheapest_Rent_Biggest_Garden_Houses, Recommended_Houses),

    extract_addrlist_from_houselist(Recommended_Houses, Recommended_House_Addresses).

%% Πρακτικά υλοποιείται η MergeSort (βάσει του αλγορίθμου από [ΕΙΣΑΓΩΓΗ ΣΤΗΝ ΑΝΑΛΥΣΗ ΚΑΙ ΣΧΕΔΙΑΣΗ ΑΛΓΟΡΙΘΜΩΝ, Anany Levitin, 3η Έκδοση] σελ. 216-217) όπου το κατηγόρημα sort_houses_best_top αντιστοιχεί σε μία συνάρτηση "mergesort"
%% και η merge_houses_best_top σε μία αντίστοιχη merge.

%% merge_houses_best_top/3
%% merge_houses_best_top(Left_List, Right_List, Sorted_Merged_List).
%% Ενώνει τις δύο λίστες "εισόδου" (Left_List, Right_List) (θεωρούνται ήδη ταξινομημένες) έτσι ώστε η τελική λίστα "εξόδου" (Sorted_Merged_List) να είναι ταξινομημένη.
%% Οι λίστες αυτές περιέχουν ζεύγη σπιτιών και μεγίστου διατιθέμενου ενοικίου για αυτά.

%% pick_best_house/2
%% pick_best_house(House_1, House_2, Best_House).
%% Από τα δύο σπίτια (House_1, House_2) αληθεύει (επιλέγει) εκείνο που είναι καλύτερο σύμφωνα με τις κοινές-για-όλους προτιμήσεις.

% Περίπτωση 1.1: Το πρώτο είναι πιο φθηνό από το δεύτερο.
pick_best_house(House_1, House_2, House_1) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        H1_Head = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        H2_Head = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent < H2_Rent, !.

% Περίπτωση 1.2: Το πρώτο είναι πιο ακριβό από το δεύτερο.
pick_best_house(House_1, House_2, House_2) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        H1_Head = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        H2_Head = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent > H2_Rent, !.

% Περίπτωση 2.1: Έχουν ίδια τιμή ενοικίου όμως, το πρώτο έχει μεγαλύτερο κήπο από το δεύτερο.
pick_best_house(House_1, House_2, House_1) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        H1_Head = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        H2_Head = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent =:= H2_Rent,
        H1_Garden_Area > H2_Garden_Area, !.

% Περίπτωση 2.2: Έχουν ίδια τιμή ενοικίου όμως, το πρώτο έχει μικρότερο κήπο από το δεύτερο.
pick_best_house(House_1, House_2, House_2) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        H1_Head = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        H2_Head = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent =:= H2_Rent,
        H1_Garden_Area < H2_Garden_Area, !.

% Περίπτωση 3.1: Έχουν ίδια τιμή ενοικίου και εμβαδό κήπου όμως, το πρώτο έχει μεγαλύτερο εμβαδό χώρου από το δεύτερο.
pick_best_house(House_1, House_2, House_1) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        H1_Head = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        H2_Head = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent =:= H2_Rent,
        H1_Garden_Area =:= H2_Garden_Area,
        H1_Floor_Area > H2_Garden_Area, !.

% Περίπτωση 3.2: Έχουν ίδια τιμή ενοικίου και εμβαδό κήπου όμως, το πρώτο έχει μικρότερο εμβαδό χώρου από το δεύτερο.
pick_best_house(House_1, House_2, House_2) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        H1_Head = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        H2_Head = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent =:= H2_Rent,
        H1_Garden_Area =:= H2_Garden_Area,
        H1_Floor_Area < H2_Garden_Area, !.

% Περίπτωση 4: Έχουν ίδια τιμή ενοικίου και εμβαδό κήπου και εμβαδό χώρου, επομένως θεωρούνται ισοδύναμα και επιστρέφεται (αυθαίρετα το πρώτο).
pick_best_house(House_1, House_2, House_1).

% Περίπτωση δύο κενών λιστών: Η ένωση δύο (ταξινομημένων) κενών λιστών είναι ταξινομημένη (κενή) λίστα.
merge_houses_best_top([], [], []).

% Περίπτωση όπου η δεξιά υπολίστα έχει αδειάσει: Εκείνη που έμεινε είναι και το αποτέλεσμα.
merge_houses_best_top([L_Head | L_Tail], [], [L_Head | L_Tail]).

% Περίπτωση όπου η αριστερή υπολίστα έχει αδειάσει: Εκείνη που έμεινε είναι και το αποτέλεσμα.
merge_houses_best_top([], [R_Head | R_Tail], [R_Head | R_Tail]).

% Περίπτωση όπου το πρώτο στοιχείο αριστερής υπολίστας είναι καλύτερο (σύμφωνα με τις κοινές-για-όλους προτιμήσεις).
merge_houses_best_top([L_Head | L_Tail], [R_Head | R_Tail], [L_Head | Sub_Result]) :-
    pick_best_house(L_Head, R_Head, L_Head), !,

    merge_houses_best_top(L_Tail, [R_Head | R_Tail], Sub_Result).

% Περίπτωση όπου το πρώτο στοιχείο δεξιάς υπολίστας είναι καλύτερο (σύμφωνα με τις κοινές-για-όλους προτιμήσεις).
merge_houses_best_top([L_Head | L_Tail], [R_Head | R_Tail], [R_Head | Sub_Result]) :-
    pick_best_house(L_Head, R_Head, R_Head), !,

    merge_houses_best_top([L_Head | L_Tail], R_Tail, Sub_Result).

%% sort_houses_best_top/2
%% sort_houses_best_top(House_Max_Rent_List, Sorted_House_Max_Rent_List).
%% Ταξινομεί και επιστρέφει μία (όχι απαραίτητα γνησίως) φθίνουσα ταξινομημένη λίστα ζευγών σπιτιών και μέγιστου ενοικίου για αυτά όπου στην κορυφή βρίσκεται το καλύτερο σπίτι και στο τελευταίο στοιχείο το λιγότερο καλύτερο,
%% σύμφωνα με τις κοινές-για-όλους προτιμήσεις.
% (Τερματική) Περίπτωση κενής λίστας: Θεωρείται ήδη ταξινομημένη.
sort_houses_best_top([], []).

% Γενική συνθήκη: Ταξινομώ τις δύο υπολίστες και ενώνω το αποτέλεσμα τους.
sort_houses_best_top(House_Max_Rent_List, Sorted_House_Max_Rent_List) :-
    % Χωρίζω την λίστα σε δύο (περίπου ίσα) μέρη: Left_Sublist και Right_Sublist.
    sublist(Left_Sublist, Right_Sublist, House_Max_Rent_List),
    % Οι δύο υπολίστες πρέπει να έχουν το ίδιο μήκος αν η αρχική λίστα έχει άρτιο μήκος, διαφορετικά η μία θα έχει ένα παραπάνω στοιχείο
    length(Left_Sublist, Len),(length(Right_Sublist, Len); R_Len is Len + 1, length(Right_Sublist, R_Len)),

    % Αναδρομική κλήση για τα δύο υπομέρη: Ως αποτέλεσμα εκείνα θα είναι ταξινομημένα και αρκεί απλά να τα ενώσω.
    sort_houses_best_top(Left_Sublist, Sorted_Left_Sublist),
    sort_houses_best_top(Right_Sublist, Sorted_Right_Sublist),
    merge_houses_best_top(Sorted_Left_Sublist, Sorted_Right_Sublist, Sorted_House_Max_Rent_List).




/* --------------------------------------- *|
|* --           Λειτουργία 1            -- *|
|* -- Εκτέλεση διαδραστικής λειτουργίας -- *|
|* --------------------------------------- */ 

%% mode_1/11
%% mode_1(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses, Best_House_Addr).
%% Δέχεται σαν είσοδο τις απαιτήσεις του υποψήφιου ενοικιαστή και επιστρέφει λίστα (Compatible_Houses) με ένα ή περισσότερα διαμερίσματα που ικανοποιούν τις απαιτήσεις του υποψήφιου ενοικιαστή
%% (με ολόκληρους τους συναρτησιακούς όρους house/9).
%% Επίσης, επιστρέφει λίστα με τις διευθύνσεις (Recommended_House_Addresses) των καλύτερων (προτεινόμενων) σπιτιών, σύμφωνα με τις κοινές-για-όλους προτιμήσεις.
mode_1(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses, Best_House_Addr) :-
    % Βρίσκω τα συμβατά, με τια απαιτήσεις του υποψήφιου ενοικιαστή, σπίτια.
    compatible_houses(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses),

    % Βρίσκω τα προτεινόμενα (καλύτερα) σπίτια.
    find_best_house(Compatible_Houses, Best_House_Addr).

/* --------------------------------- *|
|* --        Λειτουργία 2         -- *|
|* -- Μαζικές προτιμήσεις πελατών -- *|
|* --------------------------------- */ 

%% mode_2/3
%% mode_2(Renter_Name, Compatible_Houses, Best_House_Addr).
%% Δέχεται σαν είσοδο το όνομα ενός υποψήφιου ενοικιαστή και επιστρέφει μία λίστα με και επιστρέφει λίστα (Compatible_Houses) με ένα ή περισσότερα διαμερίσματα που ικανοποιούν τις απαιτήσεις του υποψήφιου ενοικιαστή
%% (με ολόκληρους τους συναρτησιακούς όρους house/9).
mode_2(Renter_Name, Compatible_Houses, Best_House_Addr) :-
    % Εντοπίζω τις απαιτήσεις του κατονομαζόμενου πιθανού ενοικιαστή.
    request(Renter_Name, Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden),

    % Βρίσκω τα συμβατά σπίτια και το καλύτερο.
    mode_1(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses, Best_House_Addr).



