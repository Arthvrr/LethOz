fun {Reverse Spaceship Instruction} Positions Head Tail Direction in

    {Browse Instruction}

    Positions = spaceship.positions

    Positions = Spaceship.positions %Extraire les positions du vaisseau, Positions est une Queue
    Head = Positions.1 %Extraire la tête de la queue Positions
    Tail = {RemoveFirst Positions} %Extraire le reste de la queue Position
    Direction = Head.to %Direction à laquelle se dirige le vaisseau

    case Instruction of

    forward then NewHead NewPositions NewSpaceship in %Si la direction est forward

       NewHead = case Direction of
       north then pos(x:Head.x y:Head.y-1 to:Direction)
       []south then pos(x:Head.x y:Head.y+1 to:Direction)
       []east then pos(x:Head.x+1 y:Head.y to:Direction)
       []west then pos(x:Head.x-1 y:Head.y to:Direction)
       end

       NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée

       %On retourne le nouveau Spaceship
       NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)



    []turn(left) then NewHead NewPositions NewSpaceship in %Si la direction est right

       NewHead = case Direction of
       north then east
       []south then west
       []east then south
       []west then north
       end

       NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée

       %On retourne le nouveau Spaceship
       NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

 
    []turn(right) then NewHead NewPositions NewSpaceship in %Si la direction est left
       
       NewHead = case Direction of
       north then west
       []south then east
       []east then north
       []west then south
       end

       NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée

       %On retourne le nouveau Spaceship
       NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
    end
 end


%FONCTIONS UTILISÉES POUR LES 2 EXTENSIONS 
      % Fonction SuperSonic, qui permet à un joueur d'avoir des boost d'accélération en allant 3x plus vite qu'un autre joueur
      fun {SuperSonic Spaceship Instruction} Positions Head Tail Direction in

         {Browse Instruction}

         Positions = Spaceship.positions %Extraire les positions du vaisseau, Positions est une Queue
         Head = Positions.1 %Extraire la tête de la queue Positions
         Tail = {RemoveFirst Positions} %Extraire le reste de la queue Position
         Direction = Head.to %Direction à laquelle se dirige le vaisseau

         case Instruction of

         forward then NewHead NewPositions NewSpaceship in %Si la direction est forward

            NewHead = case Direction of
            north then pos(x:Head.x y:Head.y-3 to:Direction)
            []south then pos(x:Head.x y:Head.y+3 to:Direction)
            []east then pos(x:Head.x+3 y:Head.y to:Direction)
            []west then pos(x:Head.x-3 y:Head.y to:Direction)
            end

            NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée

            %On retourne le nouveau Spaceship
            NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

         []turn(left) then NewHead NewPositions NewSpaceship in %Si la direction est left
            
            NewHead = case Direction of
            north then west
            []south then east
            []east then north
            []west then south
            end

            NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée

            %On retourne le nouveau Spaceship
            NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)

         []turn(right) then NewHead NewPositions NewSpaceship in %Si la direction est right

            NewHead = case Direction of
            north then east
            []south then west
            []east then south
            []west then north
            end

            NewPositions = NewHead | Tail %NewPositions représente la nouvelle queue modifiée

            %On retourne le nouveau Spaceship
            NewSpaceship(positions:NewPositions effects:Spaceship.effects strategy:Spaceship.strategy seismicCharge:Spaceship.seismicCharge)
      
         end

      end




      NewDirection in

         NewDirection = case Direction of %On inverse la direction du vaisseau
         north then south
         []south then north
         []east then west
         []west then east
         end

         %ReverseList = {Reverse Positions} %On inverse la liste en appelant la fonction List.reverse provenant de la documentation