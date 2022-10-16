% This file is encoded in UTF-8.

/* ---------------------------------------- *|
|* -- Ονοματεπώνυμο: Μπαρακλιλής Ιωάννης -- *|
|* --             ΑΕΜ: 3685              -- *|
|* ---------------------------------------- */ 

% Σημείωση: Το τρέχον αρχείο υλοποιεί το μέρος του περιβάλλοντος αλληλεπίδρασης (CLI) με τον χρήστη και στηρίζεται στα κατηγορήματα του αρχείου logic.pl (το οποίο "φορτώνει" κατά την κλήση του run) για εκτέλεση υπολογισμών.

:- encoding(utf8). % Ορίζεται ότι αυτό το αρχείο είναι κωδικοποιημένο σε  UTF-8 και έτσι πρέπει να το αναγνωρίζει η Prolog.

/* ------------------------------------------------ *|
|* -- Επικυρωμένη επιλογή λειτουργίας απο χρήστη -- *|
|* ------------------------------------------------ */ 

%% ensure_right_menu_selection/2.
%% ensure_right_menu_selection(Inp, Outp).
%% Ελέγχει την επιλογή του χρήστη (Inp) και την "επιστρέφει" (Outp) εφόσον είναι σωστή.
%% Άν όχι, εμφανίζει εκ νέου το μενού και εκτελεί το πάνω.
ensure_right_menu_selection(1, 1).
ensure_right_menu_selection(2, 2).
ensure_right_menu_selection(3, 3).
ensure_right_menu_selection(0, 0).
ensure_right_menu_selection(_, Y) :-
    % Αν η επιλογή του χρήστη δεν είναι κάποια από τις παραπάνω, τότε τυπώνεται μήνυμα και να επανέρχεται το πρόγραμμα στο μενού.
    write('Επίλεξε έναν αριθμό μεταξύ 0 έως 3!'), nl, nl, nl,

    print_menu,
    % Διαβάζω νέα επιλογή.
    read(X), nl, nl,
    ensure_right_menu_selection(X, Y).

%% safe_read_menu_selection/1.
%% safe_read_menu_selection(X).
%% Διαβάζει την επιλογή (μενού) του χρήστη και την "επιστρέφει" (X), αν είναι σωστή.
%% Διαφορετικά, την ζητάει επαναληπτικά μέχρι να είναι ορθή.
safe_read_menu_selection(X) :-
    read(Temp), nl, nl,
    ensure_right_menu_selection(Temp, X).


/* ----------- *|
|* -- Μενού -- *|
|* ----------- */ 

%% print_menu/0.
%% Τυπώνεται το μενού όπου εμφανίζονται οι διαθέσιμες επιλογές και μετά μία προτροπή για επιλογή.
print_menu :-
    write("Μενού:"), nl,
    write("======"), nl,
    nl,
    write("1. - Προτιμήσεις ενός πελάτη"), nl,
    write("2. - Μαζικές προτιμήσεις πελατών"), nl,
    write("3. - Επιλογή πελατών μέσω δημοπρασίας"), nl,
    write("0. - Έξοδος"), nl,
    nl,
    write("Επιλογή: ").

/* ------------------------------------------ *|
|* -- Εκτύπωση στοιχείων σπιτιών - Πελατών -- *|
|* ------------------------------------------ */ 

%% print_house/1
%% print_house(House).
%% Εκτυπώνει στην έξοδο όλες τις πληροφορίες για ένα σπίτι.
print_house(House) :-
    % "Ξεπακετάρισμα" του κατηγορήματος του σπιτιού.
    House = house(Address, Sleeping_Quarters, Floor_Area, At_Center, Floor, Has_Elevator, Allows_Pets, Garden_Area, Rent),

    % Εκτύπωση δεδομένων.
    write("Κατάλληλο σπίτι στην διεύθυνση: "), write(Address), nl,
    write("Υπνοδωμάτια: "), write(Sleeping_Quarters), nl,
    write("Εμβαδόν: "), write(Floor_Area), nl,
    write("Εμβαδόν κήπου: "), write(Garden_Area), nl,
    write("Είναι στο κέντρο της πόλης: "), write(At_Center), nl,
    write("Επιτρέπονται κατοικίδια: "), write(Allows_Pets), nl,
    write("Όροφος: "), write(Floor), nl,
    write("Ανελκυστήρας: "), write(Has_Elevator), nl,
    write("Ενοίκιο: "), write(Rent), nl.
    
    
%% print_houses/1
%% print_houses(House_List).
%% Εκτυπώνει στην έξοδο όλες τις πληροφορίες για μία λίστα σπιτιών.

% Συνθήκη κενής λίστας: Δεν υπάρχουν διαθέσιμα σπίτια!
print_houses([]) :-
    write("Δεν υπάρχει κατάλληλο σπίτι!").

% Τερματική συνθήκη: Λίστα με ένα στοιχείο: Απλά κάνω μία εκτύπωση.
print_houses([House]) :-
    print_house(House).

