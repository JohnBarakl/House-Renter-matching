% This file is encoded in UTF-8.

/* ---------------------------------------- *|
|* -- Ονοματεπώνυμο: Μπαρακλιλής Ιωάννης -- *|
|* --             ΑΕΜ: 3685              -- *|
|* ---------------------------------------- */ 

% Σημείωση: Το τρέχον αρχείο υλοποιεί αποκλειστικά το μέρος της λογικής - εκτέλεση υπολογισμών και είναι απαραίτητο για την λειτουργία του main.pl.
% Φόρτωση εξωτερικών πληροφοριών δεν γίνεται, θεωρείται ότι έγιναν από main.pl.

/* ---------------------------------------------------------------------------------- *|
|* -- Εύρεση διαμερίσματος που ικανοποιούν τις απαιτήσεις του υποψήφιου ενοικιαστή -- *|
|* ---------------------------------------------------------------------------------- */ 

%% satisfies_augmented_rent_requirements/11
%% satisfies_augmented_rent_requirements(At_Center, Max_Rent_Center, Floor_Area, Min_Area, Max_Rent_Suburbs, Bonus_Area, Garden_Area, Bonus_Garden, Max_Rent, Rent, New_Limited_Max_Rent).
%% Επιτυγχάνει αν ικανοποιεί τις προχωρημένες απαιτήσεις σχετικά με το ενοίκιο (δηλαδή με τις προσαυξήσεις) δεδομένου αν είναι στα προάστια ή όχι.
%% Επιπλέον, επιστρέφει το μέγιστο ποσό που είναι διατίθεται ο ενοικιαστής να δώσει για αυτό το σπίτι (New_Limited_Max_Rent).
%%
%% Σημείωση: Θεωρείται δεδομένο πως τα χαρακτηριστικά του διαμερίσματος ικανοποιούν τον περιορισμό ελάχιστων απαιτούμενων τετραγωνικών (Floor_Area >= Min_Area). Αν όχι, τότε είναι πολύ
%% πιθανό να έχουμε λανθασμένο αποτέλεσμα. Ο λόγος για τον οποίο θεωρείται δεδομένο είναι για λόγους απλότητας του κώδικα και ότι σε αυτό το πλαίσιο χρήσης δεν υπάρχει περίπτωση λάθος κλήσης
%% (εφόσον καλείται από compatible_house αφότου έχει εξασφαλίσει ότι Floor_Area >= Min_Area).
 
% Αν βρίσκεται στο κέντρο.
satisfies_augmented_rent_requirements(yes, Max_Rent_Center, Floor_Area, Min_Area, _, Bonus_Area, Garden_Area, Bonus_Garden, Max_Rent, Rent, New_Limited_Max_Rent) :- 
    % Υπολογισμός του μέγιστου ποσού που διατίθεται να πληρώσει με συνυπολογισμό των επιπλέον τετραγωνικών και κήπου.
    New_Max_Rent_Center is Max_Rent_Center + Bonus_Area * (Floor_Area - Min_Area) + Bonus_Garden * Garden_Area,
    % Σημείωση: είναι δεδομένο πως Floor_Area >= Min_Area (από compatible_house που "καλεί" αυτό το κατηγόρημα) και έτσι Floor_Area - Min_Area >= 0.

    % Το Max_Rent μας δίνει το άνω όριο διαθέσιμου ποσού συνολικά, δηλαδή το "νέο" μέγιστο ποσό (που υπολογίστηκε παραπάνω) πρέπει να "περιοριστεί" βάσει του (να μην ξεπερνάει ποτέ το) άνω ορίου.
    % Δηλαδή είτε New_Max_Rent =< Max_Rent οπότε θα πάρουμε το νέο μέγιστο νοίκι (με τις προσαυξήσεις λόγω επιπλέον τετραγωνικών ή/και κήπου) ή New_Max_Rent > Max_Rent οπότε εφόσον το συνολικό ποσό
    % (προσαυξημένο) δεν μπορεί να ξεπερνάει το άνω όριο διαθέσιμου ποσού θα πάρουμε το άνω όριο διαθέσιμου ποσού.
    New_Limited_Max_Rent is min(New_Max_Rent_Center, Max_Rent),

    % Το ενοίκιο του διαμερίσματος πρέπει να είναι μικρότερο ή ίσο του μέγιστου ποσού για διάθεση.
    New_Limited_Max_Rent >= Rent.

% Αν βρίσκεται στα προάστια.
satisfies_augmented_rent_requirements(no, _, Floor_Area, Min_Area, Max_Rent_Suburbs, Bonus_Area, Garden_Area, Bonus_Garden, Max_Rent, Rent, New_Limited_Max_Rent) :- 
    % Υπολογισμός του μέγιστου ποσού που διατίθεται να πληρώσει με συνυπολογισμό των επιπλέον τετραγωνικών και κήπου.
    New_Max_Rent_Suburbs is Max_Rent_Suburbs + Bonus_Area * (Floor_Area - Min_Area) + Bonus_Garden * Garden_Area,
    % Σημείωση: είναι δεδομένο πως Floor_Area >= Min_Area (από compatible_house που "καλεί" αυτό το κατηγόρημα) και έτσι Floor_Area - Min_Area >= 0.

    % Το Max_Rent μας δίνει το άνω όριο διαθέσιμου ποσού συνολικά, δηλαδή το "νέο" μέγιστο ποσό (που υπολογίστηκε παραπάνω) πρέπει να "περιοριστεί" βάσει του (να μην ξεπερνάει ποτέ το) άνω ορίου.
    % Δηλαδή είτε New_Max_Rent =< Max_Rent οπότε θα πάρουμε το νέο μέγιστο νοίκι (με τις προσαυξήσεις λόγω επιπλέον τετραγωνικών ή/και κήπου) ή New_Max_Rent > Max_Rent οπότε εφόσον το συνολικό ποσό
    % (προσαυξημένο) δεν μπορεί να ξεπερνάει το άνω όριο διαθέσιμου ποσού θα πάρουμε το άνω όριο διαθέσιμου ποσού.
    New_Limited_Max_Rent is min(New_Max_Rent_Suburbs, Max_Rent),

    % Το ενοίκιο του διαμερίσματος πρέπει να είναι μικρότερο ή ίσο του μέγιστου ποσού για διάθεση.
    New_Limited_Max_Rent >= Rent.

%% satisfied_floor_req\3
%% satisfied_floor_req(Floor, Elevator_Limit, Has_Elevator).
%% Επιτυγχάνει αν Floor < Elevator_Limit ή Has_Elevator == yes ή και τα δύο, δηλαδή να ικανοποιούνται οι απαιτήσεις για ελάχιστο όροφο για
%% ανελκυστήρα, χωρίς να δημιουργεί πολλές (άχρηστες) εναλλακτικές λύσεις.

% Βρίσκεται σε μικρότερο όροφο απο ότι απαιτείται για ανελκυστήρα.
satisfied_floor_req(Floor, Elevator_Limit, _) :-
    Floor < Elevator_Limit, !.  % Το ! γιατί οι δύο κανόνες είναι αμοιβαία αποκλειόμενοι .

% Βρίσκεται σε μεγαλύτερο (ή ίσο) όροφο απο ότι απαιτείται για ανελκυστήρα και έχει ανελκυστήρα.
satisfied_floor_req(Floor, Elevator_Limit, Has_Elevator) :-
    Floor >= Elevator_Limit, Has_Elevator == yes.


%% satisfied_pet_req\2
%% satisfied_pet_req(Requires_Pets, Allows_Pets).
%% Επιτυγχάνει αν ικανοποιούνται οι απαιτήσεις σχετικά με το αν επιτρέπονται κατοικίδια.

% Ο ενοικιαστής δεν ενδιαφέρεται για το να επιτρέπονται κατοικίδια: Είναι αδιάφορο το αν επιτρέπονται.
satisfied_pet_req(Requires_Pets, _Allows_Pets) :-
    Requires_Pets == no, !.  % Το ! γιατί οι δύο κανόνες είναι αμοιβαία αποκλειόμενοι.

% Ο ενοικιαστής ενδιαφέρεται για το να επιτρέπονται κατοικίδια και επιτρέπονται.
satisfied_pet_req(Requires_Pets, Allows_Pets) :-
    Requires_Pets == yes, Allows_Pets = yes.

