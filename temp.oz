% Fonction FoldL, qui pour rappel permet d'appliquer une fonction à chaque élément d'une liste
% que l'on va utiliser dans la fonction DecodeStrategy
fun {FoldL Fun Initial List}
   case List of
   nil then Initial
   []X|Xs then
      {FoldL Fun {Fun Initial X} Xs}
   end
end

% Fonction utilisée dans le cas où il y a des repétitions à faire dans DecodeStrategy
fun {DecodeRepeat SubStrategy Times}
   case Times of
   0 then nil
   []N then {DecodeStrategy SubStrategy} | {DecodeRepeat SubStrategy N-1}
   end
end

%{DecodeRepeat SubStrategy Times} | {DecodeStrategy RestStrategy} % Appel de la fonction auxiliaire

fun {DecodeStrategy Strategy}
         
   case Strategy of

   nil then nil
   
   []  %Si la stratégie contient au moins une instruction
   
      case Instruction of

      forward then % Si l'instruction est "forward"
         % Créer une fonction qui appelle Next avec l'instruction "forward"
         fun {$ Spaceship} {Next Spaceship forward} end | {DecodeStrategy RestStrategy}
      
      []turn(Direction) then
         fun {$ Spaceship} {Next Spaceship turn(Direction)} end | {DecodeStrategy RestStrategy}
      
      []repeat(SubStrategy times:Times) then %Si l'instruction est une répétition
         % Appeler récursivement DecodeStrategy pour la sous-stratégie et répéter le résultat Times fois
         %{DecodeRepeat SubStrategy Times} | {DecodeStrategy RestStrategy} % Appel de la fonction auxiliaire
         nil
      end
   end

end


fun {DecodeStrategy Strategy}
   case Strategy of
      nil then nil % Si aucune instruction, retourne nil
      [] then nil % Si la liste est vide, retourne nil
      [Instruction|Rest] then
         case Instruction of
            forward then % Si l'instruction est forward
               % Créer une fonction qui appelle Next avec l'instruction forward
               fun {$ Spaceship} {Next Spaceship forward} end |
               % Appeler récursivement DecodeStrategy sur le reste de la stratégie
               {DecodeStrategy Rest}
            [] turn(left) then % Si l'instruction est turn(left)
               % Créer une fonction qui appelle Next avec l'instruction turn(left)
               fun {$ Spaceship} {Next Spaceship turn(left)} end |
               % Appeler récursivement DecodeStrategy sur le reste de la stratégie
               {DecodeStrategy Rest}
            [] turn(right) then % Si l'instruction est turn(right)
               % Créer une fonction qui appelle Next avec l'instruction turn(right)
               fun {$ Spaceship} {Next Spaceship turn(right)} end |
               % Appeler récursivement DecodeStrategy sur le reste de la stratégie
               {DecodeStrategy Rest}
            [] repeat(InnerStrategy times:Times) then % Si l'instruction est repeat
               % Appeler récursivement DecodeStrategy sur InnerStrategy
               % pour obtenir les instructions à l'intérieur de la répétition
               % et les concaténer Times fois
               {List.replicate Times {DecodeStrategy InnerStrategy}} | {DecodeStrategy Rest}
            [] '|' then % Si la séparation est une barre verticale
               {DecodeStrategy Rest} % Ignorer la barre verticale et continuer avec le reste de la stratégie
            else
               % Si l'instruction n'est pas reconnue, retourne une erreur ou traite-la selon le besoin
               % Ici, je retourne une erreur pour illustrer
               {Error.error 'Unknown instruction'}
         end
      else
         % Si la structure de la stratégie est incorrecte, retourne une erreur ou traite-la selon le besoin
         % Ici, je retourne une erreur pour illustrer
         {Error.error 'Invalid strategy structure'}
   end
end