% Αναδρομική επανάληψη εκτυπώσεων.
print_houses([House | Rest]) :-
    print_house(House),
    nl,
    print_houses(Rest).
        
%% print_best_addresses/1
%% print_best_addresses(Address_List).
%% Εκτυπώνει στην έξοδο όλες τις διευθύνσεις των σπιτιών (μπορεί να υπάρχουν περισσότερα από ένα καλύτερα) για τα οποία προτείνεται η ενοικίαση (μαζί με αντίστοιχο μήνυμα: "Προτείνεται η ενοικίαση του διαμερίσματος στην διεύθυνση: ...").

% Τερματική συνθήκη: Κενή λίστα, καμία ενέργεια, απλά επιτυγχάνει η κλήση (και οι υπόλοιπες αναδρομικές).
print_best_addresses([]).

% Αναδρομική επανάληψη εκτυπώσεων.
print_best_addresses([Address | Rest]) :-
    write("Προτείνεται η ενοικίαση του διαμερίσματος στην διεύθυνση: "), write(Address),
    nl,
    print_best_addresses(Rest).


%% find_and_print_all_renter_matches/1
%% find_and_print_all_renter_matches(Renter_Name_List)
%% Δέχεται σαν είσοδο μία λίστα με πελάτες και για τον κάθε ένα θα τυπώνει το όνομα του και τα συμβατά σπίτια (τα οποία εντοπίζονται) καθώς και το προτεινόμενο προς ενοικίαση.

% Τερματική συνθήκη: Κενή λίστα, απλά αληθεύει (και μαζί η ακολουθία αναδρομικών κλήσεων).
find_and_print_all_renter_matches([]).

find_and_print_all_renter_matches([Renter_Name | Rest]) :-
    % Βρίσκω τα καλύτερα σπίτια και την διεύθυνση του καλύτερου.
    mode_2(Renter_Name, Compatible_Houses, Best_House_Addr),  % Απο αρχείο logic.pl.

    write("Κατάλληλα διαμερίσματα για τον πελάτη: "), write(Renter_Name), write(":"), nl,
    write("======================================="), nl,

    % Εκτύπωση αποτελεσμάτων.
    print_houses(Compatible_Houses), nl,
    print_best_addresses(Best_House_Addr), nl, nl,

    find_and_print_all_renter_matches(Rest).

%% print_auction_results/1
%% print_auction_results(Matches).
%% Εκτυπώνει τα αποτελέσματα του πλειστηριασμού που υπολογίστηκαν και αποθηκεύτηκαν στην λίστα Matches που περιέχει στοιχεία renter_name_house_addr(name, addr).

% Σε κενή λίστα δεν τυπώνω τίποτα και έχω επιτυχία.
print_auction_results([]).

% Περίπτωση όπου ο ενοικιαστής που βρίσκεται στην κορυφή της λίστας δεν έχει αντιστοιχηθεί σε σπίτι.
print_auction_results([Name_Addr | Rest]) :-
    % Εξαγωγή στοιχείων και απαίτηση να μην υπάρχει αντιστοίχιση.
    Name_Addr = renter_name_house_addr(Name, no_house), !, % Το '!' είναι απαραίτητο γιατί η εναλλακτική περίπτωση θα "γράψει" ότι νοικιάζει το "no_house"!

    write("Ο πελάτης "), write(Name), write(" δεν θα νοικιάσει κάποιο διαμέρισμα!"), nl,

    print_auction_results(Rest).

% Κανονική περίπτωση όπου ο ενοικιαστής που βρίσκεται στην κορυφή της λίστας και έχει αντιστοιχηθεί σε σπίτι.
print_auction_results([Name_Addr | Rest]) :-
    % Εξαγωγή στοιχείων και απαίτηση να υπάρχει αντιστοίχιση.
    Name_Addr = renter_name_house_addr(Name, Addr), !,

    write("Ο πελάτης "), write(Name), write(" θα νοικιάσει το διαμέρισμα στην διεύθυνση: "), write(Addr), nl,

    print_auction_results(Rest).



/* -------------------------- *|
|* -- Εκτέλεση λειτουργιών -- *|
|* -------------------------- */ 

%% function/1
%% function(F).
%% Εκτέλεση αντίστοιχης λειτουργίας: 1 για διαδραστική λειτουργία, 2 για batch mode, 3 για λειτουργία δημοπρασίας.

