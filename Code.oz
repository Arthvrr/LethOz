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
   in
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
      fun {Next Spaceship Instruction}
         {Browse Instruction}
         local Positions Head Direction in
            Positions = Spaceship.positions %Extraire les positions du vaisseau
            Head = Positions.1 %Extraire la tête de la queue Positions
            Direction = Head.to %Direction à laquelle se dirige le vaisseau
            
            case Instruction of
            
               forward then {Browse "Forward"} end

         end
         Spaceship
      end

      
      % La fonction qui décode la stratégie d'un serpent en une liste de fonctions. Chacune correspond
      % à un instant du jeu et applique l'instruction devant être exécutée à cet instant au spaceship
      % passé en argument
      %
      % strategy ::= <instruction> '|' <strategy>
      %            | repeat(<strategy> times:<integer>) '|' <strategy>
      %            | nil
      fun {DecodeStrategy Strategy}
         [
            fun{$ Spaceship}
               Spaceship
            end
         ]
      end

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