%% compatible_house/11
%% compatible_house(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House, Max_Rent_Willing).
%% Επιτυγχάνει για διαμέρισμα (όρισμα House) το οποίο ικανοποιεί τους δοθέντες περιορισμούς (προβλεπόμενη χρήση είναι να δίνονται σαν "έξοδοι" τα House (τύπου house(...)) και Max_Rent_Willing και τα άλλα ορίσματα σαν είσοδοι).
%% Το "Max_Rent_Willing" περιέχει το μέγιστο ποσό (ενοίκιο) που διατίθεται ο ενοικιαστής να δώσει για αυτό το σπίτι.

compatible_house(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House, Max_Rent_Willing) :-
    % "Δίνω" τιμές στις μεταβλητές που αργότερα θα ελέγξω (ουσιαστικά, "βρίσκω" κάποιο σπίτι).
    house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent),

    % Απαιτήσεις σχετικά με το διαμέρισμα.
    Sleeping_Quarters >= Min_Sleeping_Quarters,
    Floor_Area >= Min_Area,
    satisfied_floor_req(Floor, Elevator_Limit, Has_Elevator),
    satisfied_pet_req(Requires_Pets, Allows_Pets),

    % Απαιτήσεις σχετικά με το ενοίκιο.
    satisfies_augmented_rent_requirements(At_Center, Max_Rent_Center,Floor_Area, Min_Area, Max_Rent_Suburbs, Bonus_Area, Garden_Area, Bonus_Garden, Max_Rent, Rent, Max_Rent_Willing),
    House = house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent).

%% compatible_houses/10
%% compatible_houses(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House_List).
%% Βρίσκει και επιστρέφει μία λίστα με τα σπίτια (House_List) που ικανοποιούν τις απαιτήσεις του ενοικιαστή.
compatible_houses(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House_List) :-
    findall(House, compatible_house(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House, _Max_Rent_Willing), House_List).


%% compatible_houses_w_maxrent/8
%% compatible_houses(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Maxrent_List).
%% Βρίσκει και επιστρέφει λίστα (House_Maxrent_List) με ζεύγη σπιτιών και μεγίστου διατιθέμενου ενοικίου για αυτά, τα οποία ικανοποιούν τις απαιτήσεις του ενοικιαστή. Τα ζεύγη που περιέχει η λίστα έχουν την μορφή
%% house_maxrent(House, Max_Rent).
compatible_houses_w_maxrent(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House_Maxrent_List) :-
    % Βρίσκω όλα τα σπίτια και τα μέγιστα διατιθέμενα ενοίκια.
    findall(house_maxrent(House, Max_Rent_Willing), compatible_house(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House, Max_Rent_Willing), House_Maxrent_List).


/* ----------------------------------------------- *|
|* -- Εύρεση φθηνότερων διαμερισμάτων απο λίστα -- *|
|* ----------------------------------------------- */ 

%% find_cheaper_aux/4
%% find_cheaper_aux(House_List, Min_Rent, Temp_Cheapest_House_List, Cheapest_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια και το ελάχιστο νοίκι αυτών (House_List, Min_Rent αντίστοιχα) και επιστρέφει μία λίστα από αυτά τα σπίτια με το ελάχιστο νοίκι (Cheapest_House_List) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το φτηνότερο ενοίκιο). Η μεταβλητή Temp_Cheapest_House_List περιέχει προσωρινά τα σπίτια με το ελάχιστο ενοίκιο για κάθε βήμα για λόγους απόδοσης μνήμης.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε αν έχει νοίκι ίδιο με το ελάχιστο, προφανώς, είναι από τα φθηνότερα (της λίστας) και προστίθεται στην λίστα ελαχίστων.
find_cheaper_aux([X], Min_Rent, Temp_Cheapest_House_List, [X | Temp_Cheapest_House_List]) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent),
    Rent =:= Min_Rent.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε αν δεν έχει νοίκι ίδιο με το ελάχιστο, προφανώς, δεν είναι από τα φθηνότερα (της λίστας).
find_cheaper_aux([X], Min_Rent, Temp_Cheapest_House_List, Temp_Cheapest_House_List) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent),
    Rent =\= Min_Rent.

% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή έχει τιμή ελαχίστου ενοικίου.
find_cheaper_aux([X | Tail], Min_Rent, Temp_Cheapest_House_List, Min_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent),
    Rent =:= Min_Rent,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το ελάχιστο ενοίκιο αποτελείται από το στοιχείο κορυφής λίστας (εφόσον διαπιστώθηκε ως ελάχιστο) και
    % των ελαχίστων της υπόλοιπης λίστας.
    find_cheaper_aux(Tail, Min_Rent, [X | Temp_Cheapest_House_List],  Min_Houses).
    

% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή δεν έχει τιμή ελαχίστου ενοικίου.
find_cheaper_aux([X | Tail], Min_Rent, Temp_Cheapest_House_List, Min_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο το ενοίκιο).
    X = house(_, _, _, _, _, _, _, _, Rent),
    Rent =\= Min_Rent,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το ελάχιστο ενοίκιο αποτελείται μόνο (εφόσον διαπιστώθηκε ως μη ελάχιστο) των ελαχίστων της υπόλοιπης λίστας.
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
% "Επιστρέφεται" -1 λόγω (αυθαίρετης) σύμβασης.
find_cheapest_rent([], -1).

% Τερματική συνθήκη: Άν έχω ένα στοιχείο, τότε αυτό είναι ελάχιστο.
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
% Ορίζεται για λόγους συμβατότητας με κενή λίστα (αν το δούμε με την λογική ότι "αφαιρεί τα όχι φτηνότερα σπίτια", τότε η κενή λίστα είναι συμβατή).
find_cheaper([], []).

% Συνήθης περίπτωση.
find_cheaper(House_List, Cheapest_House_List) :-
    find_cheapest_rent(House_List, Min_Rent),
    find_cheaper_aux(House_List, Min_Rent, [], Cheapest_House_List).



/* ------------------------------------------------------- *|
|* -- Εύρεση διαμερισμάτων με μεγαλύτερο κήπο από λίστα -- *|
|* ------------------------------------------------------- */ 

%% find_biggest_garden_aux/4
%% find_biggest_garden_aux(House_List, Max_Garden_Area, Temp_Biggest_Garden_House_List, Max_Garden_Houses).
%% Παίρνει ως είσοδο μια λίστα από σπίτια και το μέγιστο εμβαδόν κήπου (House_List, Max_Garden_Area) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με τον μεγαλύτερο κήπο (Max_Garden_Houses) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το μεγαλύτερο κήπο). Η μεταβλητή Temp_Biggest_Garden_House_List περιέχει προσωρινά τα σπίτια με το μεγαλύτερο κήπο σε κάθε βήμα για λόγους απόδοσης μνήμης.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, προφανώς, είναι εκείνο με τον μεγαλύτερο κήπο (της λίστας) δεδομένου ότι έχει μέγεθος του κήπου ίσο με το μέγιστο
% και προστίθεται στην λίστα αποτελέσματος.
find_biggest_garden_aux([X], Max_Garden_Area, Temp_Biggest_Garden_House_List, [X | Temp_Biggest_Garden_House_List]) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, Garden_Area, _),
    Garden_Area =:= Max_Garden_Area.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, δεν είναι εκείνο με τον μεγαλύτερο κήπο (της λίστας) δεδομένου ότι δεν έχει μέγεθος του κήπου ίσο με το μέγιστο
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

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το μεγαλύτερο κήπο αποτελείται από το στοιχείο κορυφής λίστας (εφόσον διαπιστώθηκε ως μέγιστο) και
    % των μεγίστων της υπόλοιπης λίστας.
    find_biggest_garden_aux(Tail, Max_Garden_Area, [X | Temp_Biggest_Garden_House_List],  Max_Garden_Houses).


% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή δεν έχει τον μεγαλύτερο κήπο.
find_biggest_garden_aux([X | Tail], Max_Garden_Area, Temp_Biggest_Garden_House_List, Max_Garden_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, Garden_Area, _),
    Garden_Area =\= Max_Garden_Area,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με τον μεγαλύτερο κήπο αποτελείται μόνο (εφόσον διαπιστώθηκε ως μη μέγιστο) των μεγίστων της υπόλοιπης λίστας.
    find_biggest_garden_aux(Tail, Max_Garden_Area, Temp_Biggest_Garden_House_List, Max_Garden_Houses).


%% biggest_garden_house/3
%% biggest_garden_house(X, Y, Z).
%% Δέχεται σαν είσοδο δύο σπίτια (X, Y) και "επιστρέφει" εκείνο με τον μεγαλύτερο κήπο (Z).

% Περίπτωση X >= Y.
biggest_garden_house(X, Y, X) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, X_Garden_Area, _),

    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    Y = house(_, _, _, _, _, _, _, Y_Garden_Area, _),

    X_Garden_Area >= Y_Garden_Area.


% Περίπτωση X < Y.
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
% "Επιστρέφεται" -1 λόγω (αυθαίρετης) σύμβασης.
find_biggest_garden_area([], -1).

% Τερματική συνθήκη: Άν έχω ένα στοιχείο, τότε αυτό είναι μέγιστο.
find_biggest_garden_area([X], Garden_Area) :- 
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του κήπου).
    X = house(_, _, _, _, _, _, _, Garden_Area, _).

% Αναδρομικός κανόνας: Αν έχω πάνω από ένα στοιχείο, τότε θα συγκρίνω τα δύο κορυφαία και θα "κρατήσω" ως νέα κορυφή το μέγιστο, απορρίπτοντας το άλλο.
find_biggest_garden_area([X, Y | Tail], Biggest_Garden_Area) :- 
    % Εύρεση του σπιτιού με μεγαλύτερο κήπο.
    biggest_garden_house(X, Y, Z),

    % Αναδρομικός κανόνας.
    find_biggest_garden_area([Z | Tail], Biggest_Garden_Area).


%% find_biggest_garden/2
%% find_biggest_garden_aux(House_List, Biggest_Garden_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια (House_List) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με τον μεγαλύτερο κήπο (Biggest_Garden_House_List) 
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
%% find_biggest_house(House_List, Max_Area, Temp_Biggest_House_List, Max_Area_Houses).
%% Παίρνει ως είσοδο μια λίστα από σπίτια και το μέγιστο εμβαδόν (House_List, Max_Area) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με το μεγαλύτερο εμβαδόν (Max_Area_Houses) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το μεγαλύτερο εμβαδόν). Η μεταβλητή Temp_Biggest_House_List περιέχει προσωρινά τα σπίτια με το μεγαλύτερο εμβαδόν για κάθε βήμα για λόγους απόδοσης μνήμης.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, προφανώς, είναι εκείνο με το μεγαλύτερο εμβαδόν (της λίστας) δεδομένου ότι έχει εμβαδόν ίσο με το μέγιστο
% και προστίθεται στην λίστα αποτελέσματος.
find_biggest_house([X], Max_Area, Temp_Biggest_House_List, [X | Temp_Biggest_House_List]) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, House_Area, _, _, _, _, _, _),
    House_Area =:= Max_Area.

% Τερματική συνθήκη: Αν έχω λίστα με ένα ένα μόνο σπίτι, τότε, δεν είναι εκείνο με το μεγαλύτερο εμβαδόν (της λίστας) δεδομένου ότι δεν έχει εμβαδόν ίσο με το μέγιστο
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

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το μεγαλύτερο εμβαδό αποτελείται από το στοιχείο κορυφής λίστας (εφόσον διαπιστώθηκε ως μέγιστο) και
    % των μεγίστων της υπόλοιπης λίστας.
    find_biggest_house(Tail, Max_Area, [X | Temp_Biggest_House_List],  Max_Area_Houses).

    

% Περίπτωση με > 1 σπίτια όπου εκείνο στην κορυφή δεν έχει το μεγαλύτερο εμβαδόν.
find_biggest_house([X | Tail], Max_Area, Temp_Biggest_House_List, Max_Area_Houses) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, House_Area, _, _, _, _, _, _),
    House_Area =\= Max_Area,

    % Αναδρομικός κανόνας: Η λίστα με σπίτια με το μεγαλύτερο εμβαδόν αποτελείται μόνο (εφόσον διαπιστώθηκε ως μη μέγιστο) των μεγίστων της υπόλοιπης λίστας.
    find_biggest_house(Tail, Max_Area, Temp_Biggest_House_List, Max_Area_Houses).


%% house_with_biggest_area/3
%% house_with_biggest_area(X, Y, Z).
%% Δέχεται σαν είσοδο δύο σπίτια (X, Y) και "επιστρέφει" εκείνο με το μεγαλύτερο εμβαδόν (Z).

% Περίπτωση X >= Y.
house_with_biggest_area(X, Y, X) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, X_House_Area, _, _, _, _, _, _),

    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    Y = house(_, _, Y_House_Area, _, _, _, _, _, _),

    X_House_Area >= Y_House_Area.


% Περίπτωση X < Y.
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
% "Επιστρέφεται" -1 λόγω (αυθαίρετης) σύμβασης.
find_biggest_house_area([], -1).


% Τερματική συνθήκη: Άν έχω ένα στοιχείο, τότε αυτό είναι μέγιστο.
find_biggest_house_area([X], House_Area) :- 
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τα τετραγωνικά του).
    X = house(_, _, House_Area, _, _, _, _, _, _).

% Αναδρομικός κανόνας: Αν έχω πάνω από ένα στοιχείο, τότε θα συγκρίνω τα δύο κορυφαία και θα "κρατήσω" ως νέα κορυφή το μέγιστο, απορρίπτοντας το άλλο.
find_biggest_house_area([X, Y | Tail], Biggest_House_Area) :- 
    % Εύρεση του σπιτιού με μεγαλύτερο εμβαδόν.
    house_with_biggest_area(X, Y, Z),

    % Αναδρομικός κανόνας.
    find_biggest_house_area([Z | Tail], Biggest_House_Area).

%% find_biggest_house/2
%% find_biggest_house(House_List, Biggest_House_List).
%% Παίρνει ως είσοδο μια λίστα από σπίτια (House_List) και και θα επιστρέφει μία λίστα από αυτά τα σπίτια με το μεγαλύτερο εμβαδόν (Biggest_House_List) 
%%  (εφόσον μπορεί να υπάρχουν παραπάνω από ένα με το μεγαλύτερο εμβαδόν).

% Αν έχω λίστα με ένα κανένα σπίτι, τότε, προφανώς, δεν υπάρχει εκείνο με το μεγαλύτερο εμβαδόν (της λίστας).
% Ορίζεται για λόγους συμβατότητας με κενή λίστα (αν το δούμε με την λογική ότι "αφαιρεί εκείνα με όχι το μεγαλύτερο εμβαδόν", η κενή λίστα είναι συμβατή).
find_biggest_house([], []).

% Συνήθης περίπτωση.
find_biggest_house(House_List, Biggest_House_List) :-
    find_biggest_house_area(House_List, Biggest_House_Area),
    find_biggest_house(House_List, Biggest_House_Area, [], Biggest_House_List).


/* ---------------------------------------------------- *|
|* -- Εύρεση καλύτερου διαμερίσματος για έναν πελάτη -- *|
|* ---------------------------------------------------- */ 

%% extract_addrlist_from_houselist_aux/3
%% extract_addrlist_from_houselist_aux(Houses, Temp_Addreses, Addresses).
%% Δέχεται σαν είσοδο μία λίστα από σπίτια (Houses) και μία ημιτελής λίστα διευθύνσεων επιστρέφει μία ολοκληρωμένη λίστα με τα ονόματα οδών των σπιτιών (Addresses).

% Περίπτωση κενής λίστας: Μηδενικός αριθμός από σπίτια έχει μηδενικό αριθμό από νέες διευθύνσεις.
extract_addrlist_from_houselist_aux([], Y, Y).

% Περίπτωση με ένα η περισσότερα στοιχεία: Αναδρομικά.
extract_addrlist_from_houselist_aux([X | Tail], Temp_Addreses, Result) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού (κρατώντας μόνο τη διεύθυνση του).
    X = house(Address, _, _, _, _, _, _, _, _),
    extract_addrlist_from_houselist_aux(Tail, [Address | Temp_Addreses], Result).


