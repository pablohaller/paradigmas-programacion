const parser = require("@babel/parser");
const evalType = (body) => {
  console.log(body);
};

const parsed = parser.parse("var x = 1+2; x = x + 3;");

evalType(parsed.program.body);
