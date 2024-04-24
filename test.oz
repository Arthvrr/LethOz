Positions = Spaceship.positions %Extraire les positions du vaisseau
Head = Positions.1 %Extraire la tête de la queue Positions
Direction = Head.to %Direction à laquelle se dirige le vaisseau

case Instruction of

    nil then Spaceship %Cas où l'instruction vaut nil, on retourne le même Spaceship
    
    forward then %Cas où l'instruction est d'aller vers l'avant
    
    NewHead = case Direction of
        north then pos(x:Head.x y:Head.y-1 to:Direction)
        south then pos(x:Head.x y:Head.y+1 to:Direction)
        east then pos(x:Head.x+1 y:Head.y to:Direction)
        west then pos(x:Head.x-1 y:Head.y to:Direction)
        end
    
    NewPositions = NewHead | {List.drop 1 Positions}
    spaceship(positions:NewPositions effects:Spaceship.effects)
    
    turn(left) then %Cas où l'instruction est d'aller vers la gauche

    NewDirection = case Direction of
        north then west
        south then east
        east then north
        west then south
        end
    
    NewHead = pos(x:Head.x y:Head.y to:NewDirection)
    NewPositions = NewHead | {List.drop 1 Positions}
    spaceship(positions:NewPositions effects:Spaceship.effects)
    
    turn(right) then %Cas où l'instruction est d'aller vers la droite

    NewDirection = case Direction of
        north then east
        south then west
        east then south
        west then north
        end
    
    NewHead = pos(x:Head.x y:Head.y to:NewDirection)
    NewPositions = NewHead | {List.drop 1 Positions}
    spaceship(positions:NewPositions effects:Spaceship.effects)
    
    else 
    Spaceship
    end