%% extract_addrlist_from_houselist/2
%% extract_addrlist_from_houselist(Houses, Addresses).
%% Δέχεται σαν είσοδο μία λίστα από σπίτια (Houses) και επιστρέφει μία λίστα με τα ονόματα των οδών εκείνων (Addresses).

% Περίπτωση κενής λίστας: Μηδενικός αριθμός από σπίτια έχει μηδενικό αριθμό από διευθύνσεις.
extract_addrlist_from_houselist([], []).

% Περίπτωση με ένα η περισσότερα στοιχεία.
extract_addrlist_from_houselist(Houses, Addresses) :-
    %  Απλά δίνω αρχικές τιμές και "ξεκινάω" το extract_addrlist_from_houselist_aux.
    extract_addrlist_from_houselist_aux(Houses, [], Addresses).

%% find_best_house/2
%% find_best_house(Houses, Recommended_House_Addresses).
%% Δέχεται σαν είσοδο μία λίστα (Houses) με ένα ή περισσότερα διαμερίσματα (με ολόκληρους τους όρους house)
%% και επιστρέφει λίστα με τις διευθύνσεις (Recommended_House_Addresses) των καλύτερων (προτεινόμενων) σπιτιών, σύμφωνα με τις κοινές-για-όλους προτιμήσεις.
find_best_house(Houses, Recommended_House_Addresses) :- 
    % "Φιλτράρισμα" των ικανοποιητικών σπιτιών και αφαίρεση εκείνων με το μη ελάχιστο ενοίκιο.
    find_cheaper(Houses, Cheapest_Rent_Houses),

    % "Φιλτράρισμα" των σπιτιών με ελάχιστο ενοίκιο και αφαίρεση εκείνων με τον όχι μεγαλύτερο κήπο.
    find_biggest_garden(Cheapest_Rent_Houses, Cheapest_Rent_Biggest_Garden_Houses),

    % "Φιλτράρισμα" των σπιτιών με ελάχιστο ενοίκιο και κήπο μέγιστου εμβαδού και αφαίρεση εκείνων με τον όχι μεγαλύτερο εμβαδό (χώρου).
    find_biggest_house(Cheapest_Rent_Biggest_Garden_Houses, Recommended_Houses),

    % Από τα καλύτερα σπίτια "κρατάω" μόνο τις διευθύνσεις τους.
    extract_addrlist_from_houselist(Recommended_Houses, Recommended_House_Addresses).

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ [   Σχόλια - Τρόπος σκέψης για το τμήμα αυτό   ] ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
% Το ακόλουθο τμήμα αναπτύσσεται για να υποστηρίξει την 3η λειτουργία του προγράμματος, δηλαδή αυτή της επιλογής πελατών για κάθε σπίτι βάσει δημοπρασίας %
%                                                                                                                                                         %
% Για εκείνο, στην συνέχεια αναπτύσσεται ο αλγόριθμος Gale-Shapley ο οποίος απαιτεί ταξινομημένες λίστες προτιμήσεων σπιτιών για τους πελάτες και έτσι    %
% χρειάζεται μία μέθοδος ταξινόμησης.                                                                                                                     %
%                                                                                                                                                         %
% Έτσι, επιλέχθηκε να αναπτυχθεί από την αρχή ο αλγόριθμος ταξινόμησης Merge Sort που έχει βέλτιστη πολυπλοκότητα.                                        %
%                                                                                                                                                         %
% Στο πλαίσιο αυτό αναπτύσσεται και ο "τελεστής" σύγκρισης σπιτιών βάσει των κοινών-για-όλους προτιμήσεις: pick_best_house/2.                             %
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %

% Πρακτικά υλοποιείται η MergeSort όπου το κατηγόρημα sort_houses_best_top αντιστοιχεί σε μία συνάρτηση "mergesort"
% και η merge_houses_best_top σε μία αντίστοιχη merge.

%% pick_best_house/3
%% pick_best_house(House_1, House_2, Best_House).
%% Από τα δύο σπίτια (House_1, House_2) αληθεύει (επιλέγει) εκείνο που είναι καλύτερο σύμφωνα με τις κοινές-για-όλους προτιμήσεις.
%% Σημείωση: Οι παράμετροι σπιτιών έχουν μορφή house_maxrent(house/9, max_rent).

% Περίπτωση 1.1: Το πρώτο είναι πιο φθηνό από το δεύτερο.
pick_best_house(House_1, House_2, House_1) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        House_1 = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, _H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, _H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        House_2 = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, _H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, _H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent < H2_Rent, !.

% Περίπτωση 1.2: Το πρώτο είναι πιο ακριβό από το δεύτερο.
pick_best_house(House_1, House_2, House_2) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        House_1 = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, _H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, _H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        House_2 = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, _H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, _H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent > H2_Rent, !.

% Περίπτωση 2.1: Έχουν ίδια τιμή ενοικίου όμως, το πρώτο έχει μεγαλύτερο κήπο από το δεύτερο.
pick_best_house(House_1, House_2, House_1) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        House_1 = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, _H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        House_2 = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, _H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent =:= H2_Rent,
        H1_Garden_Area > H2_Garden_Area, !.

% Περίπτωση 2.2: Έχουν ίδια τιμή ενοικίου όμως, το πρώτο έχει μικρότερο κήπο από το δεύτερο.
pick_best_house(House_1, House_2, House_2) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        House_1 = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, _H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        House_2 = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, _H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent =:= H2_Rent,
        H1_Garden_Area < H2_Garden_Area, !.

% Περίπτωση 3.1: Έχουν ίδια τιμή ενοικίου και εμβαδό κήπου όμως, το πρώτο έχει μεγαλύτερο εμβαδό χώρου από το δεύτερο.
pick_best_house(House_1, House_2, House_1) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        House_1 = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        House_2 = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent =:= H2_Rent,
        H1_Garden_Area =:= H2_Garden_Area,
        H1_Floor_Area > H2_Floor_Area, !.

% Περίπτωση 3.2: Έχουν ίδια τιμή ενοικίου και εμβαδό κήπου όμως, το πρώτο έχει μικρότερο εμβαδό χώρου από το δεύτερο.
pick_best_house(House_1, House_2, House_2) :-
        % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
        House_1 = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
        House_2 = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

        H1_Rent =:= H2_Rent,
        H1_Garden_Area =:= H2_Garden_Area,
        H1_Floor_Area < H2_Floor_Area, !.

% Περίπτωση 4: Έχουν ίδια τιμή ενοικίου και εμβαδό κήπου και εμβαδό χώρου, επομένως θεωρούνται ισοδύναμα και επιστρέφεται (αυθαίρετα) το πρώτο.
pick_best_house(House_1, House_2, House_1) :- 
    % Ανάλυση του πολύπλοκου συναρτησιακού όρου house_maxrent(house(House_Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent), Max_Rent).
    House_1 = house_maxrent(house(_H1_House_Address, _H1_Sleeping_Quarters, H1_Floor_Area, _H1_At_Center, _H1_Floor, _H1_Has_Elevator, _H1_Allows_Pets, H1_Garden_Area, H1_Rent), _H1_Max_Rent),
    House_2 = house_maxrent(house(_H2_House_Address, _H2_Sleeping_Quarters, H2_Floor_Area, _H2_At_Center, _H2_Floor, _H2_Has_Elevator, _H2_Allows_Pets, H2_Garden_Area, H2_Rent), _H2_Max_Rent),

    H1_Rent =:= H2_Rent,
    H1_Garden_Area =:= H2_Garden_Area,
    H1_Floor_Area =:= H2_Floor_Area.

%% merge_houses_best_top/3
%% merge_houses_best_top(Left_List, Right_List, Sorted_Merged_List).
%% Ενώνει τις δύο λίστες "εισόδου" (Left_List, Right_List) (θεωρούνται ήδη φθίνουσα ταξινομημένες) έτσι ώστε η τελική λίστα "εξόδου" (Sorted_Merged_List) να είναι φθίνουσα ταξινομημένη.
%% Οι λίστες αυτές περιέχουν ζεύγη σπιτιών και μεγίστου διατιθέμενου ενοικίου για αυτά (house_maxrent(house/9, max_rent)).

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
sort_houses_best_top([], []) :- !. % Το ! είναι απαραίτητο διότι χωρίς αυτό εντοπίζονται άπειρες ίσες λύσεις με επόμενο κανόνα (η κενή λίστα μπορεί να "σπάσει" σε άπειρες κενές λίστες).