% Εκτέλεση διαδραστικής λειτουργίας.
function(1) :- 
    % Διαδραστική άντληση πληροφοριών από τον χρήστη.
    write("Δώσε τις παρακάτω πληροφορίες:"), nl,
    write("=============================="), nl,
    write("Ελάχιστο Εμβαδόν: "), read(Min_Area), 
    write("Ελάχιστος αριθμός υπονοδωματίων: "), read(Min_Sleeping_Quarters), 
    write("Να επιτρέπονται κατοικίδια; (yes/no) "), read(Requires_Pets),
    write("Από ποιον όροφο και πάνω να υπάρχει ανελκυστήρας; "), read(Elevator_Limit),
    write("Ποιο είναι το μέγιστο ενοίκιο που μπορείς να πληρώσεις; "), read(Max_Rent),
    write("Πόσα θα έδινες για ένα διαμέρισμα στο κέντρο της πόλης (στα ελάχιστα τετραγωνικά); "), read(Max_Rent_Center), 
    write("Πόσα θα έδινες για ένα διαμέρισμα στα προάστια της πόλης (στα ελάχιστα τετραγωνικά);"), read(Max_Rent_Suburbs), 
    write("Πόσα θα έδινες για κάθε τετραγωνικό διαμερίσματος πάνω από το ελάχιστο; "), read(Bonus_Area),
    write("Πόσα θα έδινες για κάθε τετραγωνικό κήπου; "), read(Bonus_Garden),
    nl,

    % Εύρεση σχετικών διαμερισμάτων.
    mode_1(Min_Area, Min_Sleeping_Quarters, Requires_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden, Compatible_Houses, Best_House_Addr),  % Απο αρχείο logic.pl.

    % Εκτύπωση αποτελεσμάτων.
    print_houses(Compatible_Houses), nl,
    print_best_addresses(Best_House_Addr), nl, nl.


% Εκτέλεση λειτουργίας batch mode.
function(2) :- 
    % Βρίσκω τα ονόματα όλων των πελατών.
    findall(Name, request(Name, _, _, _, _, _, _, _, _, _), Name_List),

    % Εύρεση και εκτύπωση αποτελεσμάτων για κάθε ενοικιαστή.
    find_and_print_all_renter_matches(Name_List).


% Εκτέλεση λειτουργίας δημοπρασίας.
function(3) :- 
    % Βρίσκω τα ονόματα όλων των ενοικιαστών για τους οποίους πρέπει να εκτελεστεί πλειστηριασμός.
    findall(Name, request(Name, _, _, _, _, _, _, _, _, _), Name_List),

    % Εκτέλεση "πλειστηριασμού"
    mode_3(Name_List, Resulting_Matches), 
    
    print_auction_results(Resulting_Matches), nl, nl.



/* --------------------------------------------------- *|
|* -- Επαναληπτική επιλογή λειτουργίας και εκτέλεση -- *|
|* --------------------------------------------------- */ 

%% begin/1
%% begin(Mode).
%% Βοηθητικό κατηγόρημα που ξεκινά την (αναδρομική) εκτέλεση του προγράμματος και εκτελεί συνεχώς λειτουργίες μέχρι να ζητηθεί έξοδος (0).

% Έξοδος: Απλά είναι αληθές και "αφήνει" το πρόγραμμα να τερματίσει.
begin(0).

% Επαναληπτική εκτέλεση λειτουργιών μέχρι να ζητηθεί έξοδος.
begin(Execution_mode) :-
    % Εκτέλεση λειτουργίας.
    function(Execution_mode),

    % Μετά την εκτέλεση της λειτουργίας γίνεται "επιστροφή" και τυπώνεται το μενού όπου εμφανίζονται οι διαθέσιμες επιλογές.
    print_menu,

    % Στη συνέχεια, διαβάζεται η επιλογή του χρήστη (με έλεγχος ορθότητας επιλογής) και εκτελείται η επιλεγμένη λειτουργία.
    safe_read_menu_selection(New_Execution_mode),

    % Επανάληψη.
    begin(New_Execution_mode).

/* ------------------------------------ *|
|* -- Φόρτωση εξωτερικών πληροφοριών -- *|
|* ------------------------------------ */ 

%% load_external_data/0
%% Φορτώνει τα κατηγορήματα υπολογισμών - λογικής από το αρχείο logic.pl και τα δεδομένα σπιτιών και πελατών από τα αντίστοιχα αρχεία.

load_external_data :-
    % "Φόρτωση" της λογικής.
    consult("logic.pl"),

    % "Διάβασμα" δεδομένων.
    consult("houses.pl"), consult("requests.pl").

/* ----------------------  *|
|* -- Κύριο Κατηγόρημα --  *|
|* ----------------------  */ 

%% run/0
%% Το κύριο κατηγόρημα του προγράμματος που θα αντιστοιχούσε σε μία συνάρτηση main.
run :- 
    % Φόρτωση εξωτερικών πληροφοριών.
    load_external_data,

    nl,

    % Τυπώνεται το μενού όπου εμφανίζονται οι διαθέσιμες επιλογές.
    print_menu,

    % Στη συνέχεια, διαβάζεται η επιλογή του χρήστη (με έλεγχος ορθότητας επιλογής) και εκτελείται η επιλεγμένη λειτουργία.
    safe_read_menu_selection(Execution_mode),

    % Εκκίνηση κυρίως προγράμματος.
    begin(Execution_mode).
