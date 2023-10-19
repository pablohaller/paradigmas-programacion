import Data.List (nub)
import Data.List (elemIndex)

data AExp = Num Int | Var String | Add AExp AExp | Mult AExp AExp | Div AExp AExp | Sub AExp AExp deriving (Eq, Show) 
data BExp = Tof Bool | CEq AExp AExp | CLTEq AExp AExp | Neg BExp | And BExp BExp deriving (Eq, Show)
data STMT = Assign String AExp | Block [STMT] | IfThenElse BExp STMT STMT | WhileDo BExp STMT | DoWhile BExp STMT deriving (Eq, Show) 

type State = [(String,Int)]

evalAExp :: AExp -> State -> Int
evalAExp (Num n) _ = n
evalAExp (Var x) s = v
    where (Just v) = lookup x s
evalAExp (Add a1 a2) s = (evalAExp a1 s) + (evalAExp a2 s)
evalAExp (Mult a1 a2) s = (evalAExp a1 s) * (evalAExp a2 s) 
evalAExp (Sub a1 a2) s = (evalAExp a1 s) - (evalAExp a2 s) 
evalAExp (Div a1 a2) s = div (evalAExp a1 s) (evalAExp a2 s) 

evalBExp:: BExp -> State ->Bool
evalBExp (Tof a) _  = a
evalBExp (CEq a b) c = (evalAExp a c)==(evalAExp b c) 
evalBExp (CLTEq a b)  c = (evalAExp a c)<=(evalAExp b c) 
evalBExp (Neg a) c = not (evalBExp a c)
evalBExp (And a b) c = (evalBExp a c) && (evalBExp b c) 

evalStmt:: STMT -> State -> State
evalStmt (Assign x a) s = (x,valor):(filter (\(x1,_)-> x1/=x) s )
    where valor= evalAExp a s 
evalStmt (Block []) s = s
evalStmt (Block (st:sts)) s = evalStmt (Block sts) s1 
    where s1 = evalStmt st s
evalStmt (IfThenElse b s1 s2) s
    | evalBExp b s = evalStmt s1 s
    | otherwise = evalStmt s2 s
evalStmt (WhileDo b s1) s 
    | evalBExp b s =  evalStmt (WhileDo b s1) (evalStmt s1 s)
    | otherwise = s
evalStmt (DoWhile b s1) s 
    | evalBExp b s =  evalStmt (DoWhile b s1) (evalStmt s1 s)
    | otherwise = s



ilLocals :: STMT -> [String]
ilLocals (Assign x _) = [x]
ilLocals (Block stmts) = nub (concat (map ilLocals stmts))
ilLocals (IfThenElse _ s1 s2) = nub (concat (map ilLocals [s1, s2]))
ilLocals (WhileDo _ s) = ilLocals s
ilLocals (DoWhile _ s) = ilLocals s


varX = Var "x"
varN = Var "n"
zero = Num 0
one = Num 1


example1 = Block [Assign "x" (Num 77), Assign "y" (Mult varX varX)]
example12 = Block [Assign "x" (Num 77), Assign "y" (Div varX varX)]
example2 = Block [Assign "x" (Num (-32)), IfThenElse
  (Neg (CLTEq zero varX)) (Assign "x" (Sub zero varX)) (Block [])]
example3 = Block [
  Assign "n" (Num 5), Assign "f" one, WhileDo (CLTEq one varN)
  (Block [
    Assign "f" (Mult (Var "f") varN), Assign "n" (Sub varN one)
  ])]
example4 = Block [Assign "x" (Num 77), Assign "y" (Mult varX varX)]
example5 = Block [
  Assign "n" (Num 5), Assign "f" one, DoWhile (CLTEq one varN)
  (Block [
    Assign "f" (Mult (Var "f") varN), Assign "n" (Sub varN one)
  ])]
--stloc.0 guarda el valor anterior en el logar 0, ese 0 puede ser cualquier valor claramente
--ldloc.s x  obtiene el valor del lugar donde esta asginado, x puede ser 0 1 2 3 4 ....
--ldc.i4.s y un valor cualquiera que pushea.
--cgt > hace la comparacion de los 2 valores anteriores, al tope de la pila como dice leo (Greater than mayor)
--clt less than <
--ceq igual =


ilMaxStackAExp :: AExp -> Int
ilMaxStackAExp (Num _) = 1
ilMaxStackAExp (Var _) = 1
ilMaxStackAExp (Add a1 a2) = max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackAExp (Mult a1 a2) = max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackAExp (Sub a1 a2) = max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackAExp (Div a1 a2) = max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)