% (Τερματική) Περίπτωση λίστας με μοναδικό στοιχείο: Θεωρείται ήδη ταξινομημένη.
% Το ! είναι απαραίτητο διότι χωρίς αυτό εντοπίζονται άπειρες ίσες λύσεις με τον επόμενο κανόνα (λίστα ενός στοιχείου μπορεί πάντα να σπάσει σε μία κενή και σε μία με ένα στοιχείο εκείνο).
sort_houses_best_top([Unitary_Element], [Unitary_Element]) :- !. 

% Γενική συνθήκη: Ταξινομώ τις δύο υπολίστες και ενώνω το αποτέλεσμα τους.
sort_houses_best_top(House_Max_Rent_List, Sorted_House_Max_Rent_List) :-
    % Χωρίζω την λίστα σε δύο (περίπου ίσα) μέρη: Left_Sublist και Right_Sublist.
    append(Left_Sublist, Right_Sublist, House_Max_Rent_List),
    % Οι δύο υπολίστες πρέπει να έχουν το ίδιο μήκος αν η αρχική λίστα έχει άρτιο μήκος, διαφορετικά η μία θα έχει ένα παραπάνω στοιχείο.
    length(Left_Sublist, Len),(length(Right_Sublist, Len); R_Len is Len + 1, length(Right_Sublist, R_Len)),

    % Αναδρομική κλήση για τα δύο υπομέρη: Ως αποτέλεσμα εκείνα θα είναι ταξινομημένα και αρκεί απλά να τα ενώσω.
    sort_houses_best_top(Left_Sublist, Sorted_Left_Sublist),
    sort_houses_best_top(Right_Sublist, Sorted_Right_Sublist),
    merge_houses_best_top(Sorted_Left_Sublist, Sorted_Right_Sublist, Sorted_House_Max_Rent_List).

/* ---------------------------------------------------------- *|
|* --        Εύρεση αντιστοίχισης καλύτερων σπιτιών        -- *|
|* -- σε πελάτες όπου διατίθενται να πληρώσουν περισσότερο -- *|
|* ---------------------------------------------------------- */

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ [   Σχόλια - Τρόπος σκέψης για το τμήμα αυτό   ] ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
% Αυτό το τμήμα αναπτύσσεται για να υποστηρίξει την 3η λειτουργία του προγράμματος, δηλαδή αυτή της επιλογής πελατών για κάθε σπίτι βάσει δημοπρασίας.                                                                      %                                                                                                                                  
%                                                                                                                                                                                                                           %
% Στην λειτουργία αυτή:                                                                                                                                                                                                     %
%     1) Όταν υπάρχουν σπίτια τα οποία "διεκδικεί" μόνο ένας υποψήφιος ενοικιαστής (δηλαδή σπίτια που προτείνονται ως "προτιμότερα" μόνο για αυτούς), τότε προφανώς αυτά κατοχυρώνονται σε εκείνους.                        %
%     2) Όταν υπάρχουν σπίτια τα οποία "διεκδικούν" παραπάνω από ένας υποψήφιοι ενοικιαστές (δηλαδή σπίτια που προτείνονται ως "προτιμότερα" για παραπάνω από έναν                                                          %
%       ενοικιαστές), τότε το πρόγραμμα θα "κατοχυρώνει" κάθε διεκδικούμενο σπίτι στον πλειοδότη, δηλαδή σε αυτόν που είναι διατεθειμένος να προσφέρει το μεγαλύτερο ενοίκιο,                                               %
%       και οι υπόλοιποι θα πρέπει να "διεκδικήσουν" ένα από τα υπόλοιπα σπίτια που πληρούν τις απαιτήσεις τους, ξεκινώντας από το (επόμενο) προτιμότερο (δηλαδή αυτό που είναι επόμενο στην φθίνουσα λίστα προτιμήσεων).   %
%     3) Η διαδικασία τερματίζει όταν όλοι οι υποψήφιοι ενοικιαστές έχουν κατοχυρώσει κάποιο σπίτι ή αν δεν μπορεί να κατοχυρωθεί κανένα σπίτι για αυτούς.                                                                  %
%                                                                                                                                                                                                                           %
%                                                                                                                                                                                                                           %
% Η διαδικασία επιλογής (1 και 2 παραπάνω) μπορεί να πραγματοποιηθεί μέσω του αλγορίθμου Gale-Shapley όπου η μεριά που "κάνει πρόταση" είναι εκείνη των υποψήφιων ενοικιαστών (με λίστα προτίμησης εκείνη που απαριθμεί     %
% τα σπίτια που ικανοποιούν τις απαιτήσεις σε φθίνουσα προτίμηση, σύμφωνα με τις κοινές-για-όλους προτιμήσεις). Όσο για την πλευρά που "δέχεται προτάσεις", που είναι τα διαμερίσματα, η λίστα προτίμησης δεν υπάρχει ρητά, %
% αλλά υπονοείται εφόσον προτιμάται πάντα ο ενοικιαστής που προσφέρει μεγαλύτερο ποσό ενοικίου.                                                                                                                             %
%                                                                                                                                                                                                                           %
% Επίσης, μέσω της τροποποίησης που έγινε παρακάτω, κάποιος πελάτης για τον οποίο δεν μπορεί να κατοχυρωθεί κανένα σπίτι, θεωρείται ότι κατοχύρωσε ψευδο-σπίτι όπου σε επόμενο στάδιο θα γίνει η κατάλληλη επεξεργασία για  %
% αντιμετώπιση αυτής της περίπτωσης.                                                                                                                                                                                        %
%                                                                                                                                                                                                                           %
% Ο αλγόριθμος αυτός, βρίσκει τα βέλτιστα για τους πελάτες (δηλαδή το σύνολο των πελατών θα έχει όσο δυνατόν πιο ικανοποιητικά σπίτια) ευσταθή ζεύγη όπου στον κάθε πελάτη προτείνεται να νοικιάσει το σπίτι το οποίο τον   %
% ικανοποιεί περισσότερο από άλλα και για το οποίο κερδίζει τον πλειστηριασμό, δηλαδή διατίθεται να δώσει μεγαλύτερο ενοίκιο από άλλους πιθανούς ενοικιαστές, όπου είναι αυτό το οποίο ζητείται να βρεθεί από την εκφώνηση. %
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %

%% pick_best_request_for_house/3
%% pick_best_request_for_house(House_Maxrent1, House_Maxrent2, MaxRent_House_Maxrent).
%% Αληθεύει εφόσον το MaxRent_House_Maxrent είναι το house_maxrent(House, Max_rent) με το μεγαλύτερο Max_rent. Δηλαδή, "διαλέγεται" εκείνο με το μεγαλύτερο διατιθέμενο ενοίκιο.
%% Στην πράξη (ο τρόπος με το οποίο χρησιμοποιείται) είναι να "δίνεται σαν είσοδος" δύο ζεύγη house_maxrent(House, Max_rent) και ως MaxRent_House_Maxrent να "επιστρέφεται" εκείνο με το μεγαλύτερο Max_rent.
%%
%% Σημείωση, στους όρους House_Maxrent1, House_Maxrent2, το House των δύο αυτών όρων, θεωρείται πως ταυτίζεται. Διαφορετικά αποτυγχάνει, εφόσον η αναμενόμενη χρήση του είναι για σύγκριση προσφορών των δύο πελατών
%% για το ίδιο σπίτι και η επιλογή εκείνου που προσφέρει τα περισσότερα.

% Περίπτωση που ο πρώτος πελάτης είναι "καλύτερος" (διαθέτει μεγαλύτερο ενοίκιο) του δεύτερου.
pick_best_request_for_house(House_Maxrent1, House_Maxrent2, House_Maxrent1) :-
    % "Ξεπακετάρισμα" του συναρτησιακού όρου.
    House_Maxrent1 = house_maxrent(House, Max_rent1), % Πρέπει τα σπίτια να ταυτίζονται εφόσον ψάχνουμε τον "καλύτερο" πελάτη για δεδομένο σπίτι.
    House_Maxrent2 = house_maxrent(House, Max_rent2), !,
    Max_rent1 >= Max_rent2. 

