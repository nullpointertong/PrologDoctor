/*
 * Lists for rules/facts
*/

   :- dynamic pain/1.
   :- dynamic mood/1.
   :- dynamic fever/1.
   :- dynamic cold/1.
   :- dynamic injury/1.
   :- dynamic gesture/1.
   :- dynamic cough/1.
   :- dynamic muccus/1.

   /*All the libraries required for the prolog script to work*/
   pain_library([unbearable_pain, lot_of_pain, manageable_pain, mild_pain, no_pain]).
   mood_library([calm, angry, weepy, stressed]).
   polite_gesture([look_concerned,mellow_voice,light_touch, faint_smile]).
   calming_gesture([greet, look_composed, look,attentive]).
   normal_gesture([broad_smile, joke, beaming_voice]).
  /*Symptom Libraries*/
   fever_library([low, medium, high]).
   cold_library([light, medium, heavy]).
   injury_library([light,heavy]).
   cough_library([light, medium, heavy]).
   muccus_library([low,medium,high]).

/*Functions to tell if a list is empty or not*/
list_empty([]):-
   true().
list_empty([_|_]):-
   false().

/*Global facts to keep track of pain,mood,all symptoms and gesture*/
   pain().
   mood().
   fever().
   cold().
   injury().
   cough().
   muccus().
   gesture().
   name().

/*Start the script for the diagnosis */
start:-
   newPatient(),
   getGesture(),
   getPain(),
   getMood(),
   getFever(),
   getCold(),
   getInjury(),
   getCough(),
   getMuccus(),
   diagnose().

/*Check if the user types yes or no*/
userInput(X):-
   X == 'yes'.

/*Function overloading passing the right library to the functions*/
getGesture():-
   polite_gesture(X),
   calming_gesture(Y),
   normal_gesture(Z),
   getGesture(X,Y,Z).

getPain():-
   pain_library(X),
   getPain(X).

getMood():-
   mood_library(X),
   getMood(X).

getFever():-
   fever_library(X),
   getFever(X).

getCold():-
   cold_library(X),
   getCold(X).

getInjury():-
   injury_library(X),
   getInjury(X).

getCough():-
   cough_library(X),
   getCough(X).

getMuccus():-
   muccus_library(X),
   getMuccus(X).

getGesture(X,Y,Z):-
  (
     /*Calm the patient down if they are feeling lots of pain or are weepy or angry*/
    (pain(unbearable_pain); pain(lot_of_pain),mood(weepy); mood(angry)),
     GL=Y;

    /*If patient is feeling anything else be polite*/
    (pain(manageable_pain);pain(mild_pain);pain(no_pain),mood(stressed);mood(calm)),
     GL=X;

    /*If the patient just entered be normal*/
    (mood(),pain()),
     GL=Z
   ),
     /*Find and set random gesture within the selected gesture list*/
     random_member(G, GL),
     asserta(gesture(G)).

/*Identify pain level */
getPain(List):-
   /*Generate pick and output new gesture*/
   getGesture(),
   gesture(G),
   format("\n*~w*\n",G),
   /*Spilt the option into head and tail and recusively call function until yes or the list is empty*/
   [H|T]=List,
   format("Are you feeling ~w?",[H]),
   read(X),
   ((userInput(X);list_empty(T))->assert(pain(H));
   getPain(T)
   ).

/*
Similarly, identify mood level
*/
getMood(List):-
   /*Generate pick and output new gesture*/
   getGesture(),
   gesture(G),
   format("\n*~w*\n",G),
   /*Spilt the option into head and tail and recusively call function until yes or the list is empty*/
   [H|T]=List,
   format("Are you feeling ~w?",[H]),
   read(X),
  ((userInput(X);list_empty(T))->assert(mood(H));
    getMood(T)
   ).

/*
Similarly, identify Fever,Cold and Injury
*/
getFever(List):-
   /*Generate pick and output new gesture*/
   getGesture(),
   gesture(G),
   format("\n*~w*\n",G),
   /*Spilt the option into head and tail and recusively call function until yes or the list is empty*/
   [H|T]=List,
   format("Are you experiencing a ~w fever?",[H]),
   read(X),
  ((userInput(X);list_empty(T))->assert(fever(H));
    getFever(T)
   ).

