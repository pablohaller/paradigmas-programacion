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
            Stackalc stackalc = new Stackalc();
            Stack<double> stack = new Stack<double>();
            double[] locals = new double[stackalc.locals];

            string userinput = "ldc:1 ldc:2 ldc:3 stv:1 stv:2 stv:3 ldv:2 ldv:2 ldv:2 mul";
            string userInput2 = "ldv:2 ldv:2 ldv:2 mul";

            bool noFalla = true;
            while (noFalla)
            {
                if (stack.Count > stackalc.maxStack)
                {
                    Console.WriteLine("maxStack alcanzado");
                    noFalla = false;
                    break;
                }

                foreach (string opcode in userinput.Split(' ')) {
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
                    } else if (instruction[0] == "ldv")
                    {
                        stack.Push(locals[Int32.Parse(instruction[1])]);
                    } else if (instruction[0] == "mul")
                    {
                        double value2 = stack.Pop();
                        double value1 = stack.Pop();
                        stack.Push(value1 * value2);
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
}