% Περίπτωση που ο πρώτος πελάτης είναι "χειρότερος" (διαθέτει μικρότερο ενοίκιο) του δεύτερου.
pick_best_request_for_house(House_Maxrent1, House_Maxrent2, House_Maxrent2) :-
    % "Ξεπακετάρισμα" του συναρτησιακού όρου.
    House_Maxrent1 = house_maxrent(House, Max_rent1), % Πρέπει τα σπίτια να ταυτίζονται εφόσον ψάχνουμε τον "καλύτερο" πελάτη για δεδομένο σπίτι.
    House_Maxrent2 = house_maxrent(House, Max_rent2), !,
    Max_rent1 < Max_rent2. 

%% stable_renter_house_matching_aux/4
%% stable_renter_house_matching_aux(Request_HouseList, Number_Of_Requests, Current_Matches_List, Best_Matches_List).
%% Βοηθητικό κατηγόρημα του stable_renter_house_matching/2 που υλοποιεί τους υπολογισμούς και του επιστρέφει το αποτέλεσμα.
%% Δέχεται σαν είσοδο μία λίστα από συναρτησιακούς όρους request_house([house_maxrent(house, max_rent), ...], Request) όπου Request ο πιθανός ενοικιαστής και [house_maxrent(house, max_rent), ...]
%%  λίστα με ζεύγη σπιτιών που ικανοποιούν τις απαιτήσεις του (house) και max_rent το μέγιστο ενοίκιο που διατίθεται να δώσει για αυτό το σπίτι, η οποία είναι φθίνουσα ταξινομημένη ως προς τα κοινά 
%%  προς όλους κριτήρια καλύτερου διαμερίσματος.
%% Επιστρέφει μία λίστα (Best_Matches_List) με ζεύγη request_house_match(house_maxrent(house, max_rent), renter) όπου το house είναι το σπίτι (με διατιθέμενο ενοίκιο max_rent) που ο ενοικιαστής 
%%  renter καταλήγει να νοικιάζει στο τέλος του πλειστηριασμού.
%% Το Current_Matches_List "αποθηκεύει" το προσωρινό αποτέλεσμα της Best_Matches_List για κάθε βήμα.
%% Η μεταβλητή Number_Of_Requests είναι βοηθητική και είναι ίση με το αριθμό των πελατών που θέλουμε να αντιστοιχίσουμε με σπίτια.

% Τερματική συνθήκη 1: περίπτωση κενής λίστας με πελάτες προς αναζήτηση (δεν βρήκε κανενας βέλτιστο σπίτι), επιστρέφω το τρέχον προσωρινό ως βέλτιστο.
stable_renter_house_matching_aux([], _Number_Of_Requests, Current_Matches_List, Current_Matches_List) :- !.

% Τερματική συνθήκη 2: αριθμός πελατών ίσος με αριθμό ζευγών: Τότε κάθε πελάτης έχει κάποιο ζευγάρι (εφόσον μόνο να προσθέτω και να τροποποιώ ζευγάρια μπορώ) που είναι η τερματική συνθήκη του Gale-Shapley.
stable_renter_house_matching_aux(_Request_HouseList, Number_Of_Requests, Current_Matches_List, Current_Matches_List) :- length(Current_Matches_List, Number_Of_Requests), !.

% Περίπτωση που ο πελάτης έχει ήδη δεσμεύσει σπίτι: Δεν πρέπει να προχωρήσει σε νέο ζεύγος εφόσον έχει ήδη, οπότε τοποθετείται στο τέλος της λίστας πελατών για να επεξεργαστούμε τον επόμενο και (σταδιακά) να 
%  ανέλθει στη κορυφή κάποιος που δεν έχει ζεύγος για να συνεχίσει η διαδικασία.
stable_renter_house_matching_aux([Request_House | Rest], Number_Of_Requests, Current_Matches, Best_Matches) :-
    % "Ξεπακετάρισμα" του συναρτησιακού όρου.
    Request_House = request_house(Request, _HouseList),

    % Απαιτώ ο πελάτης να έχει ήδη κάποιο διαμέρισμα ως "ζεύγος".
    member(request_house_match(_Some_House, Request), Current_Matches),

    % Αφού το ενοικιαστής στην κορυφή έχει ήδη ζεύγος τον τοποθετώ στο τέλος της λίστας για να βρεθεί στην κορυφή ο επόμενος προς έλεγχο.
    append(Rest, [Request_House], New_Request_House),

    % Αναδρομικό βήμα: Η βέλτιστη λύση του επόμενου βήματος και η βέλτιστη του τωρινού.
    stable_renter_house_matching_aux(New_Request_House, Number_Of_Requests, Current_Matches, Best_Matches), !. % To ! γιατί η αναίρεση αυτού του κανόνα μπορεί να οδηγήσει σε επόμενα ζεύγη που δεν είναι ευσταθή (επομένως λάθος λύσεις).

% Περίπτωση που ο τρέχον πελάτης έχει ελέγξει όλα τα συμβατά με τις απαιτήσεις του σπίτια και δεν υπήρξε κανένα διαθέσιμο στο τελος (τότε έχει κενή λίστα με σπίτια στο request_house).
stable_renter_house_matching_aux([Request_House | Rest], Number_Of_Requests, Current_Matches, Best_Matches) :-
    % "Ξεπακετάρισμα" του συναρτησιακού όρου.
    % Απαιτώ ο ενοικιαστής να έχει κενή λίστα με ικανοποιητικά σπίτια προς έλεγχο.
    Request_House = request_house(Request, []),

    % Σε αυτή την περίπτωση, ο ενοικιαστής δεν θα ανατεθεί σε σπίτι, επομένως κάνουμε μία ψευδο-ανάθεση σε ένα ψευδο-σπίτι που δηλώνει ότι δεν βρέθηκαν σπίτια και απλά ο πελάτης θα αφαιρεθεί από την
    % λίστα των πελατών για τους οποίους "ψάχνουμε" βέλτιστα δυνατά διαμερίσματα.
    % Δηλαδή, θα μπορούσαμε να πούμε πως έγινε ζεύγος από το οποίο σε καμία περίπτωση δεν μπορεί να βρεθεί καλύτερο, και επομένως αφαιρούμε τον πελάτη από την λίστα πελατών που ψάχνουν το καλύτερο σπίτι.
    % Έτσι, ουσιαστικά ο αλγόριθμος θα τρέχει μέχρις ότου όλοι οι πελάτες έχουν ζεύγη (είτε κανονικά είτε ψευδο-ζεύγη).

    % Αναδρομικό βήμα: Η βέλτιστη λύση του επόμενου βήματος θα είναι και η βέλτιστη του τωρινού.
    stable_renter_house_matching_aux(Rest, Number_Of_Requests, [request_house_match(house_maxrent(no_house, -1), Request) | Current_Matches], Best_Matches), !.
     % To ! γιατί η αναίρεση αυτού του κανόνα μπορεί να οδηγήσει σε επόμενα ζεύγη που δεν είναι ευσταθή (επομένως λάθος λύσεις).