ilMaxStackBExp :: BExp -> Int
ilMaxStackBExp (Tof _) = 1
ilMaxStackBExp (CEq a1 a2) = max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackBExp (CLTEq a1 a2) = max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackBExp (Neg b1) = ilMaxStackBExp b1
ilMaxStackBExp (And b1 b2) = max (ilMaxStackBExp b1) (1 + ilMaxStackBExp b2)

ilMaxStackStmt :: STMT -> Int
ilMaxStackStmt (Assign x a) = ilMaxStackAExp a
ilMaxStackStmt (Block stmts) = maximum (map ilMaxStackStmt stmts)
ilMaxStackStmt (IfThenElse b s1 s2) = maximum [ilMaxStackBExp b, ilMaxStackStmt s1, ilMaxStackStmt s2]
ilMaxStackStmt (WhileDo b s) = maximum [ilMaxStackBExp b, ilMaxStackStmt s]
ilMaxStackStmt (DoWhile b s) = maximum [ilMaxStackBExp b, ilMaxStackStmt s]


data CodeGenContext = CodeGenContext {
    locals :: [String]
  } deriving (Show)

ilCompileAExp :: AExp -> CodeGenContext -> [String]
ilCompileAExp (Num n) _ = ["ldc.i4.s "++ (show n)]
ilCompileAExp (Var x) ctx = ["ldloc.s "++ (show i)]
  where (Just i) = elemIndex x (locals ctx)
ilCompileAExp (Add a1 a2) ctx = concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["add"]]
ilCompileAExp (Sub a1 a2) ctx = concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["sub"]]
ilCompileAExp (Mult a1 a2) ctx = concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["mult"]]
ilCompileAExp (Div a1 a2) ctx = concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["div"]]

--data BExp = Tof Bool | CEq AExp AExp | CLTEq AExp AExp | Neg BExp | And BExp BExp deriving (Eq, Show)
ilCompileBExp :: BExp -> CodeGenContext -> [String]
ilCompileBExp (Tof True) _ = ["ldc.i4.s 1"]
ilCompileBExp (Tof False) _ = ["ldc.i4.s 0"]
ilCompileBExp (CEq a1 a2) cont = concat [ilCompileAExp a1 cont, ilCompileAExp a2 cont, ["ceq"]]
ilCompileBExp (CLTEq a1 a2) cont = concat [ilCompileAExp a1 cont, ilCompileAExp a2 cont, ["cgt"]] ++ ["ldc.i4.s 0"] ++ ["ceq"]
ilCompileBExp (Neg a1) cont = concat [ilCompileBExp a1 cont,["ldc.i4.0"],["ceq"]]
ilCompileBExp (And bex1 bex2) cont = concat [ilCompileBExp bex1 cont, ilCompileBExp bex2 cont, ["and"]]
---data STMT = Assign String AExp | Block [STMT] | IfThenElse BExp STMT STMT | WhileDo BExp STMT deriving (Eq, Show)
ilCompileStmt :: STMT -> CodeGenContext -> [String]
ilCompileStmt (Assign x1 valor) ctx = (ilCompileAExp valor ctx) ++ ["stloc."++ (show i)]
  where (Just i) = elemIndex x1 (locals ctx)
ilCompileStmt (Block stmts) ctx = concat (map (\s-> ilCompileStmt s ctx) stmts) 
ilCompileStmt (IfThenElse be1 st2 st3) ctx = (ilCompileBExp be1 ctx) ++ ["br.true T1"] ++ (ilCompileStmt st3 ctx) ++ ["br"] ++ ["T1:"] ++ (ilCompileStmt st2 ctx) ++ ["T2: nop"]
ilCompileStmt (WhileDo exp stm) ctx = ["T1:"] ++ (ilCompileBExp exp ctx) ++ ["br.false T2"] ++ (ilCompileStmt stm ctx) ++ ["br.T1"] ++ ["T2: nop"] 
ilCompileStmt (DoWhile exp stm) ctx = ["br TC"] ++ ["T1:"] ++ (ilCompileBExp exp ctx) ++ ["br.false T2"] ++ ["TC:"] ++ (ilCompileStmt stm ctx) ++ ["br.T1"] ++ ["T2: nop"] 

-- YO RECIBO UN TIPO STMNT, LO CUAL LO CUAL DEBO DE IR DESCOMPONIENDO
-- Block [Assign "x" (Num 77), Assign "y" (Mult varX varX)]

xlocal = ilLocals example12
---ilCompileStmt example2 (CodeGenContext xlocal)
--esto de arriba se ejecuta