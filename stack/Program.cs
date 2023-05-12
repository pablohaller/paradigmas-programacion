namespace ut2
{
    internal class Program
    {

        public class Stackalc
        {
            public int maxStack = 8;
            public int locals = 4;
            public Stackalc()
            {
            }

            public Stackalc(int maxStack, int locals)
            {
                this.maxStack = maxStack;
                this.locals = locals;
            }
        }

        static void Main(string[] args)
        {
            try
            {
                Console.Write("Max stack: ");
                string userMaxStack = Console.ReadLine();
                Console.Write("Locals: ");
                string userLocals = Console.ReadLine();

                int intMaxStack = Int32.Parse(userMaxStack);
                int intUserLocals = Int32.Parse(userLocals);

                Stackalc stackalc = new Stackalc(intMaxStack, intUserLocals);
                Stack<double> stack = new Stack<double>();
                double[] locals = new double[stackalc.locals];


                // ldc:1 ldc:2 ldc:3 stv:1 stv:2 stv:3 ldv:2 ldv:2 ldv:2 mul
                // ldv:2 ldv:2 ldv:2 mul

                bool salir = true;
                while (salir)
                {
                    Console.Write("stackalc > ");
                    string userInput = Console.ReadLine();

                    // Print the value of the variable (userName), which will display the input value
                    Console.WriteLine(userInput);
                    if (userInput == "salir")
                    {
                        salir = false;
                        break;
                    }
                    else
                    {
                        bool noFalla = true;
                        while (noFalla)
                        {
                            if (stack.Count > stackalc.maxStack)
                            {
                                Console.WriteLine("maxStack alcanzado");
                                noFalla = false;
                                break;
                            }

                            foreach (string opcode in userInput.Split(' '))
                            {
                                Console.WriteLine(opcode);
                                string[] instruction = opcode.Split(":");
                                Console.WriteLine(instruction);

                                if (instruction[0] == "ldc")
                                {
                                    stack.Push(Double.Parse(instruction[1]));
                                }
                                else if (instruction[0] == "stv")
                                {
                                    double stackValue = stack.Pop();
                                    locals[Int32.Parse(instruction[1])] = stackValue;
                                }
                                else if (instruction[0] == "ldv")
                                {
                                    stack.Push(locals[Int32.Parse(instruction[1])]);
                                }
                                else if (instruction[0] == "mul")
                                {
                                    double value2 = stack.Pop();
                                    double value1 = stack.Pop();
                                    stack.Push(value1 * value2);
                                }
                                else if (instruction[0] == "div")
                                {
                                    double value1 = stack.Pop();
                                    stack.Push(value1 * -1);
                                }

                                Console.Write("Stack = [");
                                foreach (double stackValue in stack)
                                {
                                    Console.Write(stackValue + ",");
                                }
                                Console.Write("]\n");
                                Console.Write("Locals = [");
                                foreach (double local in locals)
                                {
                                    Console.Write(local + ",");
                                }
                                Console.Write("]\n");

                                Console.WriteLine("---------");
                            }

                            noFalla = false;
                        }
                    }
                }
            } catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            
        }
    }
}