% Περίπτωση που το πιο επιθυμητό σπίτι είναι (προσωρινά) "δεσμευμένο" από άλλον ενοικιαστή και ο "τρέχον" πελάτης προτείνει μεγαλύτερο ενοίκιο από τον ήδη υπάρχον του ζεύγους.
stable_renter_house_matching_aux([Request_House | Rest], Number_Of_Requests, Current_Matches, Best_Matches) :-
    % "Ξεπακετάρισμα" του συναρτησιακού όρου.
    % "Διαλέγω" το πιο επιθυμητό σπίτι για τον ενοικιαστή.
    Request_House = request_house(Request, [house_maxrent(House, Max_rent) | Rest_House_Max_Rent]),

    % "Ελέγχω" αν (θεωρώ δεδομένο ότι) υπάρχει το σπίτι House σε "δεσμό" με άλλο πελάτη.
    select(request_house_match(house_maxrent(House, Other_Max_rent), _Other_Request), Current_Matches, Rest_Current_Matches),

    % "Συγκρίνω" τα προσφερόμενα ενοίκια και διαλέγω το μεγαλύτερο από αυτά.
    pick_best_request_for_house(house_maxrent(House, Other_Max_rent), house_maxrent(House, Max_rent), house_maxrent(House, Max_rent)), 
    % Άρα, θα αντικαταστήσω το υπάρχον ζεύγος με το νέο καλύτερο.

    % Αφού βρήκα (προσωρινό) ζεύγος για αυτόν τον πελάτη, τον τοποθετώ στο τέλος της λίστας ενώ "σημειώνω" (αφαιρώ από την λίστα) εκείνο το σπίτι το οποίο ελέγχθηκε (γιατί δεν θα ξανα-ελεγχθεί βάσει του αλγορίθμου).
    append(Rest, [request_house(Request, Rest_House_Max_Rent)], New_Request_House),

    % Αναδρομικό βήμα: Η βέλτιστη λύση του επόμενου βήματος θα είναι και η βέλτιστη του τωρινού.
    stable_renter_house_matching_aux(New_Request_House, Number_Of_Requests, [request_house_match(house_maxrent(House, Max_rent), Request) | Rest_Current_Matches], Best_Matches), !.
    % To ! γιατί η αναίρεση αυτού του κανόνα μπορεί να οδηγήσει σε επόμενα ζεύγη που δεν είναι ευσταθή (επομένως λάθος λύσεις).

% Περίπτωση που το πιο επιθυμητό σπίτι είναι (προσωρινά) "δεσμευμένο" από άλλον ενοικιαστή και ο "τρέχον" πελάτης προτείνει μικρότερο ενοίκιο από τον ήδη υπάρχον του ζεύγους.
stable_renter_house_matching_aux([Request_House | Rest], Number_Of_Requests, Current_Matches, Best_Matches) :-
    % "Ξεπακετάρισμα" του συναρτησιακού όρου.
    % "Διαλέγω" το πιο επιθυμητό σπίτι για τον ενοικιαστή.
    Request_House = request_house(Request, [house_maxrent(House, Max_rent) | Rest_House_Max_Rent]),

    % "Ελέγχω" (θεωρώ δεδομένο ότι) αν υπάρχει το σπίτι House σε "δεσμό" με άλλο πελάτη.
    select(request_house_match(house_maxrent(House, Other_Max_rent), _Other_Request), Current_Matches, _Rest_Current_Matches),

    % "Συγκρίνω" τα προσφερόμενα ενοίκια και διαλέγω το μεγαλύτερο από αυτά.
    pick_best_request_for_house(house_maxrent(House, Other_Max_rent), house_maxrent(House, Max_rent), house_maxrent(House, Other_Max_rent)),
    % Άρα, θα αντικαταστήσω το υπάρχον ζεύγος με το νέο καλύτερο.

    % Αφού βρήκα (προσωρινό) ζεύγος για αυτόν τον πελάτη, δεν τον τοποθετώ στο τέλος της λίστας και "επιμένω" σε αυτόν μέχρι είτε να βρώ ζεύγος είτε να μην υπάρχουν άλλα συμβατά σπίτια διαθέσιμα για αυτόν τον ενοικιαστή.
    % Παράλληλα, "σημειώνω" (αφαιρώ από την λίστα) εκείνο το σπίτι το οποίο ελέγχθηκε (γιατί δεν θα ξανα-ελεγχθεί βάσει του αλγορίθμου).

    % Αναδρομικό βήμα: Η βέλτιστη λύση του επόμενου βήματος θα είναι και η βέλτιστη του τωρινού.
    stable_renter_house_matching_aux([request_house(Request, Rest_House_Max_Rent) | Rest], Number_Of_Requests, Current_Matches, Best_Matches), !.
    % To ! γιατί η αναίρεση αυτού του κανόνα μπορεί να οδηγήσει σε επόμενα ζεύγη που δεν είναι ευσταθή (επομένως λάθος λύσεις).

% Περίπτωση που το πιο επιθυμητό σπίτι δεν είναι "δεσμευμένο" από κανέναν ενοικιαστή.
stable_renter_house_matching_aux([Request_House | Rest], Number_Of_Requests, Current_Matches, Best_Matches) :-
    % "Ξεπακετάρισμα" του συναρτησιακού όρου.
    % "Διαλέγω" το πιο επιθυμητό σπίτι για τον ενοικιαστή.
    Request_House = request_house(Request, [house_maxrent(House, Max_rent) | Rest_House_Max_Rent]),

    % Εφόσον βρισκόμαστε σε εναλλακτική συνθήκη, θεωρώ δεδομένο ότι δεν υπάρχει το σπίτι House σε "δεσμό" με άλλο πελάτη, επομένως απλά προσθέτω το ζεύγος στη κατάλληλη λίστα και προχωράω στο επόμενο βήμα.
    
    % Αφού βρήκα (προσωρινό) ζεύγος για αυτόν τον πελάτη, τον τοποθετώ στο τέλος της λίστας ενώ "σημειώνω" (αφαιρώ από την λίστα) εκείνο το σπίτι το οποίο ελέγχθηκε (γιατί δεν θα ξανα-ελεγχθεί βάσει του αλγορίθμου).
    append(Rest, [request_house(Request, Rest_House_Max_Rent)], New_Request_House),

    % Αναδρομικό βήμα: Η βέλτιστη λύση του επόμενου βήματος θα είναι και η βέλτιστη του τωρινού.
    stable_renter_house_matching_aux(New_Request_House, Number_Of_Requests, [request_house_match(house_maxrent(House, Max_rent), Request) | Current_Matches], Best_Matches).
    
%% stable_renter_house_matching/2
%% stable_renter_house_matching(Request_HouseList, Best_Matches_List).
%% Δέχεται σαν είσοδο μία λίστα από συναρτησιακούς όρους request_house(Request, [house_maxrent(house, max_rent), ...]) όπου Request ο πιθανός ενοικιαστής και [house_maxrent(house, max_rent), ...]
%%  λίστα με ζεύγη σπιτιών που ικανοποιούν τις απαιτήσεις του (house) και max_rent το μέγιστο ενοίκιο που διατίθεται να δώσει για αυτό το σπίτι, η οποία είναι φθίνουσα ταξινομημένη ως προς τα κοινά 
%%  προς όλους κριτήρια καλύτερου διαμερίσματος.
%% Επιστρέφει μία λίστα (Best_Matches_List) με ζεύγη request_house_match(house_maxrent(house, max_rent), renter) όπου το house είναι το σπίτι (με διατιθέμενο ενοίκιο max_rent) που ο ενοικιαστής renter
%%  καταλήγει να νοικιάζει στο τέλος του πλειστηριασμού.
%% Το κύριο έργο πραγματοποιείται από το βοηθητικό κατηγόρημα stable_renter_house_matching_aux/4, όπου το τρέχον απλά αρχικοποιεί μεταβλητές του βοηθητικού.

% Περίπτωση κενής λίστας με πελάτες προς αναζήτηση (δόθηκε κενή λίστα πελατών), απλά αποτυγχάνει γιατί αφενός δεν είναι έγκυρη ενέργεια και αφετέρου για να "προστατέψει" το κατηγόρημα.
stable_renter_house_matching_aux([], _Number_Of_Requests, Current_Matches_List, Current_Matches_List) :- fail.

% Αρχικοποίηση μεταβλητών και εκκίνηση διαδικασίας.
stable_renter_house_matching(Request_HouseList, Best_Matches_List) :-
    % Υπολογισμός μήκους.
    length(Request_HouseList, Number_Of_Requests),
    stable_renter_house_matching_aux(Request_HouseList, Number_Of_Requests, [], Best_Matches_List).

/* --------------------------------------- *|
|* --           Λειτουργία 1            -- *|
|* -- Εκτέλεση διαδραστικής λειτουργίας -- *|
|* --------------------------------------- */ 

