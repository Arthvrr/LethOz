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

        NewPositions = NewHead | RestTail | NewTail %On ajoute à NewPositions la nouvelle queue NewTail
        NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge) % Retourner le vaisseau mis à jour avec les effets restants

    %Si effet revert
    []revert then NewDirection ReverseList ToReverse in

        NewDirection = case Direction of %On inverse la direction du vaisseau
        north then pos(x:Head.x y:Head.y to:Direction)
        []south then pos(x:Head.x y:Head.y to:Direction)
        []east then pos(x:Head.x y:Head.y to:Direction)
        []west then pos(x:Head.x y:Head.y to:Direction)
        end

        ToReverse = NewHead | RestTail

        ReverseList = {Reverse ToReverse} %Liste inversée

        NewSpaceship(positions:ReverseList effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

    %Si effet wormhole
    []wormhole(x:X y:Y) then TeleportedHead in
        %il faut téléporter au point X, Y
        TeleportedHead = pos(x:X y:Y to:Direction) %TeleportedHead prend les coordonnées X Y passés en arguments

        NewPositions = TeleportedHead | RestTail %On lie les 2 dans une Queue
        NewSpaceship(positions:NewPositions effects:RestEffect strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
    
    %Si effet dropSeismicCharge
    []dropSeismicCharge(L) then NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
    end
end

 