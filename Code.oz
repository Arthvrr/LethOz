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
      % car il faut retirer le dernier élément de la Queue 

      fun {RemoveLast L}
         case L
         of nil then nil
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
         Tail = {RemoveFirst Positions} %Extraire le reste de la queue Position
         RestTail = {RemoveLast Tail}
         Direction = Head.to %Direction à laquelle se dirige le vaisseau

         case Instruction of

         forward then NewHead NewPositions NewSpaceship in %Si la direction est forward

            NewHead = case Direction of
            north then pos(x:Head.x y:Head.y-1 to:Direction)
            []south then pos(x:Head.x y:Head.y+1 to:Direction)
            []east then pos(x:Head.x+1 y:Head.y to:Direction)
            []west then pos(x:Head.x-1 y:Head.y to:Direction)
            end

            NewPositions = NewHead | RestTail %NewPositions représente la nouvelle queue modifiée (nouvelle Tête + Queue sans dernier élément)
            NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
               
         []turn(left) then NewHead NewPositions NewSpaceship in %Si la direction est left
            
            % NewHead = case Direction of
            % north then west
            % []south then east
            % []east then north
            % []west then south
            % end
            NewHead = case Direction of
            north then pos(x:Head.x y:Head.y-1 to:west)
            []south then pos(x:Head.x y:Head.y+1 to:east)
            []east then pos(x:Head.x+1 y:Head.y to:north)
            []west then pos(x:Head.x-1 y:Head.y to:south)
            end

            NewPositions = NewHead | RestTail %NewPositions représente la nouvelle queue modifiée
            NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

         []turn(right) then NewHead NewPositions NewSpaceship in %Si la direction est right

            % NewHead = case Direction of
            % north then east
            % []south then west
            % []east then south
            % []west then north
            % end
            NewHead = case Direction of
            north then pos(x:Head.x y:Head.y-1 to:east)
            []south then pos(x:Head.x y:Head.y+1 to:west)
            []east then pos(x:Head.x+1 y:Head.y to:south)
            []west then pos(x:Head.x-1 y:Head.y to:north)
            end

            NewPositions = NewHead | RestTail %NewPositions représente la nouvelle queue modifiée
            NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

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