%% mode_1/11
%% mode_1(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses, Best_House_Addr).
%% Δέχεται σαν είσοδο τις απαιτήσεις του υποψήφιου ενοικιαστή και επιστρέφει λίστα (Compatible_Houses) με ένα ή περισσότερα διαμερίσματα που ικανοποιούν τις απαιτήσεις του υποψήφιου ενοικιαστή
%% (με ολόκληρους τους συναρτησιακούς όρους house/9).
%% Επίσης, επιστρέφει λίστα με τις διευθύνσεις (Best_House_Addr) των καλύτερων (προτεινόμενων) σπιτιών, σύμφωνα με τις κοινές-για-όλους προτιμήσεις.
mode_1(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses, Best_House_Addr) :-
    % Βρίσκω τα συμβατά, με τις απαιτήσεις του υποψήφιου ενοικιαστή, σπίτια.
    compatible_houses(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses),

    % Βρίσκω τα προτεινόμενα (καλύτερα) σπίτια.
    find_best_house(Compatible_Houses, Best_House_Addr).

/* --------------------------------- *|
|* --        Λειτουργία 2         -- *|
|* -- Μαζικές προτιμήσεις πελατών -- *|
|* --------------------------------- */ 

%% mode_2/3
%% mode_2(Renter_Name, Compatible_Houses, Best_House_Addr).
%% Δέχεται σαν είσοδο το όνομα ενός υποψήφιου ενοικιαστή και επιστρέφει λίστα (Compatible_Houses) με ένα ή περισσότερα διαμερίσματα που ικανοποιούν τις απαιτήσεις του υποψήφιου ενοικιαστή
%% (με ολόκληρους τους συναρτησιακούς όρους house/9).
%% Επίσης, επιστρέφει λίστα με τις διευθύνσεις (Best_House_Addr) των καλύτερων (προτεινόμενων) σπιτιών, σύμφωνα με τις κοινές-για-όλους προτιμήσεις.
mode_2(Renter_Name, Compatible_Houses, Best_House_Addr) :-
    % Εντοπίζω τις απαιτήσεις του κατονομαζόμενου πιθανού ενοικιαστή.
    request(Renter_Name, Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden),

    % Βρίσκω τα συμβατά σπίτια και το(-α) καλύτερο(-α).
    mode_1(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses, Best_House_Addr).


/* -------------------------------------- *|
|* --           Λειτουργία 3           -- *|
|* -- Επιλογή πελατών μέσω δημοπρασίας -- *|
|* -------------------------------------- */ 


%% simplify_match_results/2
%% simplify_match_results(Complex_List, Simple_List).
%% Ώς λειτουργία του έχει να απλοποιεί τα "αποτελέσματα" του κατηγορήματος stable_renter_house_matching και να τα μετατρέπει σε (απλούστερη) λίστα ζευγών renter_name_house_addr(name, addr), 
%% όπου name το όνομα του υποψήφιου ενοικιαστή και addr η διεύθυνση του διαμερίσματος το όποιο πλειοδότησε εκείνος. 
%% Σε περίπτωση που δεν βρέθηκε διαμέρισμα για κάποιον πελάτη, εκείνος ως addr θα έχει αντιστοιχηθεί με το άτομο 'no_house'.

% Περίπτωση κενής λίστας: Απλά επιστρέφω την κενή λίστα σαν αποτέλεσμα (η απλοποίηση των στοιχείων κενής λίστας είναι η κενή λίστα).
simplify_match_results([], []).

% Γενική περίπτωση.
simplify_match_results([request_house_match(House_Max_Rent, Name) | C_Rest], [renter_name_house_addr(Name, Addr) | S_Rest]) :-
    % Εξαγωγή των ζητούμενων πληροφοριών.
    House_Max_Rent = house_maxrent(house(Addr, _Sleeping_Quarters, _Floor_Area, _At_Center, _Floor, _Has_Elevator, _Allows_Pets, _Garden_Area, _Rent), _Max_Willing_Rent),

    % Αναδρομική κατασκευή αποτελέσματος.
    simplify_match_results(C_Rest, S_Rest).

% Περίπτωση όπου στο κατηγόρημα κορυφής ο ενοικιαστής δεν αντιστοιχείται σε κανένα σπίτι.
simplify_match_results([request_house_match(House_Max_Rent, Name) | C_Rest], [renter_name_house_addr(Name, no_house) | S_Rest]) :-
    % Εξαγωγή των ζητούμενων πληροφοριών.
    House_Max_Rent = house_maxrent(no_house, _Max_Willing_Rent),

    % Αναδρομική κατασκευή αποτελέσματος.
    simplify_match_results(C_Rest, S_Rest).


%% find_sorted_compatible_house_list/2
%% find_sorted_compatible_house_list(Name_List, Request_House).
%% Δέχεται μία λίστα με ονόματα υποψήφιων ενοικιαστών (Name_List) και για τον πρώτο πελάτη της λίστας επιστρέφει φθίνουσα ταξινομημένη λίστα ζευγών ικανοποιητικών σπιτιών και μέγιστου ενοικίου για αυτά όπου στην κορυφή βρίσκεται 
%% το πιο επιθυμητό (καλύτερο) σπίτι και στο τελευταίο στοιχείο το λιγότερο επιθυμητό, σύμφωνα με τις κοινές-για-όλους προτιμήσεις.
%% Εναλλακτικές λύσεις δίνουν την αντίστοιχη λίστα ζευγών για τον 2ο, 3ο, κ.ο.κ. ενοικιαστή.

% Κύρια περίπτωση: Εύρεση λίστας για τον πρώτο πελάτη της λίστας.
find_sorted_compatible_house_list([Name | _Rest_Names], request_house(Name, Sorted_House_Max_Rent_List)) :-
    % Εντοπίζεται το αίτημα του ενοικιαστή.
    request(Name, Min_Area, Min_Sleeping_Quarters, Req_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden),

    % Βρίσκονται τα συμβατά, με τις απαιτήσεις του ενοικιαστή, σπίτια.
    compatible_houses_w_maxrent(Min_Area, Min_Sleeping_Quarters, Req_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, House_Maxrent_List),

    % Τα συμβατά σπίτια ταξινομούνται από το πιο επιθυμητό προς το λιγότερο.
    sort_houses_best_top(House_Maxrent_List, Sorted_House_Max_Rent_List).
    
% Εναλλακτική περίπτωση: Εύρεση λίστας για τον επόμενο πελάτη της λίστας.
find_sorted_compatible_house_list([_Name | Rest_Names], Request_House) :-
    find_sorted_compatible_house_list(Rest_Names, Request_House).


%% mode_3/2
%% mode_3(Name_List, Resulting_Matches)
%% Δέχεται σαν είσοδο λίστα με ονόματα των υποψήφιων ενοικιαστών και επιστρέφει μία λίστα με ζεύγη renter_name_house_addr(name, addr), όπου name το όνομα του υποψήφιου ενοικιαστή και addr η διεύθυνση του διαμερίσματος το
%% όποιο πλειοδότησε εκείνος. Σε περίπτωση που δεν βρέθηκε διαμέρισμα για κάποιον πελάτη, εκείνος ως addr θα έχει αντιστοιχηθεί με το άτομο 'no_house'.

mode_3(Name_List, Resulting_Matches) :- 
    % Για όλους τους ενοικιαστές, βρίσκω τα συμβατά (με τις απαιτήσεις του) σπίτια και "παίρνω" την ταξινομημένη λίστα αυτών.
    % Τα αποτελέσματα αυτά, εισάγονται στην συνέχεια σε μία νέα λίστα.
    findall(Request_House, find_sorted_compatible_house_list(Name_List, Request_House), Request_House_List),

    % Εκτέλεση "πλειστηριασμού": Για κάθε πιθανό ενοικιαστή, βρίσκω το σπίτι το οποίο τον ικανοποιεί όσο το δυνατόν περισσότερο και παράλληλα είναι
    % εκείνος ο οποίος διαθέτει τα περισσότερα (σε σχέση με τους άλλους) ενοίκιο για αυτό.
    stable_renter_house_matching(Request_House_List, Best_Matches_List),

    % Επειδή τα αποτελέσματα του stable_renter_house_matching, είναι σε δυσνόητη μορφή, μετατρέπονται σε απλούστερα ζεύγη renter_name_house_addr(name, addr).
    simplify_match_results(Best_Matches_List, Resulting_Matches).