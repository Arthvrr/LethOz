local 
   % Vous pouvez remplacer ce chemin par celui du dossier qui contient LethOzLib.ozf

   Dossier = {Property.condGet cwdir '/Users/arthurlouette/Documents/Concepts des Langages de Programmation - LINFO1104/Projet/2024/LethOz'}
   LethOzLib

   % Les deux fonctions que vous devez implémenter
   Next
   DecodeStrategy
   
   % Hauteur et largeur de la grille
   % (1 <= x <= W=24, 1 <= y <= H=24)
   W = 24
   H = 24

   Options
in
   % Merci de conserver cette ligne telle qu'elle.
   [LethOzLib] = {Link [Dossier#'/'#'LethOzLib.ozf']}
   {Browse LethOzLib.play}

%%%%%%%%%%%%%%%%%%%%%%%%
% Votre code vient ici %
%%%%%%%%%%%%%%%%%%%%%%%%

   local
      % Déclarez vos functions ici
      X
      RemoveFirst
      FoldL
      Replicate
   in

      %FONCTIONS ANNEXES, UTILISÉES POUR LES 2 FONCTIONS DE BASE


      % Fonction permettant d'enlever le premier élément d'une liste qui nous servira dans le cas de la fonction Next,
      % pour former la nouvelle Queue NewPositions
      fun {RemoveFirst L}
         case L of
         nil then nil
         [] X|Xs then Xs
         end
      end

      % Fonction FoldL, qui pour rappel permet d'appliquer une fonction à chaque élément d'une liste
      % que l'on va utiliser dans la fonction DecodeStrategy
      fun {FoldL Fun Initial List}
         case List of
         nil then Initial
         []X|Xs then
            {FoldL Fun {Fun Initial X} Xs}
         end
      end

      % Fonction Replicate, qui permet de répliquer un élément donné un certain nombre de fois et retourner la liste
      fun {Replicate Element Times}
         case Times of
         0 then nil %Si Times vaut 0, on retourne nil
         []_ then Element | {Replicate Element Times-1} %On appelle récursivement Replicate en décrément de 1 Times
         end
      end



      %LES 2 FONCTIONS DE BASE, NEXT ET DECODESTRATEGY


      % La fonction qui renvoit les nouveaux attributs du serpent après prise
      % en compte des effets qui l'affectent et de son instruction
      % 
      % instruction ::= forward | turn(left) | turn(right)
      % P ::= <integer x such that 1 <= x <= 24>
      % direction ::= north | south | west | east
      % spaceship ::=  spaceship(
      %               positions: [
      %                  pos(x:<P> y:<P> to:<direction>) % Head
      %                  ...
      %                  pos(x:<P> y:<P> to:<direction>) % Tail
      %               ]
      %               effects: [scrap|revert|wormhole(x:<P> y:<P>)|... ...]
      %            )
      fun {Next Spaceship Instruction} Positions Head Tail Last Direction in

         {Browse Instruction}

         Positions = Spaceship.positions %Extraire les positions du vaisseau, Positions est une Queue
         Head = Positions.1 %Extraire la tête de la queue Positions
         Tail = {RemoveFirst Positions} %Extraire le reste de la queue Position
         Last = {List.last Positions} %Extraire le dernier élément de Position
         Direction = Head.to %Direction à laquelle se dirige le vaisseau

         case Instruction of

         forward then NewHead NewPositions NewSpaceship FirstEffect RestEffect in %Si la direction est forward

            NewHead = case Direction of
            north then pos(x:Head.x y:Head.y-1 to:Direction)
            []south then pos(x:Head.x y:Head.y+1 to:Direction)
            []east then pos(x:Head.x+1 y:Head.y to:Direction)
            []west then pos(x:Head.x-1 y:Head.y to:Direction)
            end

            NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée
               
            %Gestion des effets

            %Si la liste d'effets est vide, on retourne le SpaceShip avec la nouvelle position
            if Spaceship.effects == nil then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            else %Si la liste d'effets n'est pas vide, pattern matching pour voir de quel effet il s'agit

               FirstEffect = Spaceship.effects.1 %Récupérer la tête de la liste Spaceship.effects
               RestEffect = {Tail Spaceship.effects} %Récupérer le reste de la liste Spaceship.effects
               
               case FirstEffect of
               
               %Si effet scrap
               scrap then NewTail in
                  NewTail = case Direction of
                  north then pos(x:Tail.x y:Tail.y-1 to:Direction)
                  []south then pos(x:Tail.x y:Tail.y+1 to:Direction)
                  []east then pos(x:Tail.x+1 y:Tail.y to:Direction)
                  []west then pos(x:Tail.x-1 y:Tail.y to:Direction)
                  end

                  NewPositions = NewHead | Tail | NewTail %On ajoute à NewPositions la nouvelle queue NewTail
                  NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge) % Retourner le vaisseau mis à jour avec les effets restants


               
               %Si effet revert

               %1. On inverse la direction du vaisseau
               %2. On inverse la liste

               []revert then ReverseList in
               
                  ReverseList = Last | NewHead

                  NewSpaceship(positions:ReverseList effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)




               
               %Si effet wormhole
               []wormhole(x:X y:Y) then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               
               %Si effet dropSeismicCharge
               []dropSeismicCharge(L) then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               end
            end
            
            
            

         []turn(left) then NewHead NewPositions NewSpaceship FirstEffect RestEffect in %Si la direction est left
            
            NewHead = case Direction of
            north then west
            []south then east
            []east then north
            []west then south
            end

            NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée

            %Gestion des effets

            %Si la liste d'effets est vide, on retourne le SpaceShip avec la nouvelle position
            if Spaceship.effects == nil then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            else %Si la liste d'effets n'est pas vide, pattern matching pour voir de quel effet il s'agit

               FirstEffect = Spaceship.effects.1 %Récupérer la tête de la liste Spaceship.effects
               RestEffect = {Tail Spaceship.effects} %Récupérer le reste de la liste Spaceship.effects
               
               case FirstEffect of
               
               %Si effet scrap
               scrap then NewTail in
                  NewTail = case Direction of
                  north then pos(x:Tail.x y:Tail.y-1 to:Direction)
                  [] south then pos(x:Tail.x y:Tail.y+1 to:Direction)
                  [] east then pos(x:Tail.x+1 y:Tail.y to:Direction)
                  [] west then pos(x:Tail.x-1 y:Tail.y to:Direction)
                  end

                  NewPositions = NewHead | Tail | NewTail %On ajoute à NewPositions la nouvelle queue NewTail
                  NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge) % Retourner le vaisseau mis à jour avec les effets restants
               
               %Si effet revert

               %1. On inverse la direction du vaisseau
               %2. On inverse la liste

               []revert then ReverseList in
                  
                  ReverseList = Last | NewHead

                  NewSpaceship(positions:ReverseList effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               
               %Si effet wormhole
               []wormhole(x:X y:Y) then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               
               %Si effet dropSeismicCharge
               []dropSeismicCharge(L) then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               end
            end

         []turn(right) then NewHead NewPositions NewSpaceship FirstEffect RestEffect in %Si la direction est right

            NewHead = case Direction of
            north then east
            []south then west
            []east then south
            []west then north
            end

            NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée

            %Gestion des effets

            %Si la liste d'effets est vide, on retourne le SpaceShip avec la nouvelle position
            if Spaceship.effects == nil then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            else %Si la liste d'effets n'est pas vide, pattern matching pour voir de quel effet il s'agit

               FirstEffect = Spaceship.effects.1 %Récupérer la tête de la liste Spaceship.effects
               RestEffect = {Tail Spaceship.effects} %Récupérer le reste de la liste Spaceship.effects
               
               case FirstEffect of
               
               %Si effet scrap
               scrap then NewTail in
                  NewTail = case Direction of
                  north then pos(x:Tail.x y:Tail.y-1 to:Direction)
                  [] south then pos(x:Tail.x y:Tail.y+1 to:Direction)
                  [] east then pos(x:Tail.x+1 y:Tail.y to:Direction)
                  [] west then pos(x:Tail.x-1 y:Tail.y to:Direction)
                  end

                  NewPositions = NewHead | Tail | NewTail %On ajoute à NewPositions la nouvelle queue NewTail
                  NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge) % Retourner le vaisseau mis à jour avec les effets restants
               
               %Si effet revert

               %1. On inverse la direction du vaisseau
               %2. On inverse la liste

               []revert then ReverseList in
                  
                  ReverseList = Last | NewHead

                  NewSpaceship(positions:ReverseList effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               
               %Si effet wormhole
               []wormhole(x:X y:Y) then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               
               %Si effet dropSeismicCharge
               []dropSeismicCharge(L) then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               end
            end
      
         end

      end

      
      % La fonction qui décode la stratégie d'un serpent en une liste de fonctions. Chacune correspond
      % à un instant du jeu et applique l'instruction devant être exécutée à cet instant au spaceship
      % passé en argument
      %
      % strategy ::= <instruction> '|' <strategy>
      %            | repeat(<strategy> times:<integer>) '|' <strategy>
      %            | nil
      fun {DecodeStrategy Strategy}
         case Strategy of
         nil then nil %Si aucune instruction, retourne nil
         []Instruction|Rest then
      
            case Instruction of
      
            forward then %Si l'instruction est forward
               fun {$ Spaceship} {Next Spaceship forward} end | {DecodeStrategy Rest}

            []turn(left) then %Si l'instruction est turn(left)
               fun {$ Spaceship} {Next Spaceship turn(left)} end | {DecodeStrategy Rest}

            []turn(right) then %Si l'instruction est turn(right)
               fun {$ Spaceship} {Next Spaceship turn(right)} end | {DecodeStrategy Rest}

            []repeat(InnerStrategy times:Times) then % Si l'instruction est repeat

               %On appelle la fonction FoldL avec les 3 arguments ci-dessous : 
               %1. {fun {$ Acc _} {DecodeStrategy InnerStrategy} | Acc end} : l'opération à effectuer sur chaque élément de la liste
               %2. nil : valeur initiale de l'accumulateur
               %3. {Replicate InnerStrategy Times} : la liste sur laquelle l'opération doit être effectuée
               
               {FoldL fun {$ Acc _} {DecodeStrategy InnerStrategy} | Acc end nil {Replicate InnerStrategy Times}} | {DecodeStrategy Rest}

            []'|' then %Si la séparation est une barre verticale
               {DecodeStrategy Rest} %Ignorer la barre verticale et continuer avec le reste de la stratégie

            end
         end
      end

      %{Browse {DecodeStrategy [repeat([turn(right)] times:3) forward turn(left)]}} %Exemple d'appel pour DecodeStrategy


      
      






      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   scenario:'scenario/scenario_crazy.oz'
		   % Utilisez cette touche pour quitter la fenêtre
		   closeKey:'Espace' %Pour stopper la fenêtre de jeu : Cmd + Shift + P et oz.spawn
		   % Visualisation de la partie
		   debug: true
		   % Instants par seconde, 0 spécifie une exécution pas à pas. (appuyer sur 'Espace' fait avancer le jeu d'un pas)
		   frameRate: 5
		)
   end

%%%%%%%%%%%
% The end %
%%%%%%%%%%%
   
   local 
      R = {LethOzLib.play Dossier#'/'#Options.scenario Next DecodeStrategy Options}
   in
      {Browse R}
   end
end