getCold(List):-
   /*Generate pick and output new gesture*/
   getGesture(),
   gesture(G),
   format("\n*~w*\n",G),
   /*Spilt the option into head and tail and recusively call function until yes or the list is empty*/
   [H|T]=List,
   format("Are you experiencing ~w cold symptoms",[H]),
   read(X),
  ((userInput(X);list_empty(T))->assert(cold(H));
    getCold(T)
   ).

getInjury(List):-
   /*Generate pick and output new gesture*/
   getGesture(),
   gesture(G),
   format("\n*~w*\n",G),
   /*Spilt the option into head and tail and recusively call function until yes or the list is empty*/
   [H|T]=List,
   format("Are you experiencing a ~w injury",[H]),
   read(X),
  ((userInput(X);list_empty(T))->assert(injury(H));
    getInjury(T)
   ).

getCough(List):-
   /*Generate pick and output new gesture*/
   getGesture(),
   gesture(G),
   format("\n*~w*\n",G),
   /*Spilt the option into head and tail and recusively call function until yes or the list is empty*/
   [H|T]=List,
   format("Are you experiencing a ~w cough?",[H]),
   read(X),
  ((userInput(X);list_empty(T))->assert(cough(H));
    getCough(T)
   ).

getMuccus(List):-
   /*Generate pick and output new gesture*/
   getGesture(),
   gesture(G),
   format("\n*~w*\n",G),
   /*Spilt the option into head and tail and recusively call function until yes or the list is empty*/
   [H|T]=List,
   format("Do you have ~w muccus?",[H]),
   read(X),
  ((userInput(X);list_empty(T))->assert(muccus(H));
    getMuccus(T)
   ).

/*
Define the disease criteria based on levels of symptoms:
   fever  low, medium, high
   cold   light, medium, heavy
   injury light,heavy
   cough  light, medium, heavy
   muccus low,medium,high
*/
depression():-
   mood(weepy),
   fever(),
   cold(),
   injury(),
   cough(),
   muccus().

flu():-
   fever(low),
   cold(light),
   injury(light),
   cough(heavy),
   muccus(high).

physical_trauma():-
   fever(high),
   cold(heavy),
   injury(heavy),
   cough(light),
   muccus(low).

measles():-
   fever(high),
   cold(heavy),
   injury(light),
   cough(medium),
   muccus(medium).

mumps():-
   fever(medium),
   cold(medium),
   injury(light),
   cough(light),
   muccus(low).

pneumonia():-
   fever(low),
   cold(heavy),
   injury(light),
   cough(heavy),
   muccus(high).

/*Checks meets conditions for which disease and then formats an email to
 patient */
diagnose():-
   name(N),
   nl,
   format("\nFrom: doctor@telecomhealth.com <doctor@telecomhealth.com>
   \nTo: ~w@gmail.com",N),
   format(" <~w@gmail.com>
   \nSent: Wednesday, 1 April 2020, 12:58:42 am AEDT
   \nSubject: Diagnosis",N),
   format("\n\n\n"),
   format("Dear ~w,",N),
   format("\n"),
   format("\n"),
   (
     /*Write a different email body depending on the diagonisis*/
     depression() -> format("To me it seems that you may have depression would you like me to write a referral to the psycologist?");
     flu()-> format("You seem to be suffering from the flu i've attached some prescriptions to the email please take care.");
     physical_trauma()-> format("It seems you've suffered from physical trauma go to the nurses room with the attached note and they should patch you      up!");
     measles()-> format("The lab results and your symptoms indicate you might have measles please self isolate i'm going to call the hospital.");
     mumps()->format("Your labs results and the symtpoms indicate you might have mumps it looks like we need to send you to the hospital.");
     pneumonia()->format("Your labs results and the symtpoms indicate you may have pneumonia i've attached a script for antibotics.");
     format("Your lab results have come back inconclusive and your symptoms seem irregular we might need a follow up consultation.")
   ),
   format("\n"),
   format("\nKind Regards, \n\nDoctor Telecom").

/*
 * Clear all facts if the diagonisis starts again
*/
newPatient():-
   retractall(mood(_)),
   retractall(pain(_)),
   retractall(fever(_)),
   retractall(cold(_)),
   retractall(injury(_)),
   retractall(cough(_)),
   retractall(muccus(_)),
   retractall(gesture(_)),
   /*Ask and get name*/
   format("Hello, Welcome to the clinic what is your name? (Type the name surround with '' e.g 'Eric'.)"),
   nl,
   read(S),
   asserta(name(S)),
   format("\nHello, ~w let me start by asking you a series of questions\n",S).





























