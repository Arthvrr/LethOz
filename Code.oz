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
      RemoveLast
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

      % Fonction permettant d'enlever le dernier élément d'une liste qui nous servira dans le cas de la fonction Next,
      % car il faut retirer le dernier élément de la Queue Positions
      fun {RemoveLast L}
         case L of
         nil then nil
         [] H|T then
            if T == nil then nil
            else
               H|{RemoveLast T}
            end
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
      fun {Next Spaceship Instruction} Positions Head Tail RestTail Direction in

         {Browse Instruction}

         Positions = Spaceship.positions %Extraire les positions du vaisseau, Positions est une Queue
         Head = Positions.1 %Extraire la tête de la queue Positions
         Tail = {RemoveFirst Positions} %Extraire le reste de la queue Position avec RemoveFirst
         RestTail = {RemoveLast Tail} %Enlever le dernier élément de la Tail avec RemoveLast
         Direction = Head.to %Direction à laquelle se dirige le vaisseau

         case Instruction of

         %INSTRUCTION FORWARD
         forward then NewHead NewPositions NewSpaceship in

            NewHead = case Direction of
            north then pos(x:Head.x y:Head.y-1 to:Direction)
            []south then pos(x:Head.x y:Head.y+1 to:Direction)
            []east then pos(x:Head.x+1 y:Head.y to:Direction)
            []west then pos(x:Head.x-1 y:Head.y to:Direction)
            end

            %GESTION DES EFFETS
            if Spaceship.effects == nil then %Si la liste d'effets est vide, on retourne le SpaceShip avec la nouvelle position
               NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)


            %Si la liste d'effets n'est pas vide, pattern matching pour voir de quel effet il s'agit
            else FirstEffect RestEffect NumberShield in

               FirstEffect = Spaceship.effects.1 %Récupérer la tête de la liste Spaceship.effects
               RestEffect = {Tail Spaceship.effects} %Récupérer le reste de la liste Spaceship.effects
               NumberShield = 0 %Nombre de tours qu'il est possible d'utiliser pour le Shield, initialisé à 0 au départ

               case FirstEffect of

               %EFFET SHIELD
               shield(N) then
               
               NumberShield = N %On change la valeur de NumberShield par N
               NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge) %On passe à l'effet suivant

               %EFFET SCRAP
               []scrap then NewTail in
                  if NumberShield > 0 then %Si NumberShield est supérier à 0
                     NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                     %On skip l'effet
                     NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
         
                  else %Si NumberShield n'est pas plus grand que 0
                     %On applique l'effet
                     NewTail = case Direction of
                     north then pos(x:Tail.x y:Tail.y-1 to:Direction)
                     []south then pos(x:Tail.x y:Tail.y+1 to:Direction)
                     []east then pos(x:Tail.x+1 y:Tail.y to:Direction)
                     []west then pos(x:Tail.x-1 y:Tail.y to:Direction)
                     end
         
                     NewPositions = NewHead | RestTail | NewTail %On ajoute à NewPositions la nouvelle queue NewTail
                     NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  end
               
               %EFFET REVERT
               []revert then NewDirection ReverseList ToReverse in
                  if NumberShield > 0 then %Si NumberShield est supérier à 0
                     NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                     %On skip l'effet
                     NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  
                  else %Si NumberShield n'est pas plus grand que 0
                     %On applique l'effet
                     NewDirection = case Direction of %On inverse la direction du vaisseau
                     north then pos(x:Head.x y:Head.y to:Direction)
                     []south then pos(x:Head.x y:Head.y to:Direction)
                     []east then pos(x:Head.x y:Head.y to:Direction)
                     []west then pos(x:Head.x y:Head.y to:Direction)
                     end
         
                     ToReverse = NewHead | RestTail
                     ReverseList = {List.reverse ToReverse} %Liste inversée
                     NewSpaceship(positions:ReverseList effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  end
               
                  %EFFET WORMHOLE
                  []wormhole(x:X y:Y) then TeleportedHead in
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        %On applique l'effet
                        %il faut téléporter au point X, Y
                        TeleportedHead = pos(x:X y:Y to:Direction) %TeleportedHead prend les coordonnées X Y passés en arguments
                        NewPositions = TeleportedHead | RestTail %On lie les 2 dans une Queue
                        NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     end
                  

                  %EFFET DROPSEISMICCHARGE
                  []dropSeismicCharge(L) then
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        %On applique l'effet
                        if L == nil then %Si la liste L est vide
                           {List.append Spaceship.seismicCharge true | nil} %On append avec List.append provenant de la documentation
                           NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                        else %Si L n'est pas vide on l'append à la liste Spaceship.SeismicCharge
                           {List.append Spaceship.seismicCharge L} %On append avec List.append provenant de la documentation
                           NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                        end
            
                     end


                  %EFFET FROST
                  []frost(N) then NewEffect in
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        
                        %On applique l'effet
                        if N > 0 then % Vérifie si le nombre de tours de gel est supérieur à 0
                           NewEffect = frost(N-1) | RestEffect % On réduit le nombre de tours restants de 1 et on conserve l'effet frost pour le tour suivant
                        else
                           NewEffect = RestEffect % Si le nombre de tours restants est de 0, on passe simplement à l'effet suivant
                        end
            
                        NewSpaceship(positions: Positions effects: NewEffect strategy: Spaceship.strategy seismicCharge: Spaceship.seismicCharge)
            
                     end

            end
            
         end
         %INSTRUCTION TURN(LEFT)
         []turn(left) then NewHead NewPositions NewSpaceship in %Si la direction est left
            
            NewHead = case Direction of
            north then west
            []south then east
            []east then north
            []west then south
            end

            %GESTION DES EFFETS
            if Spaceship.effects == nil then %Si la liste d'effets est vide, on retourne le SpaceShip avec la nouvelle position
               NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)


            %Si la liste d'effets n'est pas vide, pattern matching pour voir de quel effet il s'agit
            else FirstEffect RestEffect NumberShield in

               FirstEffect = Spaceship.effects.1 %Récupérer la tête de la liste Spaceship.effects
               RestEffect = {Tail Spaceship.effects} %Récupérer le reste de la liste Spaceship.effects
               NumberShield = 0 %Nombre de tours qu'il est possible d'utiliser pour le Shield, initialisé à 0 au départ

               case FirstEffect of

               %EFFET SHIELD
               shield(N) then
               
               NumberShield = N %On change la valeur de NumberShield par N
               NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge) %On passe à l'effet suivant

               %EFFET SCRAP
               []scrap then NewTail in
                  if NumberShield > 0 then %Si NumberShield est supérier à 0
                     NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                     %On skip l'effet
                     NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
         
                  else %Si NumberShield n'est pas plus grand que 0
                     %On applique l'effet
                     NewTail = case Direction of
                     north then pos(x:Tail.x y:Tail.y-1 to:Direction)
                     []south then pos(x:Tail.x y:Tail.y+1 to:Direction)
                     []east then pos(x:Tail.x+1 y:Tail.y to:Direction)
                     []west then pos(x:Tail.x-1 y:Tail.y to:Direction)
                     end
         
                     NewPositions = NewHead | RestTail | NewTail %On ajoute à NewPositions la nouvelle queue NewTail
                     NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  end
               
               %EFFET REVERT
               []revert then NewDirection ReverseList ToReverse in
                  if NumberShield > 0 then %Si NumberShield est supérier à 0
                     NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                     %On skip l'effet
                     NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  
                  else %Si NumberShield n'est pas plus grand que 0
                     %On applique l'effet
                     NewDirection = case Direction of %On inverse la direction du vaisseau
                     north then pos(x:Head.x y:Head.y to:Direction)
                     []south then pos(x:Head.x y:Head.y to:Direction)
                     []east then pos(x:Head.x y:Head.y to:Direction)
                     []west then pos(x:Head.x y:Head.y to:Direction)
                     end
         
                     ToReverse = NewHead | RestTail
                     ReverseList = {List.reverse ToReverse} %Liste inversée
                     NewSpaceship(positions:ReverseList effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  end
               
                  %EFFET WORMHOLE
                  []wormhole(x:X y:Y) then TeleportedHead in
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        %On applique l'effet
                        %il faut téléporter au point X, Y
                        TeleportedHead = pos(x:X y:Y to:Direction) %TeleportedHead prend les coordonnées X Y passés en arguments
                        NewPositions = TeleportedHead | RestTail %On lie les 2 dans une Queue
                        NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     end
                  

                  %EFFET DROPSEISMICCHARGE
                  []dropSeismicCharge(L) then
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        %On applique l'effet
                        if L == nil then %Si la liste L est vide
                           {List.append Spaceship.seismicCharge true | nil} %On append avec List.append provenant de la documentation
                           NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                        else %Si L n'est pas vide on l'append à la liste Spaceship.SeismicCharge
                           {List.append Spaceship.seismicCharge L} %On append avec List.append provenant de la documentation
                           NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                        end
            
                     end


                  %EFFET FROST
                  []frost(N) then NewEffect in
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        
                        %On applique l'effet
                        if N > 0 then % Vérifie si le nombre de tours de gel est supérieur à 0
                           NewEffect = frost(N-1) | RestEffect % On réduit le nombre de tours restants de 1 et on conserve l'effet frost pour le tour suivant
                        else
                           NewEffect = RestEffect % Si le nombre de tours restants est de 0, on passe simplement à l'effet suivant
                        end
            
                        NewSpaceship(positions: Positions effects: NewEffect strategy: Spaceship.strategy seismicCharge: Spaceship.seismicCharge)
            
                     end

            end
         end
         %INSTRUCTION TURN(RIGHT)
         []turn(right) then NewHead NewPositions NewSpaceship ModifiedHead in %Si la direction est right

            NewHead = case Direction of
            north then east
            []south then west
            []east then south
            []west then north
            end

            %GESTION DES EFFETS
            if Spaceship.effects == nil then %Si la liste d'effets est vide, on retourne le SpaceShip avec la nouvelle position
               NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge) %On passe à l'effet suivant


            %Si la liste d'effets n'est pas vide, pattern matching pour voir de quel effet il s'agit
            else FirstEffect RestEffect NumberShield in

               FirstEffect = Spaceship.effects.1 %Récupérer la tête de la liste Spaceship.effects
               RestEffect = {Tail Spaceship.effects} %Récupérer le reste de la liste Spaceship.effects
               NumberShield = 0 %Nombre de tours qu'il est possible d'utiliser pour le Shield, initialisé à 0 au départ

               case FirstEffect of

               %EFFET SHIELD
               shield(N) then
               
               NumberShield = N %On change la valeur de NumberShield par N
               NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

               %EFFET SCRAP
               []scrap then NewTail in
                  if NumberShield > 0 then %Si NumberShield est supérier à 0
                     NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                     %On skip l'effet
                     NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
         
                  else %Si NumberShield n'est pas plus grand que 0
                     %On applique l'effet
                     NewTail = case Direction of
                     north then pos(x:Tail.x y:Tail.y-1 to:Direction)
                     []south then pos(x:Tail.x y:Tail.y+1 to:Direction)
                     []east then pos(x:Tail.x+1 y:Tail.y to:Direction)
                     []west then pos(x:Tail.x-1 y:Tail.y to:Direction)
                     end
         
                     NewPositions = NewHead | RestTail | NewTail %On ajoute à NewPositions la nouvelle queue NewTail
                     NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  end
               
               %EFFET REVERT
               []revert then NewDirection ReverseList ToReverse in
                  if NumberShield > 0 then %Si NumberShield est supérier à 0
                     NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                     %On skip l'effet
                     NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  
                  else %Si NumberShield n'est pas plus grand que 0
                     %On applique l'effet
                     NewDirection = case Direction of %On inverse la direction du vaisseau
                     north then pos(x:Head.x y:Head.y to:Direction)
                     []south then pos(x:Head.x y:Head.y to:Direction)
                     []east then pos(x:Head.x y:Head.y to:Direction)
                     []west then pos(x:Head.x y:Head.y to:Direction)
                     end
         
                     ToReverse = NewHead | RestTail
                     ReverseList = {List.reverse ToReverse} %Liste inversée
                     NewSpaceship(positions:ReverseList effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                  end
               
                  %EFFET WORMHOLE
                  []wormhole(x:X y:Y) then TeleportedHead in
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        %On applique l'effet
                        %il faut téléporter au point X, Y
                        TeleportedHead = pos(x:X y:Y to:Direction) %TeleportedHead prend les coordonnées X Y passés en arguments
                        NewPositions = TeleportedHead | RestTail %On lie les 2 dans une Queue
                        NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     end
                  

                  %EFFET DROPSEISMICCHARGE
                  []dropSeismicCharge(L) then
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        %On applique l'effet
                        if L == nil then %Si la liste L est vide
                           {List.append Spaceship.seismicCharge true | nil} %On append avec List.append provenant de la documentation
                           NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                        else %Si L n'est pas vide on l'append à la liste Spaceship.SeismicCharge
                           {List.append Spaceship.seismicCharge L} %On append avec List.append provenant de la documentation
                           NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
                        end
            
                     end


                  %EFFET FROST
                  []frost(N) then NewEffect in
                     if NumberShield > 0 then %Si NumberShield est supérier à 0
                        NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
                        %On skip l'effet
                        NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
                     else %Si NumberShield n'est pas plus grand que 0
                        
                        %On applique l'effet
                        if N > 0 then % Vérifie si le nombre de tours de gel est supérieur à 0
                           NewEffect = frost(N-1) | RestEffect % On réduit le nombre de tours restants de 1 et on conserve l'effet frost pour le tour suivant
                        else
                           NewEffect = RestEffect % Si le nombre de tours restants est de 0, on passe simplement à l'effet suivant
                        end
            
                        NewSpaceship(positions: Positions effects: NewEffect strategy: Spaceship.strategy seismicCharge: Spaceship.seismicCharge)
            
                     end
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

               % %On appelle la fonction FoldL avec les 3 arguments ci-dessous : 
               % %1. {fun {$ Acc _} {DecodeStrategy InnerStrategy} | Acc end} : l'opération à effectuer sur chaque élément de la liste
               % %2. nil : valeur initiale de l'accumulateur
               % %3. {Replicate InnerStrategy Times} : la liste sur laquelle l'opération doit être effectuée
               
               {FoldL fun {$ Acc _} {DecodeStrategy InnerStrategy} | Acc end nil {Replicate InnerStrategy Times}} | {DecodeStrategy Rest}
               

            []'|' then %Si la séparation est une barre verticale
               {DecodeStrategy Rest} %Ignorer la barre verticale et continuer avec le reste de la stratégie
            
            end
         end
      end
      
   
      %Exemple d'appel de DecodeStrategy
      %{Browse {DecodeStrategy [repeat([turn(right)] times:3) forward turn(left)]}} %Exemple d'appel pour DecodeStrategy



      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   scenario:'scenario/scenario.oz'
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