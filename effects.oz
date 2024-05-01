    %GESTION DES EFFETS
    if Spaceship.effects == nil then %Si la liste d'effets est vide, on retourne le SpaceShip avec la nouvelle position
        NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)


    %Si la liste d'effets n'est pas vide, pattern matching pour voir de quel effet il s'agit
    else FirstEffect RestEffect NumberShield

        FirstEffect = Spaceship.effects.1 %Récupérer la tête de la liste Spaceship.effects
        RestEffect = {Tail Spaceship.effects} %Récupérer le reste de la liste Spaceship.effects
        NumberShield = 0 %Nombre de tours qu'il est possible d'utiliser pour le Shield
        
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

        else %Si le bouclier n'est pas actif ou que NumberShield est pas plus grand que 0

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
        
        else %Si le bouclier n'est pas actif ou que NumberShield est pas plus grand que 0
            
            %On applique l'effet
            NewDirection = case Direction of %On inverse la direction du vaisseau
            north then pos(x:Head.x y:Head.y to:Direction)
            []south then pos(x:Head.x y:Head.y to:Direction)
            []east then pos(x:Head.x y:Head.y to:Direction)
            []west then pos(x:Head.x y:Head.y to:Direction)
            end

            ToReverse = NewHead | RestTail
            ReverseList = {Reverse ToReverse} %Liste inversée
            NewSpaceship(positions:ReverseList effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
            
        end
        %EFFET WORMHOLE
        []wormhole(x:X y:Y) then TeleportedHead in
        if NumberShield > 0 then %Si NumberShield est supérier à 0
            NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
            %On skip l'effet
            NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

        else %Si le bouclier n'est pas actif ou que NumberShield est pas plus grand que 0

            %On applique l'effet
            %il faut téléporter au point X, Y
            TeleportedHead = pos(x:X y:Y to:Direction) %TeleportedHead prend les coordonnées X Y passés en arguments
            NewPositions = TeleportedHead | RestTail %On lie les 2 dans une Queue
            NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

        end
        %EFFET DROPSEISMICCHARGE
        []dropSeismicCharge(L) then ListToAppend in
        if NumberShield > 0 then %Si NumberShield est supérier à 0
            NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
            %On skip l'effet
            NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

        else %Si le bouclier n'est pas actif ou que NumberShield est pas plus grand que 0

            %On applique l'effet
            ListToAppend = SpaceShip.seismicCharge
            {List.append ListToAppend L}
            NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:ListToAppend)

        end
        %EFFET FROST
        []frost(N) then NewEffect in
        if NumberShield > 0 then %Si NumberShield est supérier à 0
            NumberShield = NumberShield - 1 %On décrémente de 1 NumberShield
            %On skip l'effet
            NewSpaceship(positions:Positions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

        else %Si le bouclier n'est pas actif ou que NumberShield est pas plus grand que 0
            
            %On applique l'effet
            if N > 0 then % Vérifie si le nombre de tours de gel est supérieur à 0
                NewEffect = frost(N-1) | RestEffect % On réduit le nombre de tours restants de 1 et on conserve l'effet frost pour le tour suivant
            else
                NewEffect = RestEffect % Si le nombre de tours restants est de 0, on passe simplement à l'effet suivant
            end

            NewSpaceship(positions: Positions effects: NewEffect strategy: Spaceship.strategy seismicCharge: ListToAppend)

        end
    end