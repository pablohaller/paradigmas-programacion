data AExp = Num Int | Var String | Add AExp AExp | Mult AExp Aexp | Sub AExp AExp deriving (Eq, Show)
data BExp = Tof Bool | Equ AExp AExp | Lot AExp AExp | Neg BExp | AmpAmp BExp BExp deriving (Eq, Show)
data STMT = Ass String AExp | Bloq [STMT] | IFEL BExp STMT STMT | WHL BExp STMT deriving (Eq, Show)

type State = [(String, Int)]
evalAExp :: AExp -> State -> Int 
evalAExp (Num n) _ = n
-- evalAExp (Var x) s = let (just v) = lookup xs in v
evalAExp (Var x) s = v where (Just v) = lookup x s 
evalAExp (Add a1 a2) s = (evalAExp a1 s) + (evalAExp a2 s)
evalAExp (Mult a1 a2) s = (evalAExp a1 s) * (evalAExp a2 s) 
evalAExp (Sub a1 a2) s = (evalAExp a1 s) / (evalAExp a2 s) 


-- Booleans 
evalStmt :: STMT -> State -> State
evalStmt (Ass x a) s = (x, valor) : (filter () s)


-- Exec bloq
evalStmt (Bloq (st:sts)) s = evalStmt (Bloq sts) s1
  where s1 = evalStmt st s 