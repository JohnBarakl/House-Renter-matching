encoding(utf8). % Ορίζεται ότι αυτό το αρχείο είναι κωδικοποιημένο σε  UTF-8 και έτσι πρέπει να το αναγνωρίζει η Prolog.

% request(Ενοικιαστής, Ελάχιστο_Εμβαδόν, Ελάχιστα_Υπνοδωμάτια, Απαίτηση_για_Κατοικίδια, Όριο_Ορόφου_για_Ανελκυστήρα, Μέγιστο_Ενοίκοιο, Μέγιστο_Ενοίκοιο_Κέντρο, Μέγιστο_Ενοίκοιο_Προάστιο, Προσαύξηση_Εμβαδού, Προσαύξηση_Κήπου).
% request(Name, Min_Area, Min_Sleeping_Quarters, Req_Pets, Elevator_Limit, Max_Rent, Max_Rent_Center, Max_Rent_Suburbs, Bonus_Area, Bonus_Garden).

request("John Smith",45,2,yes,3,400,300,250,5,2).
request("Nick Cave",55,2,yes,3,450,350,300,7,3).
request("George Harris",50,3,yes,1,500,350,300,7,5).
request("Harrison Ford",50,2,no,0,370,300,350,5,0).
request("Will Smith",100,5,yes,0,100,50,25,2,1).
